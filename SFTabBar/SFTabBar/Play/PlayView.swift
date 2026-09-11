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
    @State private var selectedTab: String
    @State private var searchText = ""
    @StateObject private var sharedContentState = ContentState()

    init(tabCount: Int, tabs: TabsViewModel) {
        self.tabCount = tabCount
        self.tabs = tabs

        // Land on the first tab inside the capsule rather than tab 0, which
        // may be the detached search or prominent tab.
        //
        // This matches the static preview, which highlights the first capsule
        // tab, and it avoids an iOS 27.0 (24A5408d) glitch: when a detached
        // tab is selected on first load, the minimized tab bar renders that
        // tab's icon in the bar as if it were a normal member and leaves the
        // detached button untinted. Any later selection change fixes it.
        let firstCapsuleTab = (0..<tabCount).first { $0 != tabs.detachedIndex } ?? 0
        _selectedTab = State(initialValue: "tab\(firstCapsuleTab)")
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(0..<tabCount, id: \.self) { index in
                let config = tabs.tabs[index]

                if config.role == .search {
                    Tab(config.label, systemImage: config.icon, value: "tab\(index)", role: .search) {
                        SearchTabView(label: config.label, contentText: "Tab \(index + 1) Content", searchText: $searchText)
                    }
                } else {
                    Tab(config.label, systemImage: config.icon, value: "tab\(index)", role: config.role.swiftUIRole) {
                        TabContentSelection(sharedState: sharedContentState)
                    }
                    .badge(config.hasNotification ? Text(config.badgeText) : nil)
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
            UITabBar.appearance().scrollEdgeAppearance = appearance
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
