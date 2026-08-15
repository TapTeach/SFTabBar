//
//  TabConfig.swift
//  SFTabBar
//
//  Created by Adam Jones on 8/15/26.
//

import SwiftUI

/// The roles a tab can take on in an iOS 27 tab bar.
///
/// Both `search` and `prominent` render trailing-separated from the main tab
/// capsule, and each can be held by at most one tab. Apple's rule: when no tab
/// claims `prominent`, a `search` tab may receive the prominent treatment.
enum TabRoleOption: String, CaseIterable, Identifiable {
    case none
    case search
    case prominent

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .none: return "None"
        case .search: return "Search"
        case .prominent: return "Prominent"
        }
    }

    /// How the role is written in generated code, e.g. `role: .prominent`.
    var codeArgument: String? {
        switch self {
        case .none: return nil
        case .search: return ".search"
        case .prominent: return ".prominent"
        }
    }

    var swiftUIRole: TabRole? {
        switch self {
        case .none: return nil
        case .search: return .search
        case .prominent: return .prominent
        }
    }
}

struct TabConfig: Identifiable, Equatable {
    let id = UUID()
    var label: String
    var icon: String
    /// Display string for the weight picker, e.g. `".semibold"`.
    var weight: String = ".regular"
    var fontWeight: Font.Weight = .regular
    var role: TabRoleOption = .none
    var hasNotification: Bool = false
    var notificationValue: String = ""

    /// A search tab has no room for a badge.
    var canShowBadge: Bool { role != .search }

    var badgeText: String {
        notificationValue.isEmpty ? "1" : notificationValue
    }
}
