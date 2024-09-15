//
//  ContentView.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstTime") private var isFirstTime : Bool = true
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled : Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground : Bool = false
    //Active Tab
    @State private var activeTab: Tab = .recents
    var body: some View {
        LockView(lockType: .biometric, lockPin: "", isEnabled: isAppLockEnabled, lockWhenAppGoesBackground: lockWhenAppGoesBackground) {
            TabView(selection:$activeTab){
                Recents()
                    .tag(Tab.recents)
                    .tabItem { Tab.recents.tabContent }
                Search()
                    .tag(Tab.search)
                    .tabItem { Tab.search.tabContent }
                Graphs()
                    .tag(Tab.charts)
                    .tabItem { Tab.charts.tabContent }
               Settings()
                    .tag(Tab.settings)
                    .tabItem { Tab.settings.tabContent }
                
            }.sheet(isPresented: $isFirstTime, content: {
                IntroScreen()
                    .interactiveDismissDisabled()
            })
        }
        
    }
}

#Preview {
    ContentView()
}
