//
//  CloudKitManager.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 2/23/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import Foundation

import CloudKit
import Foundation

typealias CloudKitCompletion = (CKRecord?, Error) -> Void

final class CloudKitManager {
    static let shared = CloudKitManager()
    
    private let privateDatabase = CKContainer(identifier: "iCloud.RealBudget").privateCloudDatabase
    private let sharedDatabase = CKContainer(identifier: "iCloud.RealBudget").sharedCloudDatabase
    
    private init() { }
    
    // fetch all events
    
    // fetch a financial state with balance

    func deleteEvent(_ record: CKRecord, completion: @escaping (CKRecord.ID?, Error?) -> Void) {
        privateDatabase.delete(withRecordID: record.recordID, completionHandler: completion)
    }
    
    func mutateEvent(_ event: FinancialEvent, record: CKRecord, completion: @escaping (Error?) -> Void) {
        let updatedRecord = updateEvent(ckRecord: record, event: event)
        privateDatabase.save(updatedRecord) { (_, error) in
            completion(error)
        }
    }
    
    func mutateState(_ state: FinancialStateRecord, record: CKRecord, completion: @escaping (Error?) -> Void) {
        let updatedRecord = updateState(ckRecord: record, state)
        privateDatabase.save(updatedRecord) { (_, error) in
            completion(error)
        }
    }
    
    func loadFinancialState(completion: @escaping (FinancialStateRecord?) -> Void) {
        let query = CKQuery(recordType: FinancialStateRecord.ckKey, predicate: NSPredicate(value: true))
        let operation = CKQueryOperation(query: query)
        
        var state: FinancialStateRecord? = nil
        
        operation.queryCompletionBlock = { (cursor, error) in
            completion(state)
        }
        
        operation.recordFetchedBlock = { record in
            if let fetchedState = self.processState(record: record) {
                state = fetchedState
            }
        }
    }
    
    func loadEvents(completion: @escaping ([FinancialEvent]) -> Void) {
        let query = CKQuery(recordType: FinancialEvent.ckKey, predicate: NSPredicate(value: true))
        let operation = CKQueryOperation(query: query)
        
        var fetchedEvents = [FinancialEvent]()
        
        operation.queryCompletionBlock = { (cursor, error) in
            if let cursor = cursor {
                print(cursor)
            } else {
                completion(fetchedEvents)
            }
        }

        operation.recordFetchedBlock = { record in
            if let fetchedEvent = self.processEvent(record: record) {
                fetchedEvents.append(fetchedEvent)
            }
        }

        self.privateDatabase.add(operation)
    }
        
    func fetchExisting(shareID: CKRecord.ID, completion: @escaping ([CKRecord.ID: CKRecord]?, Error?) -> Void) {
        let fetchShareOp = CKFetchRecordsOperation(recordIDs: [shareID])
        
        fetchShareOp.fetchRecordsCompletionBlock = completion
        
        CKContainer.default().sharedCloudDatabase.add(fetchShareOp)
    }
    
    func makeNewState(_ state: FinancialStateRecord, completion: @escaping (Error?) -> Void) {
        let newRecordId = CKRecord.ID(recordName: state.identifier)
        let newRecord = CKRecord(recordType: FinancialStateRecord.ckKey, recordID: newRecordId)
        let updatedRecord = updateState(ckRecord: newRecord, state)
        privateDatabase.save(updatedRecord) { (_, error) in
            completion(error)
        }
    }
    
    func makeNewEvent(_ event: FinancialEvent, completion: @escaping (Error?) -> Void) {
        let newRecordId = CKRecord.ID(recordName: event.id)
        let newRecord = CKRecord(recordType: FinancialEvent.ckKey, recordID: newRecordId)
        let updatedRecord = updateEvent(ckRecord: newRecord, event: event)
        privateDatabase.save(updatedRecord) { (_, error) in
            completion(error)
        }
    }
}

//        func saveNew(person: Person, completionHandler: @escaping (Error?) -> Void) {
//            let newRecordId = CKRecord.ID(recordName: person.identifier)
//            let newRecord = CKRecord(recordType: Person.ckKey, recordID: newRecordId)
//
//            let updatedRecord = updateRecord(ckRecord: newRecord, person: person)
//
//            privateDatabase.save(updatedRecord) { (_, error) in
//                completionHandler(error)
//            }
//        }

/// convenience
extension CloudKitManager {
    private func updateEvent(ckRecord: CKRecord, event: FinancialEvent) -> CKRecord {
        ckRecord[FinancialEvent.identifier] = event.id
        ckRecord[FinancialEvent.name] = event.name
        ckRecord[FinancialEvent.value] = event.value
        ckRecord[FinancialEvent.type] = event.type.rawValue
        ckRecord[FinancialEvent.frequency] = event.frequency.rawValue
        ckRecord[FinancialEvent.notes] = event.notes
        ckRecord[FinancialEvent.startDate] = event.startDate
        
        if let endDate = event.endDate {
            ckRecord[FinancialEvent.endDate] = endDate
        }
        
        return ckRecord
    }
    
    private func save(record: CKRecord) {
        privateDatabase.save(record, completionHandler: { (_, error) in
            print(error?.localizedDescription ?? "")
        })
    }
    
    private func processEvent(record: CKRecord) -> FinancialEvent? {
        guard let identifier = record[FinancialEvent.identifier] as? String,
            let name = record[FinancialEvent.name] as? String,
            let rawType = record[FinancialEvent.type] as? Int,
            let type = FinancialEventType(rawValue: rawType),
            let value = record[FinancialEvent.value] as? Int,
            let rawFrequency = record[FinancialEvent.frequency] as? Int,
            let frequency = Frequency(rawValue: rawFrequency),
            let startDate = record[FinancialEvent.startDate] as? Date
        else { return nil }
        
        let endDate = record[FinancialEvent.endDate] as? Date
        let notes = record[FinancialEvent.notes] as? String
        
        return FinancialEvent(id: identifier,
                              type: type,
                              name: name,
                              value: value,
                              frequency: frequency,
                              notes: notes,
                              startDate: startDate,
                              endDate: endDate)
    }
    
    private func updateState(ckRecord: CKRecord, _ state: FinancialStateRecord) -> CKRecord {
        ckRecord[FinancialStateRecord.identifier] = state.identifier
        ckRecord[FinancialStateRecord.balance] = state.balance
        
        return ckRecord
    }
    
    private func processState(record: CKRecord) -> FinancialStateRecord? {
        guard let identifier = record[FinancialStateRecord.identifier] as? String,
            let balance = record[FinancialStateRecord.balance] as? Int else { return nil }
        
        return FinancialStateRecord(identifier: identifier, balance: balance)
    }
}
