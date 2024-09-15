//
//  TintColor.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import Foundation
import SwiftUI

struct TintColor: Identifiable{
    let id: UUID = .init()
    var color: String
    var value: Color
}
var tints : [TintColor] = [
    .init(color: "Blue", value: .blue),
    .init(color: "Pink", value: .pink),
    .init(color: "Purple", value: .purple),
    .init(color: "Brown", value: .brown),
    .init(color: "Orange", value: .orange),
    .init(color: "Yellow", value: .yellow),
    .init(color: "green", value: .green),
    .init(color: "Black", value: .black)
]

