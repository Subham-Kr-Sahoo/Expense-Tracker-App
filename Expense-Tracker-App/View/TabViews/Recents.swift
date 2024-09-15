//
//  Recents.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI
import SwiftData

struct Recents: View {
    @AppStorage("userName") private var userName : String = ""
    @State private var startDate : Date = .now.startOfMonth
    @State private var endDate : Date = .now.endOfMonth
    @State private var selectedCategory : Category = .expense
    @State private var showFilterView : Bool = false
    @Namespace private var animation
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            NavigationStack{
                ScrollView(.vertical){
                    LazyVStack(spacing:10 , pinnedViews:[.sectionHeaders]){
                        Section{
                            Button{
                                showFilterView = true
                            }label: {
                               Text("\(format(date: startDate, format: "dd - MMM yyyy")) to \(format(date: endDate, format: "dd - MMM YYYY"))")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }.hSpacing(.leading)
                            // card view
                            FilterTransactionView(startDate: startDate, endDate: endDate) { transactions in
                                CardView(
                                    income: total(transactions, category: .income),
                                    expenses:total(transactions, category: .expense)
                                )
                                customSegmentedControl()
                                    .padding(.bottom,.screenWidth*0.02)
                                
                                ForEach(transactions.filter({$0.category == selectedCategory.rawValue})){ transction in
                                    NavigationLink(value:transction){
                                        TransactionCardView(transaction: transction)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                        }header: {
                            HeaderView(size)
                        }
                    }.padding(15)
                }
                .background(.gray.opacity(0.1))
                .blur(radius: showFilterView ? 5 : 0)
                .disabled(showFilterView)
                .navigationDestination(for: Transaction.self) { transaction in
                    NewExpenseView(editTransaction: transaction)
                }
            }
            .overlay {
                    if showFilterView {
                        DateFilterView(start: startDate, end: endDate, onSubmit: {
                            start , end in
                            startDate = start
                            endDate = end
                            showFilterView = false
                        }, onClose: {
                            showFilterView = false
                        })
                            .transition(.move(edge: .leading))
                }
            }.animation(.snappy,value: showFilterView)
        }
    }
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing:10){
            VStack(alignment:.leading,spacing: 5){
                Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .padding(.leading,3)
                }
            }
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(headerScale(size, proxy: geometryProxy),anchor: .topLeading)
            }
            Spacer(minLength: 0)
            NavigationLink{
                NewExpenseView()
            }label: {
                Image(systemName:"plus")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width:.screenWidth*0.1,height:.screenWidth*0.1)
                    .background(.pink,in:.circle)
                    .contentShape(.circle)
            }
        }
        .padding(.bottom,userName.isEmpty ? .screenWidth*0.04:.screenWidth*0.02)
        .background{
            VStack(spacing:0){
                Rectangle()
                   .fill(.ultraThinMaterial)
                
                Divider()
            }
            .visualEffect { content, geometryProxy in
                content
                    .opacity(headerBGOpacity(geometryProxy))
            }
            .padding(.horizontal,-15)
            .padding(.top,-(safeArea.top+15))
         }
    }
    
    @ViewBuilder
    func customSegmentedControl() -> some View {
        HStack(spacing:0){
            ForEach(Category.allCases,id:\.rawValue){ category in
                Text(category.rawValue)
                    .frame(width:.screenWidth*0.45)
                      .font(.title3)
                      .fontWeight(.medium)
                      .hSpacing()
                      .padding(.leading,.screenWidth*0.02)
                      .padding(.vertical,.screenWidth*0.02)
                      .background{
                        if category == selectedCategory {
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }.contentShape(.capsule)
                      .onTapGesture {
                        withAnimation(.spring){
                            selectedCategory = category
                        }
                    }
            }
        }
        .background(.gray.opacity(0.15),in: .capsule)
        .padding(.top,5)
    }
    

    
    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY/15)
    }
    
    func headerScale(_ size:CGSize,proxy:GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        
        let progress = minY / screenHeight
        let scale = min(max(progress,0),1) * 0.6
        return 1+scale
    }
}

#Preview {
    ContentView()
}
