//
//  PlayView.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/18/20.
//

import SwiftUI

struct DefaultTabView: View {
    let label: String
    let contentText: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(label)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(contentText)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle(label)
    }
}

struct SearchTabView: View {
    let label: String
    let contentText: String
    @Binding var searchText: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(label)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(contentText)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle(label)
        .searchable(text: $searchText)
    }
}

struct NewPlayView: View {
    var tabCount: Int
    @ObservedObject var tabs: TabsViewModel
    @State private var selectedTab = "dashboard"
    @State private var searchText = ""
    @State private var minimizeBehavior: TabViewMinimizeBehavior = .automatic
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1
            if tabCount >= 1 {
                if tabCount == 1 && tabs.hasSearchRole {
                    Tab(tabs.tab1Label, systemImage: tabs.tab1Icon, value: "tab1", role: .search) {
                        SearchTabView(label: tabs.tab1Label, contentText: "Tab 1 Content", searchText: $searchText)
                    }
                } else {
                    Tab(tabs.tab1Label, systemImage: tabs.tab1Icon, value: "tab1") {
                        DefaultTabView(label: tabs.tab1Label, contentText: "Tab 1 Content")
                    }
                }
            }
            
            // Tab 2
            if tabCount >= 2 {
                if tabCount == 2 && tabs.hasSearchRole {
                    Tab(tabs.tab2Label, systemImage: tabs.tab2Icon, value: "tab2", role: .search) {
                        SearchTabView(label: tabs.tab2Label, contentText: "Tab 2 Content", searchText: $searchText)
                    }
                } else {
                    Tab(tabs.tab2Label, systemImage: tabs.tab2Icon, value: "tab2") {
                        DefaultTabView(label: tabs.tab2Label, contentText: "Tab 2 Content")
                    }
                }
            }
            
            // Tab 3
            if tabCount >= 3 {
                if tabCount == 3 && tabs.hasSearchRole {
                    Tab(tabs.tab3Label, systemImage: tabs.tab3Icon, value: "tab3", role: .search) {
                        SearchTabView(label: tabs.tab3Label, contentText: "Tab 3 Content", searchText: $searchText)
                    }
                } else {
                    Tab(tabs.tab3Label, systemImage: tabs.tab3Icon, value: "tab3") {
                        DefaultTabView(label: tabs.tab3Label, contentText: "Tab 3 Content")
                    }
                }
            }
            
            // Tab 4
            if tabCount >= 4 {
                if tabCount == 4 && tabs.hasSearchRole {
                    Tab(tabs.tab4Label, systemImage: tabs.tab4Icon, value: "tab4", role: .search) {
                        SearchTabView(label: tabs.tab4Label, contentText: "Tab 4 Content", searchText: $searchText)
                    }
                } else {
                    Tab(tabs.tab4Label, systemImage: tabs.tab4Icon, value: "tab4") {
                        DefaultTabView(label: tabs.tab4Label, contentText: "Tab 4 Content")
                    }
                }
            }
            
            // Tab 5
            if tabCount >= 5 {
                if tabCount == 5 && tabs.hasSearchRole {
                    Tab(tabs.tab5Label, systemImage: tabs.tab5Icon, value: "tab5", role: .search) {
                        SearchTabView(label: tabs.tab5Label, contentText: "Tab 5 Content", searchText: $searchText)
                    }
                } else {
                    Tab(tabs.tab5Label, systemImage: tabs.tab5Icon, value: "tab5") {
                        DefaultTabView(label: tabs.tab5Label, contentText: "Tab 5 Content")
                    }
                }
            }
        }
        .accentColor(tabs.tabTintColor) // Selected tab color
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            let normalItemAppearance = UITabBarItemAppearance()
            normalItemAppearance.normal.iconColor = UIColor(tabs.tabItemColor)
            normalItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(tabs.tabItemColor)] // Unselected text color
            appearance.stackedLayoutAppearance = normalItemAppearance
            appearance.inlineLayoutAppearance = normalItemAppearance
            appearance.compactInlineLayoutAppearance = normalItemAppearance
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.automatic)
        .tabViewSearchActivation(.searchTabSelection)
        .tabViewBottomAccessory {
            // Bottom Accessory Demo
            HStack {
                Image(systemName: "app.gift.fill")
                Text("Love the App?")
                    .font(.caption)
                Spacer()
                Button("Rate") {
                    // Play action
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .navigationBarTitle("Your Tab Bar")
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
            Link("SF Symbols 6.0", destination: URL(string: "https://developer.apple.com/sf-symbols/")!)
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

struct NewPlayView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlayView(tabCount: 5, tabs: TabsViewModel())
    }
}
