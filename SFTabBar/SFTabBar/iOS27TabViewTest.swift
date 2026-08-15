//
//  iOS27TabViewTest.swift
//  SFTabBar
//
//  A probe harness for iOS 27 tab bar behaviour.
//
//  Apple documents that only one tab may be prominent, and that a search tab
//  inherits the prominent treatment when nothing else claims it. What the docs
//  do not say is how the bar lays out in the cases below. Run these on an
//  iOS 27 simulator and match the static preview in ContentView to what you see.
//

import SwiftUI

struct iOS27TabViewTest: View {
    enum Probe: String, CaseIterable, Identifiable {
        case prominentLast = "Prominent (last)"
        case prominentMiddle = "Prominent (middle)"
        case prominentAndSearch = "Prominent + Search"
        case searchOnly = "Search only"
        case noRoles = "No roles"

        var id: String { rawValue }
    }

    @State private var probe: Probe = .prominentLast

    var body: some View {
        VStack(spacing: 0) {
            Picker("Probe", selection: $probe) {
                ForEach(Probe.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.menu)
            .padding()

            probeTabView
        }
    }

    @ViewBuilder
    private var probeTabView: some View {
        switch probe {
        case .prominentLast:
            ProbeTabView(prominent: 3, search: nil)
        case .prominentMiddle:
            // Does a mid-list prominent tab move to the trailing slot, or stay
            // in place with added emphasis?
            ProbeTabView(prominent: 1, search: nil)
        case .prominentAndSearch:
            // Two trailing-separated items, or does one absorb the other?
            ProbeTabView(prominent: 1, search: 3)
        case .searchOnly:
            // Baseline: search should inherit the prominent treatment.
            ProbeTabView(prominent: nil, search: 3)
        case .noRoles:
            ProbeTabView(prominent: nil, search: nil)
        }
    }
}

private struct ProbeTabView: View {
    var prominent: Int?
    var search: Int?

    @State private var selection = 0
    @State private var searchText = ""

    private let labels = ["Dash", "Trends", "Shop", "Cart"]
    private let icons = ["gauge", "flame", "bag", "cart.fill"]

    private func role(_ index: Int) -> TabRole? {
        if index == prominent { return .prominent }
        if index == search { return .search }
        return nil
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(0..<labels.count, id: \.self) { index in
                Tab(labels[index], systemImage: icons[index], value: index, role: role(index)) {
                    NavigationStack {
                        List(0..<40, id: \.self) { row in
                            Text("\(labels[index]) row \(row)")
                        }
                        .navigationTitle(labels[index])
                    }
                }
                // Does a prominent tab honour a badge?
                .badge(index == prominent ? 3 : 0)
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewSearchActivation(.searchTabSelection)
        .tint(.pink)
    }
}

#Preview {
    iOS27TabViewTest()
}
