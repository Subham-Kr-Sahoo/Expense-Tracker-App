//
//  ChartModel.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 25/06/24.
//

import SwiftUI

struct chartGroup : Identifiable {
    let id: UUID = .init()
    var date : Date
    var categories : [chartCategory]
    var totalIncome : Int
    var totalExpense : Int
}

struct chartCategory : Identifiable {
    let id: UUID = .init()
    var totalValue : Int
    var category : Category
}

