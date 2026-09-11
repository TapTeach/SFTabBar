//
//  TabsViewModel.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/16/20.
//

import SwiftUI

enum TabBarMinimizeBehaviorOption: String, CaseIterable {
    case onScrollDown = "onScrollDown"
    case onScrollUp = "onScrollUp"
    case automatic = "automatic"
    case never = "never"

    var displayName: String {
        switch self {
        case .onScrollDown: return "On Scroll Down"
        case .onScrollUp: return "On Scroll Up"
        case .automatic: return "Automatic"
        case .never: return "Never"
        }
    }
}

class TabsViewModel: ObservableObject {
    @Published var tabs: [TabConfig] = [
        TabConfig(label: "Dash", icon: "gauge"),
        TabConfig(label: "Trends", icon: "flame"),
        TabConfig(label: "Shop", icon: "bag"),
        TabConfig(label: "Profile", icon: "person.crop.circle"),
        TabConfig(label: "Search", icon: "magnifyingglass", role: .search),
    ]

    @Published var tabItemColor = Color.primary
    @Published var tabTintColor = Color.pink
    @Published var tabBarMinimizeBehavior = TabBarMinimizeBehaviorOption.onScrollDown
    @Published var hasBottomAccessory = true

    // MARK: - Roles

    var prominentIndex: Int? { tabs.firstIndex { $0.role == .prominent } }
    var searchIndex: Int? { tabs.firstIndex { $0.role == .search } }

    /// The tab the system pulls out of the capsule into the trailing slot.
    ///
    /// Mirrors Apple's fallback: an explicit `.prominent` tab wins, otherwise a
    /// `.search` tab inherits the treatment.
    var detachedIndex: Int? { prominentIndex ?? searchIndex }

    /// Assigns a role, clearing it from whichever tab held it before.
    ///
    /// `search` and `prominent` are each exclusive to one tab, so the model
    /// enforces that rather than leaving the UI to police it.
    func setRole(_ role: TabRoleOption, at index: Int) {
        guard tabs.indices.contains(index) else { return }

        if role != .none {
            for other in tabs.indices where other != index && tabs[other].role == role {
                tabs[other].role = .none
            }
        }
        tabs[index].role = role
    }

    // MARK: - Mutation

    func update(icon: String, at index: Int) {
        guard tabs.indices.contains(index) else { return }
        tabs[index].icon = icon
    }

    func updateWeight(_ weight: String, font: Font.Weight, at index: Int) {
        guard tabs.indices.contains(index) else { return }
        tabs[index].weight = weight
        tabs[index].fontWeight = font
    }
}
