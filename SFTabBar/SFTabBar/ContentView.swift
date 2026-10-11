//
//  ContentView.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/16/20.
//

import SwiftUI
import UIKit

/// Which device frame the compact (single-mock) preview depicts. On a real
/// device the bottom-bar vs. vertical-rail layout is system-driven; this only
/// lets the preview show either, and does not change the generated code.
enum PreviewDevice: String, CaseIterable, Identifiable {
    case iPhone = "iPhone"
    case duo = "iPhone Duo"
    var id: String { rawValue }
}

struct ContentView: View {

    @State private var showingSheet = false
    @State private var colorScheme: ColorScheme? = nil
    @State private var previewDevice: PreviewDevice = .iPhone

    @State var quantity: Int = 5
    
    @State var progress: Float = 4
    
    @ObservedObject var tabs = TabsViewModel()
    
    @Environment(\.horizontalSizeClass) private var hSize
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
            color: isSelected ? tabs.tabTintColor : Color.primary,
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
        // NavigationStack, not NavigationView: on the regular-width iPhone Duo
        // inner display the deprecated NavigationView resolves to a two-column
        // split, pinning content to a narrow left column with an empty detail
        // pane. This app is single-column, so a stack uses the full width.
        NavigationStack {
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
        // Duo is regular-width in both orientations, so size class can't tell
        // portrait from landscape -- compare width vs height to pick the layout.
        GeometryReader { geo in
            Group {
                if hSize != .regular {
                    // Compact, but the top region differs by pose:
                    //  - iPhone: an opaque nav bar covers the top strip, so the
                    //    canvas is a pinned section header -- the large title
                    //    renders above it and collapses on scroll, and anything
                    //    that scrolls past the top is hidden behind the bar's blur.
                    //  - Duo passport: the title sits in the side rail and content
                    //    runs edge-to-edge under a transparent top, so a pinned
                    //    header leaves a gap the form shows through. A top
                    //    safe-area inset pins the canvas flush instead.
                    // A large horizontal safe-area inset means a vertical side bar
                    // is present, i.e. the Duo passport.
                    if max(geo.safeAreaInsets.leading, geo.safeAreaInsets.trailing) > 20 {
                        ScrollView {
                            formContent.padding(.top, 10)
                        }
                        .safeAreaInset(edge: .top, spacing: 0) {
                            compactCanvas
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                                Section {
                                    formContent.padding(.top, 10)
                                } header: {
                                    compactCanvas
                                }
                            }
                        }
                    }
                } else {
                    // Inner display (regular width): an ArrangementView split. The
                    // system divides the space and -- unlike our hand-rolled HStack
                    // -- keeps each pane inside its fold-defined region instead of
                    // letting content fall across the hinge. The split picks its
                    // axis by orientation: side-by-side in landscape, stacked
                    // (mocks over form) in portrait, where the hinge runs across the
                    // middle so the division lands on the fold. The ratio gives the
                    // form the larger share.
                    // The fold is a division reserved region: present only while
                    // the device is partially folded (book pose). Cap the canvas
                    // height in open portrait to pull the form up under the short
                    // mocks, but drop the cap when folded -- forcing a height fights
                    // the fold region and collapses the form. Landscape is uncapped.
                    let folded = !geo.reservedRegions(kind: .division).isEmpty
                    let capPortrait = geo.size.height > geo.size.width && !folded
                    ArrangementView {
                        mocksColumn
                            .padding(.horizontal, 10)
                            .padding(.bottom, 24)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(DotGridBackground(tint: tabs.tabTintColor))
                            .splitArrangementLayoutSize(maxHeight: capPortrait ? 200 : nil)
                    } secondary: {
                        ScrollView { formContent.padding(.top, 12) }
                    }
                    .arrangementViewStyle(.split)
                    .splitArrangementLayoutRatio(0.42)
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
                        Button(action: { colorScheme = nil }) { Label("System", systemImage: "gear") }
                        Button(action: { colorScheme = .light }) { Label("Light Mode", systemImage: "sun.max") }
                        Button(action: { colorScheme = .dark }) { Label("Dark Mode", systemImage: "moon") }
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

    // MARK: - Compact canvas

    /// The selected device mock sitting on the dot-grid paper, shared by both
    /// compact layouts (pinned section header on iPhone, top safe-area inset on
    /// Duo). The viewer picks iPhone or Duo via the Preview row.
    @ViewBuilder
    private var compactCanvas: some View {
        Group {
            if previewDevice == .duo {
                duoPassportMockView
            } else {
                iPhoneMockView
            }
        }
        .padding(.top, 2)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity)
        .background(DotGridBackground(tint: tabs.tabTintColor))
    }

    // MARK: - Form

    @ViewBuilder
    private var formContent: some View {
        LazyVStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("The Tab Bar is a non-interactive preview. Tap the \(Image(systemName: "play")) button to see it in action.")
                        .font(.footnote).foregroundColor(Color.secondary)
                }
                .padding(.horizontal, 16).padding(.bottom, 18.0)
                Text("Tab Bar Setting")
                    .font(.footnote).foregroundColor(.secondary).textCase(.uppercase)
                    .padding(.horizontal, 16).padding(.bottom, 8)
                VStack(spacing: 0) {
                    // Compact layouts show a single mock, so let the viewer pick
                    // which device frame it depicts. Regular-width layouts already
                    // show both mocks, so the row is hidden there.
                    if hSize != .regular {
                        HStack {
                            Text("Preview"); Spacer()
                            Picker("", selection: $previewDevice) {
                                ForEach(PreviewDevice.allCases) { device in
                                    Text(device.rawValue).tag(device)
                                }
                            }
                            .pickerStyle(MenuPickerStyle()).frame(width: 170, alignment: .trailing)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 12)
                        .background(Color(.secondarySystemGroupedBackground))
                        Divider().padding(.leading, 16)
                    }
                    // Label Color removed: iOS 27 owns the unselected item color under
                    // Liquid Glass, so exposing it would promise something the bar can't do.
                    HStack {
                        Text("Tint Color"); Spacer()
                        ColorPicker("", selection: $tabs.tabTintColor, supportsOpacity: false)
                            .frame(width: 40, alignment: .center)
                    }
                    .padding(.horizontal, 16).padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    Divider().padding(.leading, 16)
                    HStack {
                        Text("Minimize Behavior"); Spacer()
                        Picker("", selection: $tabs.tabBarMinimizeBehavior) {
                            ForEach(TabBarMinimizeBehaviorOption.allCases, id: \.self) { option in
                                Text(option.displayName).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()).frame(width: 170, alignment: .trailing)
                    }
                    .padding(.horizontal, 16).padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    Divider().padding(.leading, 16)
                    HStack {
                        Text("Bottom Accessory"); Spacer()
                        Toggle("", isOn: $tabs.hasBottomAccessory.animation(.spring(response: 0.6, dampingFraction: 0.8)))
                    }
                    .padding(.leading, 16).padding(.trailing, 8).padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    Divider().padding(.leading, 16)
                    HStack {
                        Text("Display \(quantity) Tabs"); Spacer()
                        Stepper("", value: $quantity.animation(.spring(response: 0.5, dampingFraction: 0.7)), in: 2...5)
                    }
                    .padding(.horizontal, 16).padding(.vertical, 12)
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
    }

    // MARK: - Device mocks (image frames + live bars)

    // Side by side, both frames are normalized to the Duo's height (299) so the
    // two tab-bar mocks read at the same height. The iPhone is the shorter/wider
    // frame, so matching heights widens it while the Duo keeps its width; the row
    // is then scaled to fit the pane upstream.
    private let sideBySideMockHeight: CGFloat = 299
    private var sideBySideIPhoneWidth: CGFloat { 342 * (sideBySideMockHeight / 183) }

    private var mocksColumn: some View {
        GeometryReader { geo in
            // Arrange the two mocks along the pane's long axis: side by side when
            // the pane is wider than tall (portrait's top canvas), stacked when
            // taller than wide (landscape's left column).
            let sideBySide = geo.size.width >= geo.size.height
            let contentW: CGFloat = sideBySide ? (sideBySideIPhoneWidth + 20 + 342) : 342
            let contentH: CGFloat = sideBySide ? sideBySideMockHeight : (183 + 20 + 299)
            let scale = min(geo.size.width / contentW, geo.size.height / contentH, 1)
            mocks(sideBySide: sideBySide)
                // Natural size -> scale -> reframe to the scaled size, so the
                // layout bounds shrink with the content and it fits the pane
                // instead of overflowing and clipping.
                .frame(width: contentW, height: contentH, alignment: .topLeading)
                .scaleEffect(scale, anchor: .topLeading)
                .frame(width: contentW * scale, height: contentH * scale, alignment: .topLeading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: sideBySide ? .center : .top)
        }
    }

    @ViewBuilder
    private func mocks(sideBySide: Bool) -> some View {
        if sideBySide {
            HStack(alignment: .top, spacing: 20) {
                iPhoneMockView
                    .scaleEffect(sideBySideMockHeight / 183, anchor: .topLeading)
                    .frame(width: sideBySideIPhoneWidth, height: sideBySideMockHeight, alignment: .topLeading)
                duoPassportMockView
            }
        } else {
            VStack(spacing: 20) {
                iPhoneMockView
                duoPassportMockView
            }
        }
    }

    // iPhone: device_iphone11 bezel with the horizontal bar composited beneath it.
    private var iPhoneMockView: some View {
        ZStack {
            ZStack {
                Color(.white.opacity(0.1)).glassEffect(.regular).cornerRadius(.infinity)
                HStack(alignment: .top, spacing: 0) {
                    Image(systemName: "play.fill").padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 8))
                    Text("Call to Action").font(.caption).foregroundColor(Color.primary)
                    Spacer()
                    Text("Action").font(.caption).foregroundColor(Color.primary).padding(.trailing, 4)
                }
                .padding(.horizontal, 8)
            }
            .frame(width: 290, height: 40)
            .offset(y: tabs.hasBottomAccessory ? -24.0 : 32.0)
            .opacity(tabs.hasBottomAccessory ? 1.0 : 0.0)
            ZStack {
                if let detached = detachedIndex {
                    HStack(alignment: .top, spacing: 0) {
                        ZStack {
                            HStack(alignment: .top, spacing: 0) {}
                                .frame(width: calculateTabBarWidth(for: quantity) - 60, height: 44)
                                .padding(.horizontal, 4).padding(.vertical, 4).glassEffect(.clear)
                            HStack(alignment: .top, spacing: 0) {
                                ForEach(capsuleIndices, id: \.self) { index in capsuleItem(at: index) }
                            }
                            .frame(width: calculateTabBarWidth(for: quantity) - 68)
                            .padding(.horizontal, 4).padding(.vertical, 4)
                        }
                        Spacer()
                        detachedItem(at: detached)
                    }
                    .frame(width: 290)
                } else {
                    ZStack {
                        HStack(alignment: .top, spacing: 0) {}
                            .frame(width: calculateTabBarWidth(for: quantity), height: 44)
                            .padding(.horizontal, 4).padding(.vertical, 4).glassEffect(.clear)
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(capsuleIndices, id: \.self) { index in capsuleItem(at: index) }
                        }
                        .frame(width: calculateTabBarWidth(for: quantity) - 8)
                        .padding(.horizontal, 4).padding(.vertical, 4)
                    }
                }
            }
            .frame(width: calculateTabBarWidth(for: quantity), height: 74)
            .offset(y: 34.0)
            Image("device_iPhoneAir")
        }
        .frame(width: 342, height: 183)
    }

    // Duo closed/passport: device_iPhoneDuo frame with the vertical rail on the
    // right -- bottom-aligned, small, with a neutral glass pill behind the
    // selected item (not a tint fill), and the accessory floating in content.
    // Matches the real passport PlayView rendering.
    private var duoPassportMockView: some View {
        let w: CGFloat = 342
        let h: CGFloat = w * (299.0 / 342.0)
        return Image("device_iPhoneDuo")
            .resizable()
            .scaledToFit()
            .frame(width: w, height: h)
            .overlay(alignment: .bottomTrailing) {
                VStack(spacing: 5) {
                    VStack(spacing: 2) {
                        ForEach(capsuleIndices, id: \.self) { index in
                            duoRailIcon(at: index)
                        }
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 3)
                    .glassEffect(.clear, in: Capsule())
                    if let detached = detachedIndex {
                        detachedItem(at: detached).scaleEffect(0.72)
                    }
                }
                .padding(.trailing, w * 0.045)
                .padding(.bottom, h * 0.14 - 4)
            }
            .overlay(alignment: .bottom) {
                if tabs.hasBottomAccessory {
                    // Centered in the content area (left of the rail), not leading-
                    // aligned -- matches the real passport. Shift left of true center
                    // by ~half the rail's width so it sits mid-content.
                    duoAccessoryPill
                        .frame(width: w * 0.58)
                        .offset(x: -w * 0.09)
                        .padding(.bottom, h * 0.14)
                }
            }
    }

    private var duoAccessoryPill: some View {
        ZStack {
            Color(.white.opacity(0.1)).glassEffect(.regular).cornerRadius(.infinity)
            HStack(spacing: 0) {
                Image(systemName: "play.fill").font(.caption2)
                    .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 5))
                Text("Call to Action").font(.caption2).foregroundColor(.primary)
                Spacer()
                Text("Action").font(.caption2).foregroundColor(.primary).padding(.trailing, 4)
            }
            .padding(.horizontal, 6)
        }
        .frame(height: 30)
    }

    // One rail item: small, with a neutral glass pill behind the selected one
    // (not a pink fill). The icon takes the tint colour when selected, matching
    // the horizontal bar's selected treatment.
    @ViewBuilder
    private func duoRailIcon(at index: Int) -> some View {
        let config = tabs.tabs[index]
        let isSelected = index == selectedIndex
        Image(systemName: config.icon)
            .font(.system(size: 15, weight: config.fontWeight))
            .foregroundStyle(isSelected ? tabs.tabTintColor : .primary)
            .frame(width: 32, height: isSelected ? 44 : 34)
            .background {
                if isSelected {
                    Capsule().glassEffect(.regular.interactive(), in: Capsule()).opacity(0.6)
                }
            }
            .overlay(alignment: .topTrailing) {
                if config.canShowBadge && config.hasNotification {
                    Circle().fill(.red).frame(width: 6, height: 6).offset(x: 0, y: 1)
                }
            }
    }
}

// Dot-grid "paper" backdrop for the mock area. Tinted with the user's selected
// tint colour at a very light opacity (dots a stronger version of the same), so
// the canvas echoes their choice. Layered over systemBackground, so it adapts
// to light/dark automatically.
struct DotGridBackground: View {
    var tint: Color
    private let spacing: CGFloat = 16
    private let dotSize: CGFloat = 2

    var body: some View {
        Canvas { context, size in
            var y = spacing / 2
            while y < size.height {
                var x = spacing / 2
                while x < size.width {
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - dotSize / 2, y: y - dotSize / 2,
                                               width: dotSize, height: dotSize)),
                        with: .color(tint.opacity(0.16))
                    )
                    x += spacing
                }
                y += spacing
            }
        }
        .background(tint.opacity(0.05))
        .background(Color(.systemBackground))
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
                .overlay(alignment: .topTrailing) {
                    if hasNotification {
                        Text(notificationValue.isEmpty ? "1" : notificationValue)
                            .font(Font.system(size: 10))
                            .foregroundStyle(Color(.white))
                            .padding(.horizontal, 4)
                            .frame(minWidth: 16, minHeight: 16)
                            .background(Color(.red), in: Capsule())
                            // Sit on the icon's top-right corner, overlapping the
                            // glyph, matching where iOS 27 draws the badge.
                            .offset(x: 6, y: -6)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
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


