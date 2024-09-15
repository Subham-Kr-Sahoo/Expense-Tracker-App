//
//  CardView.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI

struct CardView: View {
    var income: Int
    var expenses: Int
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius:15)
                .fill(.background)
            
            VStack(spacing:0){
                HStack(spacing:12){
                    Text("\(currencyString(income - expenses))")
                        .font(.title.bold())
                        .foregroundStyle(Color.primary)
                    Image(systemName: expenses>income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundStyle(expenses>income ? .pink : .green)
                }
                .padding(.bottom,.screenWidth*0.05)
                
                HStack(spacing:0){
                    ForEach(Category.allCases,id:\.rawValue){ category in
                        let symbolImage = category == .income ? "arrow.down" : "arrow.up"
                        let tint = category == .income ? Color.green : Color.pink
                        HStack(spacing:10){
                            Image(systemName:symbolImage)
                                .font(.callout.bold())
                                .foregroundStyle(tint)
                                .frame(width:.screenWidth*0.1,height: .screenWidth*0.1)
                                .background{
                                    Circle()
                                        .fill(tint.opacity(0.25).gradient)
                                }
                            VStack(alignment: .leading, spacing: 4){
                                Text(category.rawValue)
                                    .font(.title3)
                                    .foregroundStyle(.gray)
                                Text(currencyString(category == .income ? income : expenses , allowedDigits:0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.primary)
                            }
                            
                            if category == .income {
                                Spacer(minLength: 10)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal,.bottom], .screenWidth*0.1)
            .padding(.top,.screenWidth*0.05)
            
        }
    }
}

#Preview {
    CardView(income: 50000, expenses: 43000)
}
