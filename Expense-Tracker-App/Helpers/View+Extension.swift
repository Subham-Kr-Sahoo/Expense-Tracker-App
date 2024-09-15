//
//  View+Extension.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
        .frame(maxWidth: .screenWidth ,alignment: .leading)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
        .frame(maxHeight:.screenHeight ,alignment: .leading)
    }
    
    var safeArea: UIEdgeInsets {
        if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene){
            return windowScene.keyWindow?.safeAreaInsets ?? .zero
        }
        return .zero
    }
    
    func format(date:Date , format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from:date)
    }
    
    func currencyString(_ value: Int,allowedDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = allowedDigits
        
        return formatter.string(from: .init(value: value)) ?? ""
    }
    
    var currencySymbol: String {
        let locale = Locale.current
        return locale.currencySymbol ?? ""
    }
    
    func total(_ transactions : [Transaction] , category : Category) -> Int {
        return transactions.filter({$0.category == category.rawValue}).reduce(.zero) { partialResult, transaction in
            return partialResult + transaction.amount
        }
    }
}
