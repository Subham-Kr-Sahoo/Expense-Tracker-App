//
//  IntroScreen.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI

struct IntroScreen: View {
    @AppStorage("isFirstTime") private var isFirstTime : Bool = true
    var body: some View {
        VStack(spacing:15){
            Text("What's new in the\nExpense tracker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.leading)
                .padding(.top,.screenWidth*0.15)
                .padding(.bottom,.screenWidth*0.1)
            
            // points view
            
            VStack(alignment: .leading, spacing: 25){
                PointView(symbol:"indianrupeesign", title: "Transactions", subtitle:"keep track of your earnings and expenses")
                PointView(symbol: "chart.bar.fill", title: "Visual Charts", subtitle: "view your transactions using eye-catching graphic representations")
                PointView(symbol: "magnifyingglass", title: "Advance Filters", subtitle: "Find the expenses you wantby advance search and filtering")
            }
            .frame(maxWidth:.screenWidth ,alignment: .leading)
            .padding(.horizontal,.screenWidth*0.06)
            Spacer(minLength:10)
            Button{
                isFirstTime = false
            }label: {
                Text("Continue")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width:.screenWidth*0.75)
                    .frame(height:.screenHeight*0.07)
                    .background(appTint.gradient,in:.rect(cornerRadius:20))
                    .contentShape(.rect)
                    
            }
            Spacer().frame(height:20)
        }
    }
    @ViewBuilder
    func PointView(symbol:String , title:String , subtitle:String) -> some View {
        HStack(spacing:15){
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint.gradient)
                .frame(width: .screenWidth*0.17)
        
            VStack(alignment:.leading,spacing:6){
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    IntroScreen()
}
