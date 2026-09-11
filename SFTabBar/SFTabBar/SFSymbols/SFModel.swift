//
//  SFModel.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/29/20.
//

import SwiftUI

/// One category of symbols, in Apple's own display order.
struct Library: Codable, Identifiable {
    var id = UUID()
    var title: String
    /// SF Symbol representing the category, from Apple's metadata.
    var icon: String?
    var items: [String]

    enum CodingKeys: String, CodingKey {
        case title
        case icon
        case items
    }
}

/// The catalog produced by `Scripts/generate-symbols.py`.
///
/// A symbol's release is a property of the symbol rather than of the category
/// it appears under, so it lives in a lookup table instead of being repeated on
/// every section entry.
struct SymbolCatalog: Codable {
    /// SF Symbols version the catalog was generated from, e.g. `"8.0"`.
    var version: String
    var generated: String
    /// Release identifier to earliest iOS version, e.g. `"2026"` to `"27.0"`.
    var iOSVersions: [String: String]
    /// Symbol name to the release that introduced it.
    var symbolReleases: [String: String]
    var sections: [Library]

    static let empty = SymbolCatalog(
        version: "unknown",
        generated: "",
        iOSVersions: [:],
        symbolReleases: [:],
        sections: []
    )

    /// Major version for display, e.g. `"8"` from `"8.0"`.
    var majorVersion: String {
        version.split(separator: ".").first.map(String.init) ?? version
    }

    func release(of symbol: String) -> String? {
        symbolReleases[symbol]
    }

    /// Earliest iOS version that ships `symbol`, e.g. `"27.0"`.
    func minimumIOS(for symbol: String) -> String? {
        guard let release = symbolReleases[symbol] else { return nil }
        return iOSVersions[release]
    }

    /// Whether the symbol arrived in the newest release the catalog knows of.
    func isNew(_ symbol: String) -> Bool {
        guard let release = symbolReleases[symbol], let newest = newestRelease else {
            return false
        }
        return release.split(separator: ".").first == newest.split(separator: ".").first
    }

    private var newestRelease: String? {
        iOSVersions.keys.max { lhs, rhs in
            compareReleases(lhs, rhs)
        }
    }

    private func compareReleases(_ lhs: String, _ rhs: String) -> Bool {
        let left = lhs.split(separator: ".").compactMap { Int($0) }
        let right = rhs.split(separator: ".").compactMap { Int($0) }
        return left.lexicographicallyPrecedes(right)
    }
}

// Helper struct for items that need to be identifiable
struct IdentifiableString: Identifiable {
    let id = UUID()
    let value: String
}
