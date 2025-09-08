//
//  iOS26TabViewTest.swift
//  SFTabBar
//
//  Created for testing iOS 26 TabView capabilities
//

import SwiftUI

struct iOS26TabViewTest: View {
    @State private var selectedTab = "dashboard"
    @State private var searchText = ""
    @State private var minimizeBehavior: TabViewMinimizeBehavior = .automatic
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard Tab with numeric badge
            Tab("Dashboard", systemImage: "gauge", value: "dashboard") {
                NavigationStack {
                    VStack(spacing: 20) {}
                    .padding()
                    .navigationTitle("Dashboard")
                }
            }
            .badge(3) // Numeric badge showing 3 notifications
            
            // Messages Section
            TabSection("Messages") {
                Tab("Received", systemImage: "tray.and.arrow.down", value: "received") {
                    NavigationStack {
                        VStack(spacing: 20) {}
                        .padding()
                        .navigationTitle("Received")
                    }
                }
                .badge(12) // Numeric badge for unread messages
                Tab("Sent", systemImage: "tray.and.arrow.up.fill", value: "sent") {
                    NavigationStack {
                        VStack(spacing: 20) {}
                        .padding()
                        .navigationTitle("Sent")
                    }
                }
            }
            
            // Search Tab with role
            Tab("Search", systemImage: "magnifyingglass", value: "search", role: .search) {
                NavigationStack {
                    VStack(spacing: 20) {}
                    .padding()
                    .navigationTitle("Search")
                    .searchable(text: $searchText)
                }
            }
            
            // Settings Tab with string badge
            Tab("Settings", systemImage: "gear", value: "settings") {
                NavigationStack {
                    VStack(spacing: 20) {}
                    .padding()
                    .navigationTitle("Settings")
                }
            }
            .badge("!") // String badge for important notifications
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.automatic)
        .tabViewSearchActivation(.searchTabSelection)
        .tabViewBottomAccessory {
            // Bottom Accessory Demo
            HStack {
                Image(systemName: "music.note")
                Text("Now Playing: Test Song")
                    .font(.caption)
                Spacer()
                Button("Play") {
                    // Play action
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
}

// iOS 26 TabView Minimize Behavior
enum TabViewMinimizeBehavior: String, CaseIterable {
    case onScrollDown = "onScrollDown"
    case onScrollUp = "onScrollUp"
    case automatic = "automatic"
    case never = "never"
}

#Preview {
    iOS26TabViewTest()
}
