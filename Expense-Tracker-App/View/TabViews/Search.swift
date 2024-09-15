//
//  Search.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI
import Combine

struct Search: View {
    @State private var searchText : String = ""
    @State private var filterText : String = ""
    @State private var selectedCategory : Category? = nil
    //1. publisher publishes new update
    let searchPublisher = PassthroughSubject<String,Never>()
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                LazyVStack(spacing:12){
                    FilterTransactionView(category: selectedCategory, searchText: filterText) { transactions in
                        ForEach(transactions){ transaction in
                            NavigationLink {
                                NewExpenseView(editTransaction: transaction)
                            }label:{
                                TransactionCardView(transaction: transaction,showsCategory: true)
                            }
                            .buttonStyle(.plain)
                            
                        }
                    }
                }.padding(.screenWidth*0.05)
            }
            .searchable(text: $searchText)
            .overlay(content: {
                    ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
                    .opacity(searchText.isEmpty ? 0.9 : 0)
                })
            //2. when new update happens publisher publishes it
            .onChange(of: searchText, { oldValue, newValue in
                searchPublisher.send(newValue)
            })
            //3. but the filter text gets it after 0.3 seconds delay after typing stops
            // it is called combine debounce method
            .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
                filterText = text
                print(filterText)
            })
            .navigationTitle("Search")
            .background(.gray.opacity(0.1))
            .toolbar{
                ToolbarItem(placement:.topBarTrailing){
                    ToolBarContent()
                }
                
            }
            
        }
    }
    
    @ViewBuilder
    func ToolBarContent() -> some View {
        Menu{
            Button{
                selectedCategory = nil
            }label: {
                HStack{
                    Text("Both")
                    
                    if selectedCategory == nil{
                        Image(systemName: "checkmark")
                    }
                }
            }
            ForEach(Category.allCases , id: \.rawValue){ category in
                Button{
                    selectedCategory = category
                }label: {
                    HStack{
                        Text(category.rawValue)
                        
                        if selectedCategory == category{
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }label: {
            Image(systemName: "slider.vertical.3")
        }
    }
}

#Preview {
    Search()
}
