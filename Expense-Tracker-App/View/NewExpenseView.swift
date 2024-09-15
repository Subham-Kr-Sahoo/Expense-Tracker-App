//
//  NewExpenseView.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 24/06/24.
//

import SwiftUI

struct NewExpenseView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var editTransaction : Transaction?
    @State private var title : String = ""
    @State private var remarks : String = ""
    @State private var amount : Int = 0
    @State private var dateAdded : Date = .now
    @State private var category : Category = .expense
    @State var tint : TintColor = tints.randomElement()!
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing:15){
                Text("preview")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                .hSpacing(.leading)
                TransactionCardView(transaction: .init(title: title.isEmpty ? "Title" : title,
                                                       remarks: remarks.isEmpty ? "Remarks" : remarks,
                                                       amount: amount,
                                                       dateAdded: dateAdded,
                                                       category: category,
                                                       tintColor:tint))
                
                customSection("Title", "Ipad", value: $title)
                
                customSection("Remarks", "Apple Product!", value: $remarks)
                
                VStack(alignment:.leading, spacing:10){
                    Text("Amount & Category")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .hSpacing(.leading)
                    
                    HStack(spacing:15){
                        HStack(spacing:4){
                            Text(currencySymbol)
                                .font(.title3)
                                .fontWeight(.medium)
                            TextField("000", value: $amount, formatter: numberFormatter)
                                .keyboardType(.numberPad)
                        }
                        .padding(.horizontal,15)
                        .padding(.vertical,12)
                        .background(.background,in:.rect(cornerRadius:8))
                        .frame(maxWidth: .screenWidth/2.5)
                            
                        
                        CategoryCheckBox()
                    }
                }
                
                VStack(alignment:.leading,spacing: 10){
                    Text("Date")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .hSpacing(.leading)
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .padding(.horizontal,5)
                        .padding(.vertical,12)
                        .background(.background,in:.rect(cornerRadius:12))
                }
                
            }
             .padding(.horizontal , .screenWidth*0.04)
             .padding(.top ,.screenWidth * 0.01)
        }
        .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") Transactions")
        .background(.gray.opacity(0.15))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing){
                Button("Save",action: save)
            }
        })
        .onAppear(perform: {
            if let editTransaction {
                title = editTransaction.title
                remarks = editTransaction.remarks
                dateAdded = editTransaction.dateAdded
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
                amount = editTransaction.amount
                if let tint = editTransaction.tint{
                    self.tint = tint
                }
                
            }
        })
    }
    
    func save(){
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remarks = remarks
            editTransaction?.amount = amount
            editTransaction?.category = category.rawValue
            editTransaction?.dateAdded = dateAdded
            
        }else{
            let transaction = Transaction(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            
            context.insert(transaction)
        }
        
        dismiss()
    }
    
    @ViewBuilder
    func customSection(_ title:String ,_ hint:String , value:Binding<String>) -> some View {
        VStack(alignment:.leading , spacing:10){
            Text(title)
                .font(.title3)
                .foregroundStyle(.secondary)
                .hSpacing(.leading)
            TextField(hint, text: value)
                .padding(.horizontal,5)
                .padding(.vertical,12)
                .background(.background,in:.rect(cornerRadius:8))
                .autocorrectionDisabled()
        }
    }
    
    @ViewBuilder
    func CategoryCheckBox() -> some View {
        HStack(spacing: 10){
            ForEach(Category.allCases,id: \.rawValue){category in
                HStack(spacing:5){
                    ZStack{
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(appTint)
                        }
                    }
                    Text(category.rawValue)
                        .font(.caption)
                        
                }
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.easeInOut(duration:0.1)){
                        self.category = category
                    }
                }
                
                
            }
        }
        .padding(.horizontal,15)
        .padding(.vertical,12)
        .hSpacing(.leading)
        .background(.background,in:.rect(cornerRadius:8))
    }
    
    var numberFormatter : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter
    }
}

#Preview {
    NavigationStack {
        NewExpenseView()
    }
}
