//
//  Graphs.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI
import Charts
import SwiftData

struct Graphs: View {
    @Query(animation: .snappy) private var transactions : [Transaction]
    @State private var chartGroups : [chartGroup] = []
    var body: some View {
        NavigationStack {
            ScrollView(.vertical){
                LazyVStack(spacing: 10){
                    chartView()
                        .frame(height:.screenWidth*0.7)
                        .padding(10)
                        .padding(.top,10)
                        .background(.background,in:.rect(cornerRadius:10))
                    
                    ForEach(chartGroups){ group in
                        VStack(alignment:.leading,spacing: 10){
                            Text(format(date: group.date, format: "MMM yy"))
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .hSpacing(.leading)
                            NavigationLink{
                                listOfExpenses(month: group.date)
                            } label:{
                                CardView(income: group.totalIncome , expenses: group.totalExpense)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Graphs")
            .background(.gray.opacity(0.15))
            .onAppear{
            createChartGroup()
            }
        }
    }
    @ViewBuilder
    func chartView() -> some View {
        Chart{
            ForEach(chartGroups){group in
                ForEach(group.categories){chart in
                    BarMark(x:.value("Month", format(date: group.date, format: "MMM yy"))
                            ,y:.value(chart.category.rawValue, chart.totalValue),
                            width: 20
                    )
                    .position(by: .value("Category", chart.category.rawValue),axis:.horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom,alignment: .trailing)
        .chartYAxis(content: {
            AxisMarks(position: .leading){ value in
                let value = value.as(Int.self) ?? 0
                AxisGridLine()
                AxisTick()
                AxisValueLabel{
                    Text(axilLable(value))
                }
            }
        })
        .chartForegroundStyleScale(range: [Color.green.gradient,Color.red.gradient])
    }
    
    func createChartGroup() {
        Task.detached(priority: .high) {
            
            //1. grouping of transaction by month
            let calender = Calendar.current
            let groupedByDate = Dictionary(grouping: transactions) { transaction in
                let components = calender.dateComponents([.month,.year], from: transaction.dateAdded)
                
                return components
            }
            //2. sorting them in descending order
            let sortedGroups = groupedByDate.sorted {
                let date1 = calender.date(from: $0.key) ?? .init()
                let date2 = calender.date(from: $1.key) ?? .init()
                
                return calender.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            //3. converting them to a chart group model
            let chartGroups = sortedGroups.compactMap{dict -> chartGroup? in
                let date = calender.date(from: dict.key) ?? .init()
                let income = dict.value.filter({$0.category == Category.income.rawValue})
                let expense = dict.value.filter({$0.category == Category.expense.rawValue})
                
                let incomeTotal = total(income, category: .income)
                let expenseTotal = total(expense, category: .expense)
                
                return .init(date: date,
                             categories: [.init(totalValue: incomeTotal, category: .income),
                                          .init(totalValue: expenseTotal, category: .expense)],
                             totalIncome: incomeTotal,
                             totalExpense: expenseTotal
                )
            }
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
    }
    // int 30000 to 30k
    func axilLable(_ value : Int) -> String {
        let kValue = value / 1000
        return value<1000 ? "\(value)" : "\(kValue)K"
    }
    
}
struct listOfExpenses : View {
    let month : Date
    var body: some View {
        ScrollView(.vertical){
            LazyVStack(spacing: 15){
                Section{
                    FilterTransactionView(startDate: month.startOfMonth, endDate:month.endOfMonth,category: .income) { transactions in
                        ForEach(transactions){transaction in
                            NavigationLink{
                                NewExpenseView(editTransaction: transaction)
                            }label:{
                                TransactionCardView(transaction: transaction)
                                    .padding(.horizontal,.screenWidth*0.02)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }header: {
                    Text("Income")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                        .padding(.leading,.screenWidth*0.03)
                }
                
                Section{
                    FilterTransactionView(startDate: month.startOfMonth, endDate:month.endOfMonth,category: .expense) { transactions in
                        ForEach(transactions){transaction in
                            NavigationLink{
                                NewExpenseView(editTransaction: transaction)
                            }label:{
                                TransactionCardView(transaction: transaction)
                                    .padding(.horizontal,.screenWidth*0.02)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }header: {
                    Text("Expense")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                        .padding(.leading,.screenWidth*0.03)
                }
            }
        }.background(.gray.opacity(0.15))
        .navigationTitle(format(date: month, format: "MMM yy"))
        
    }
}

#Preview {
    Graphs()
}
