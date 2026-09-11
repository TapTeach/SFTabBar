//
//  ContentView.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/16/20.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemPink]
        }

    @State private var showingSheet = false
    @State private var colorScheme: ColorScheme? = nil
        
    @State var quantity: Int = 5
    
    @State var progress: Float = 4
    
    @ObservedObject var tabs = TabsViewModel()
    
    let generator = UINotificationFeedbackGenerator()
    
    // iOS 27's floating tab bar uses a constant capsule width for 2-5 tabs
    // and distributes the items within it (iOS 26 sized the capsule to the
    // count). The parameter is kept so call sites read clearly.
    private func calculateTabBarWidth(for tabCount: Int) -> CGFloat {
        return 282
    }

    /// The tab the system lifts out of the capsule into the trailing slot,
    /// or `nil` when every tab sits in the capsule together.
    private var detachedIndex: Int? {
        tabs.detachedIndex.flatMap { $0 < quantity ? $0 : nil }
    }

    /// Indices rendered inside the glass capsule, in order.
    private var capsuleIndices: [Int] {
        (0..<quantity).filter { $0 != detachedIndex }
    }

    /// The first capsule tab stands in for the selected one.
    private var selectedIndex: Int? { capsuleIndices.first }

    @ViewBuilder
    private func capsuleItem(at index: Int) -> some View {
        let config = tabs.tabs[index]
        let isSelected = index == selectedIndex
        SFTabBar.tabItem(
            icon: config.icon,
            label: config.label,
            color: isSelected ? tabs.tabTintColor : tabs.tabItemColor,
            weight: config.fontWeight,
            isSelected: isSelected,
            hasNotification: config.hasNotification,
            notificationValue: config.notificationValue
        )
    }

    /// The trailing item outside the capsule.
    ///
    /// Search and prominent get the same clear glass circle -- verified against
    /// iOS 27.0 RC (24A434), where the prominent treatment *is* the detached
    /// trailing slot rather than any extra fill or tint. Neither shows a label.
    @ViewBuilder
    private func detachedItem(at index: Int) -> some View {
        let config = tabs.tabs[index]

        ZStack {
            ZStack {}
                .frame(width: 50, height: 50)
                .glassEffect(.clear)
            Image(systemName: config.icon)
                .font(.system(size: 20, weight: config.fontWeight))
                .frame(width: 44, height: 44)
                .foregroundColor(Color.primary)
        }
        // Pinned to the circle's own 50pt box, so the badge lands on the
        // top-right arc instead of a bounding-box corner out in empty space.
        .frame(width: 50, height: 50)
        .overlay(alignment: .topTrailing) {
            if config.canShowBadge && config.hasNotification {
                Text(config.badgeText)
                    .font(Font.system(size: 11))
                    .foregroundStyle(Color(.white))
                    .padding(.horizontal, 5)
                    .frame(minWidth: 18, minHeight: 18)
                    .background(Color(.red), in: Capsule())
            }
        }
    }
    
        
    var body: some View {
        NavigationView {
            contentView
        }
        .accentColor(.pink)
        .preferredColorScheme(colorScheme)
        .onAppear {
            UIView.configureAlertAppearance()
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                        Section {
                            LazyVStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        Text("The Tab Bar above is a non-interactive preview. Tap the \(Image(systemName: "play")) button to see it in action.")
                                        .font(.footnote)
                                        .foregroundColor(Color.secondary)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 18.0)
                                    Text("Tab Bar Setting")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 8)
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text("Label Color")
                                            Spacer()
                                            ColorPicker("", selection: $tabs.tabItemColor, supportsOpacity: false)
                                                .frame(width: 40, alignment: .center)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color(.secondarySystemGroupedBackground))
                                        
                                        Divider()
                                            .padding(.leading, 16)
                                        HStack {
                                            Text("Tint Color")
                                            Spacer()
                                            ColorPicker("", selection: $tabs.tabTintColor, supportsOpacity: false)
                                                .frame(width: 40, alignment: .center)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color(.secondarySystemGroupedBackground))
                                        
                                        Divider()
                                            .padding(.leading, 16)
                                        HStack {
                                            Text("Minimize Behavior")
                                            Spacer()
                                            Picker("", selection: $tabs.tabBarMinimizeBehavior) {
                                                ForEach(TabBarMinimizeBehaviorOption.allCases, id: \.self) { option in
                                                    Text(option.displayName).tag(option)
                                                }
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .frame(width: 170, alignment: .trailing)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color(.secondarySystemGroupedBackground))
                                        Divider()
                                            .padding(.leading, 16)
                                        HStack {
                                            Text("Bottom Accessory")
                                            Spacer()
                                            Toggle("", isOn: $tabs.hasBottomAccessory.animation(.spring(response: 0.6, dampingFraction: 0.8)))
                                        }
                                        .padding(.leading, 16)
                                        .padding(.trailing, 8)
                                        .padding(.vertical, 12)
                                        .background(Color(.secondarySystemGroupedBackground))
                                        
                                        Divider()
                                            .padding(.leading, 16)
                                        HStack {
                                            Text("Display \(quantity) Tabs")
                                            Spacer()
                                            //Stepper("", value: $quantity, in: 2...5)
                                            Stepper("", value: $quantity.animation(.spring(response: 0.5, dampingFraction: 0.7)), in: 2...5)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color(.secondarySystemGroupedBackground))
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                ForEach(0..<quantity, id: \.self) { index in
                                    TabConfigurationView(tabIndex: index, tabs: tabs)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20)
                        } header: {
                            ZStack {
                                Color(.systemGroupedBackground)
                                    .background(Color(.systemGroupedBackground))
                                    .frame(width: 330, height: 155)
                                    .offset(y: -12)
                                ZStack {
                                    Color(.white.opacity(0.1))
                                        .glassEffect(.regular)
                                        .cornerRadius(.infinity)
                                    HStack(alignment: .top, spacing: 0) {
                                        Image(systemName: "play.fill")
                                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 8))
                                        Text("Call to Action")
                                            .font(.caption)
                                            .foregroundColor(Color.primary)
                                        Spacer()
                                        Text("Action")
                                            .font(.caption)
                                            .foregroundColor(Color.primary)
                                            .padding(.trailing, 4)
                                    }
                                    .padding(.horizontal, 8)
                                }
                                .frame(width: 290, height: 40)
                                .offset(y: tabs.hasBottomAccessory ? -36.0 : 20.0)
                                .opacity(tabs.hasBottomAccessory ? 1.0 : 0.0)
                                ZStack {
                                    if let detached = detachedIndex {
                                        // A search or prominent tab is lifted out
                                        // of the capsule into its own trailing slot.
                                        HStack(alignment: .top, spacing: 0) {
                                            ZStack {
                                                HStack(alignment: .top, spacing: 0) {}
                                                .frame(width: calculateTabBarWidth(for: quantity) - 60, height: 44)
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 4)
                                                .glassEffect(.clear)
                                                HStack(alignment: .top, spacing: 0) {
                                                    ForEach(capsuleIndices, id: \.self) { index in
                                                        capsuleItem(at: index)
                                                    }
                                                }
                                                .frame(width: calculateTabBarWidth(for: quantity) - 68)
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 4)
                                            }
                                            Spacer()
                                            detachedItem(at: detached)
                                        }
                                        .frame(width: 290)
                                    } else {
                                        ZStack {
                                            HStack(alignment: .top, spacing: 0) {}
                                            .frame(width: calculateTabBarWidth(for: quantity), height: 44)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 4)
                                            .glassEffect(.clear)
                                            HStack(alignment: .top, spacing: 0) {
                                                ForEach(capsuleIndices, id: \.self) { index in
                                                    capsuleItem(at: index)
                                                }
                                            }
                                            .frame(width: calculateTabBarWidth(for: quantity) - 8)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 4)
                                            //.glassEffect()
                                        }
                                    }
                                    Image("img_homeIndicator_black")
                                        .offset(y: 37.0)
                                }
                                .frame(width: calculateTabBarWidth(for: quantity), height: 74)
                                .offset(y: 18.0)
                                ZStack {
                                    VRule()
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                        .frame(height: 1)
                                        .offset(x: 0, y: -105.0)
                                        .opacity(0.5)
                                    VRule()
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                        .frame(height: 1)
                                        .offset(x: 290, y: -105.0)
                                        .opacity(0.5)
                                }
                                .frame(width: 290)
                                Image("device_iphone11")
                                    //.offset(y: -10.0)
                                HRule()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .frame(height: 1)
                                    .offset(y: -8)
                                    .opacity(0.5)
                                HRule()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .frame(height: 1)
                                    .offset(y: -89.0)
                                    .opacity(0.5)
                                
                            }
                            .clipped()
                            .padding(.bottom)
                            //.offset(y: 4.0)
                            //.background(Color(.systemGroupedBackground))
                        }
                    }
                }
                .background(Color(.systemGroupedBackground))
                .navigationTitle("SF TabBar")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        NavigationLink(destination: NewPlayView(tabCount: quantity, tabs: tabs)) {
                            Image(systemName: "play")
                        }
                        NavigationLink(destination: Export(tabCount: quantity, tabs: tabs)) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    ToolbarSpacer(placement: .topBarTrailing)
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Menu {
                            Section("Appearance Mode") {
                                Button(action: { colorScheme = nil }) {
                                    Label("System", systemImage: "gear")
                                }
                                Button(action: { colorScheme = .light }) {
                                    Label("Light Mode", systemImage: "sun.max")
                                }
                                Button(action: { colorScheme = .dark }) {
                                    Label("Dark Mode", systemImage: "moon")
                                }
                            }
                        } label: {
                            Image(systemName: "circle.lefthalf.filled.inverse")
                        }
                    }
                    ToolbarSpacer(placement: .topBarTrailing)
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        NavigationLink(destination: DocumentionView()) {
                            Image(systemName: "book.pages")
                        }
                    }
                }
            }
            
    
}


struct SFTabBar {
    static func tabItem(icon: String, label: String, color: Color, weight: Font.Weight, isSelected: Bool = false, hasNotification: Bool = false, notificationValue: String = "") -> some View {
        return TabItemView(icon: icon, label: label, color: color, weight: weight, isSelected: isSelected, hasNotification: hasNotification, notificationValue: notificationValue)
    }
}

struct TabItemView: View {
    
    var icon: String
    var label: String
    var color: Color
    var weight: Font.Weight
    var isSelected: Bool = false
    var hasNotification: Bool = false
    var notificationValue: String = ""
                
    var body: some View {
        VStack(spacing: 4.0){
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 16.0, height: 16.0)
                .foregroundColor(isSelected ? color : .primary)
                .font(.system(size: 16, weight: weight))
            Text(label)
                .foregroundColor(color)
                .font(.system(size: 9))
                .lineLimit(1)
               
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background (
            Group {
                if isSelected {
                    ConcentricRectangle(corners: .concentric(minimum: 6), isUniform: true)
                        .glassEffect(.regular.interactive(),in: ConcentricRectangle(corners: .concentric(minimum: 6), isUniform: true))
                        .opacity(0.5)
                        .frame(minWidth: 60)
                }
            }
        )
        .overlay (
            Group {
                if hasNotification {
                    ZStack {
                        Text(notificationValue.isEmpty ? "1" : notificationValue)
                            .font(Font.system(size: 10))
                            .foregroundStyle(Color(.white))
                            .padding(4)
                            .frame(minWidth: 15, maxHeight: 15, alignment: .init(horizontal: .center, vertical: .center))
                            .background(Color(.red))
                            .cornerRadius(.infinity)
                            .offset(x: 14 + (notificationValue.isEmpty ? 0 : notificationValue.count == 2 ? 2 : notificationValue.count == 3 ? 5 : notificationValue.count > 3 ? CGFloat(notificationValue.count - 3) * 2 + 4 : 0), y: -14)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        )
        .containerShape(.rect(cornerRadius: 37))
    }
}

struct HRule: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
struct VRule: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.width))
        return path
    }
}

extension UIView {
    static func configureAlertAppearance() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(.pink)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            //.environment(\.colorScheme, .dark)
    }
}

