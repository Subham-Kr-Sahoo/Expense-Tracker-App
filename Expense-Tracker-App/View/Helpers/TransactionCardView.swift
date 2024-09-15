//
//  TransactionCardView.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI

struct TransactionCardView: View {
    var transaction: Transaction
    var showsCategory:Bool = false
    var body: some View {
        HStack(spacing:12){
            Text("\(transaction.title.prefix(1))")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width:45,height:45)
                .background(transaction.color.gradient,in:.circle)
            VStack(alignment:.leading,spacing:4){
                Text(transaction.title)
                    .foregroundStyle(.primary)
                Text(transaction.remarks)
                    .font(.caption)
                    .foregroundStyle(Color.primary.secondary)
                Text(format(date: transaction.dateAdded, format: "dd MMM yyyy"))
                    .font(.caption2)
                    .foregroundStyle(.gray)
                Text(transaction.category)
                    .font(.caption2)
                    .padding(.horizontal,5)
                    .padding(.vertical,2)
                    .foregroundStyle(transaction.rawCategory == .income ? .black : .white)
                    .background(transaction.rawCategory == .income ? Color.green.gradient : Color.red.gradient ,in: .capsule)
                    .padding(2)
            }
            .lineLimit(1)
            .hSpacing(.leading)
            
            Text(currencyString(transaction.amount))
                .fontWeight(.semibold)
        }
            .padding(.horizontal,.screenWidth*0.035)
            .padding(.vertical, .screenWidth*0.02)
            .background(.background,in: .rect(cornerRadius:10))
    }
}

#Preview {
    //TransactionCardView(transaction: sampleTransactions[1])
    ContentView()
}
