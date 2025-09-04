//
//  PlayView.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/18/20.
//

import SwiftUI

// Shared state across all tabs
class ContentState: ObservableObject {
    @Published var selectedContentType: ContentType = .withContent
    @Published var selectedColor: Color = .white
    @Published var selectedImage: UIImage?
    
    enum ContentType: String, CaseIterable {
        case withContent = "With Content"
        case withColor = "With Color"
        case withImage = "With Image"
    }
}

struct NewPlayView: View {
    var tabCount: Int
    @ObservedObject var tabs: TabsViewModel
    @State private var selectedTab = "dashboard"
    @State private var searchText = ""
    @State private var minimizeBehavior: TabViewMinimizeBehavior = .onScrollDown
    @StateObject private var sharedContentState = ContentState()
    
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
                        TabContentSelection(sharedState: sharedContentState)
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
                        TabContentSelection(sharedState: sharedContentState)
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
                        TabContentSelection(sharedState: sharedContentState)
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
                        TabContentSelection(sharedState: sharedContentState)
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
                        TabContentSelection(sharedState: sharedContentState)
                    }
                }
            }
        }
        .accentColor(tabs.tabTintColor)
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
        .tabBarMinimizeBehavior(convertToSwiftUIMinimizeBehavior(tabs.tabBarMinimizeBehavior))
        .tabViewSearchActivation(.searchTabSelection)
        .modifier(BottomAccessoryModifier(hasBottomAccessory: tabs.hasBottomAccessory))
        .navigationBarTitle("Your Tab Bar")
    }
    
}

struct TabContentSelection: View {
    @ObservedObject var sharedState: ContentState
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Content Type", selection: $sharedState.selectedContentType) {
                ForEach(ContentState.ContentType.allCases, id: \.self) { contentType in
                    Text(contentType.rawValue).tag(contentType)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            Group {
                switch sharedState.selectedContentType {
                case .withContent:
                    NovelExcerptView()
                case .withColor:
                    ColorDemoView()
                case .withImage:
                    UploadDemoView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct BottomAccessoryModifier: ViewModifier {
    let hasBottomAccessory: Bool
    
    func body(content: Content) -> some View {
        if hasBottomAccessory {
            content.tabViewBottomAccessory {
                ZStack {
                    Color(.white.opacity(0.1))
                        .glassEffect(.regular)
                        .cornerRadius(.infinity)
                    HStack(alignment: .center, spacing: 0) {
                        Image(systemName: "app.gift.fill")
                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 8))
                        Text("Love the App?")
                            .font(.caption)
                            .foregroundStyle(.primary)
                        Spacer()
                        Link(destination: URL(string: "https://apps.apple.com/us/app/id1533863571?mt=8&action=write-review")!) {
                            Text("Rate")
                            .foregroundStyle(.primary)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 8)
                }
            }
        } else {
            content
        }
    }
}

func convertToSwiftUIMinimizeBehavior(_ option: TabBarMinimizeBehaviorOption) -> TabBarMinimizeBehavior {
    switch option {
    case .onScrollDown:
        return .onScrollDown
    case .onScrollUp:
        return .onScrollUp
    case .automatic:
        return .automatic
    case .never:
        return .never
    }
}

struct SearchTabView: View {
    let label: String
    let contentText: String
    @Binding var searchText: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.primary).opacity(0.3)
            }
            .padding()
        }
        .navigationTitle(label)
        .searchable(text: $searchText)
    }
}


struct NewPlayView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlayView(tabCount: 5, tabs: TabsViewModel())
    }
}
