//
//  RealBudgetUITests.swift
//  RealBudgetUITests
//
//  Created by Kevin Taniguchi on 10/11/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import XCTest

class RealBudgetUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override class func setUp() {
        super.setUp()
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        snapshot("00timeline")
        // Use recording to get started writing UI tests.
        
        app.buttons["Edit"].tap()
        snapshot("01currentState")
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Add new"]/*[[".cells[\"Add new\"].buttons[\"Add new\"]",".buttons[\"Add new\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("02addnew")
        let closeButton = app.buttons["Close"]
        closeButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Rent $1,100"]/*[[".cells[\"Rent $1,100\"].buttons[\"Rent $1,100\"]",".buttons[\"Rent $1,100\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("03edit")
        closeButton.tap()
        XCUIApplication().buttons["questionmark.circle"].tap()
        snapshot("04info")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
