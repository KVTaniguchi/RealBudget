//
//  AboutView.swift
//  RealBudget
//
//  Created by Kevin Taniguchi on 10/12/20.
//  Copyright © 2020 Kevin Taniguchi. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Text("From the developer").font(.largeTitle).padding()
            Text(about).padding()
            Link("Privacy Policy and Terms of Service",
                 destination: URL(string: "https://site-12695-2289-5953.mystrikingly.com")!)
                .padding()
        }
    }
    
    var about: String {
        """
        This app is for educational and entertainment purposes only.

        I’ve tried a lot of financial apps that want you to give up your bank account passwords so they can try to access your account info.  Then they try to analyze every transaction in order to give you a picture of how you are spending money.

        But let’s face it, those apps are just terrible at getting your financial data.  Most of the time, they ask you over and over to enter in bank passwords because the banks, rightly so, don’t trust these apps and want your authorization every.single.time.  And even when they do get access, the transaction info is often so cryptic that you end up having to manually categorize half the transactions.  Yuck.

        Besides, who really wants to give the keys to their bank accounts over to total strangers?

        What I really need is a way to predict and plan out my budget, not find every instance of how much I spent on coffeeshops.

        So I created this app to record and predict what my balance would be close to in the future, given known expenses and incomes.  It’s pretty simple math and easier than a spreadsheet.
        """
    }
}
