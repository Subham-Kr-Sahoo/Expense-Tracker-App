//
//  Expense_Tracker_AppApp.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI

@main
struct Expense_Tracker_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for:[Transaction.self])
    }
}
