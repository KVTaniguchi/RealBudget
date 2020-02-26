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
        
    
//        func mutate(person: Person, completion: @escaping (Error?) -> Void) {
//
//            fetchRecord(identifier: person.identifier) { [weak self] (records, error) in
//                guard let record = recordsRealBudget?.first else {
//                    completion(error)
//                    return
//                }
//
//                self?.update(person: person, record: record) { error in
//                    completion(error)
//                }
//            }
//        }
//
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
//
//        func fetchRecord(identifier: String, completionHandler: @escaping ([CKRecord]?, Error?) -> Void) {
//            let idPredicate = NSPredicate(format: "identifier == %@", identifier)
//            let ckQuery = CKQuery(recordType: Person.ckKey, predicate: idPredicate)
//            privateDatabase.perform(ckQuery, inZoneWith: nil, completionHandler: completionHandler)
//        }
//
//        func delete(record: CKRecord, completionHandler: @escaping (CKRecord.ID?, Error?) -> Void) {
//            privateDatabase.delete(withRecordID: record.recordID, completionHandler: completionHandler)
//        }
//
//        func update(person: Person, record: CKRecord, completion: @escaping (Error?) -> Void) {
//            let updatedRecord = updateRecord(ckRecord: record, person: person)
//
//            privateDatabase.save(updatedRecord) { (record, error) in
//                completion(error)
//            }
//        }
        
//        func loadSavedConsumables(completion: @escaping ([Person], Error?) -> Void) {
//            let query = CKQuery(recordType: Person.ckKey, predicate: NSPredicate(value: true))
//            let operation = CKQueryOperation(query: query)
//
//            var fetchedPeople = [Person]()
//
//            operation.queryCompletionBlock = { (cursor, error) in
//                if let cursor = cursor {
//                    print(cursor)
//                } else if let error = error {
//                    completion([], error)
//                } else {
//                    completion(fetchedPeople, error)
//                }
//            }
//
//            operation.recordFetchedBlock = { record in
//                if let fetchedPerson = self.process(record: record) {
//                    fetchedPeople.append(fetchedPerson)
//                }
//            }
//
//            self.privateDatabase.add(operation)
//        }
        
        func fetchExisting(shareID: CKRecord.ID, completion: @escaping ([CKRecord.ID: CKRecord]?, Error?) -> Void) {
            let fetchShareOp = CKFetchRecordsOperation(recordIDs: [shareID])
            
            fetchShareOp.fetchRecordsCompletionBlock = completion
            
            CKContainer.default().sharedCloudDatabase.add(fetchShareOp)
        }
    }

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
//
//    private func process(record: CKRecord) -> Person? {
//        guard let identifier = record[Person.identifier] as? String,
//            let firstName = record[Person.firstNameKey] as? String,
//            let lastName = record[Person.lastNameKey] as? String
//        else { return nil }
//
//        let middleName = record[Person.middleNameKey] as? String
//        let notes = record[Person.notes] as? String
//        let email = record[Person.email] as? String
//        let phone = record[Person.phone] as? String
//        let location = record[Person.location] as? String
//        let company = record[Person.company] as? String
//        let occupation = record[Person.occupation] as? String
//        let shortDescription = record[Person.shortDescription] as? String
//        let ranking = record[Person.ranking] as? Int ?? 0
//
//        let associatedIds = record[Person.associates] as? [String]
//
//        return Person(identifier: identifier,
//                      firstName: firstName,
//                      lastName: lastName,
//                      middleName: middleName,
//                      notes: notes,
//                      email: email,
//                      phoneNumber: phone,
//                      location: location,
//                      companyName: company,
//                      occupation: occupation,
//                      possibleAssociates: [],
//                      associateIds: associatedIds,
//                      shortDescription: shortDescription,
//                      ranking: ranking)
//    }
}
