//
//  SFModel.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/29/20.
//

import SwiftUI

struct Library: Codable, Identifiable {
    var id = UUID()
    var title: String
    var items: [String]
    enum CodingKeys: String, CodingKey {
        case title
        case items
    }
}

// Helper struct for items that need to be identifiable
struct IdentifiableString: Identifiable {
    let id = UUID()
    let value: String
}
