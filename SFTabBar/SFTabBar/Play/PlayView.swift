//
//  PlayView.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/18/20.
//

import SwiftUI

struct PlayView: View {
    
    var tabCount: Int
    
    @ObservedObject var tabs: TabsViewModel

    var body: some View {
        TabView {
            if tabCount >= 1 {
            TabItem(label: tabs.tab1Label, symbol: tabs.tab1Icon)
            }
            if tabCount >= 2 {
            TabItem(label: tabs.tab2Label, symbol: tabs.tab2Icon)
            }
            if tabCount >= 3 {
            TabItem(label: tabs.tab3Label, symbol: tabs.tab3Icon)
            }
            if tabCount >= 4 {
            TabItem(label: tabs.tab4Label, symbol: tabs.tab4Icon)
            }
            if tabCount >= 5 {
            TabItem(label: tabs.tab5Label, symbol: tabs.tab5Icon)
            }
        }
        .accentColor(tabs.tabTintColor)
        .onAppear(perform: fetchTabBarColor)
        .navigationBarTitle("Your Tab Bar")
    }
    
    private func fetchTabBarColor() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(tabs.tabBarColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(tabs.tabItemColor)
        }
}

struct TabItem: View {
    
    var label: String
    var symbol: String
    
    var body: some View {
        DocumentionView()
            .tabItem {
                Image(systemName: symbol)
                Text(label)
            }
    }
}

struct DocumentionView: View {
    var body: some View {
        List {
            Section(header: Text("")) {
            Text("Your Tab Bar is alive! You can use the Tab Bar below to check out what you created or grab a screenshot for comps.")
                .font(.callout)
                .padding(.vertical, 4.0)
            }
            Section(header: Text("Documentation")) {
            Link("SF Symbols 2.0", destination: URL(string: "https://developer.apple.com/sf-symbols/")!)
            Link("Apple HIG Tab Bars", destination: URL(string: "https://developer.apple.com/design/human-interface-guidelines/ios/bars/tab-bars/")!)
            Link("TabView()", destination: URL(string: "https://developer.apple.com/documentation/swiftui/tabview")!)
                Link(".tabItem", destination: URL(string: "https://developer.apple.com/documentation/swiftui/tabview/tabitem(_:)")!)
            }
            Section(header: Text("Notice")) {
            Text("The same view is created for all tabs in this demo. New views/content will not show as you tap your individual .tabItems")
                .font(.footnote)
                .padding(.vertical, 4.0)
            }
        }
        .accentColor(.pink)
        .listStyle(InsetGroupedListStyle())
    }
    
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(tabCount: 5, tabs: TabsViewModel())
    }
}
