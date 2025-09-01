//
//  ContentView.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/16/20.
//

import SwiftUI
import UIKit

enum TabBarMinimizeBehaviorOption: String, CaseIterable {
    case onScrollDown = "onScrollDown"
    case onScrollUp = "onScrollUp"
    case automatic = "automatic"
    case never = "never"
}

class TabsViewModel: ObservableObject {
    @Published var tab1Label = "Dash"
    @Published var tab1Icon = "gauge"
    @Published var tab1Weight = ".regular"
    @Published var tab1FontWeight: Font.Weight = .regular
    
    @Published var tab2Label = "Trends"
    @Published var tab2Icon = "flame"
    @Published var tab2Weight = ".regular"
    @Published var tab2FontWeight: Font.Weight = .regular
    
    @Published var tab3Label = "Shop"
    @Published var tab3Icon = "bag"
    @Published var tab3Weight = ".regular"
    @Published var tab3FontWeight: Font.Weight = .regular
    
    @Published var tab4Label = "Profile"
    @Published var tab4Icon = "person.crop.circle"
    @Published var tab4Weight = ".regular"
    @Published var tab4FontWeight: Font.Weight = .regular
    
    @Published var tab5Label = "Search"
    @Published var tab5Icon = "magnifyingglass"
    @Published var tab5Weight = ".regular"
    @Published var tab5FontWeight: Font.Weight = .regular
    
    @Published var tabItemColor = Color.primary
    @Published var tabTintColor = Color.pink
    @Published var tabBarMinimizeBehavior = TabBarMinimizeBehaviorOption.onScrollDown
    @Published var hasSearchRole = false
    @Published var hasBottomAccessory = true
    

    func update(location: String, to value: String) {
        switch location {
        case "tab1Icon":
            tab1Icon = value
        case "tab2Icon":
            tab2Icon = value
        case "tab3Icon":
            tab3Icon = value
        case "tab4Icon":
            tab4Icon = value
        case "tab5Icon":
            tab5Icon = value
        default:
            return
        }
    }
    
    func updateWeight(location: String, to value: String, font weight: Font.Weight) {
        switch location {
        case "tab1Icon":
            tab1Weight = value
            tab1FontWeight = weight
        case "tab2Icon":
            tab2Weight = value
            tab2FontWeight = weight
        case "tab3Icon":
            tab3Weight = value
            tab3FontWeight = weight
        case "tab4Icon":
            tab4Weight = value
            tab4FontWeight = weight
        case "tab5Icon":
            tab5Weight = value
            tab5FontWeight = weight
        default:
            return
        }
    }
}

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemPink]
        }

    @State private var showingSheet = false
        
    @State var quantity: Int = 5
    
    @State var progress: Float = 4
    
    @ObservedObject var tabs = TabsViewModel()
    
    let generator = UINotificationFeedbackGenerator()
    
    private func calculateTabBarWidth(for tabCount: Int) -> CGFloat {
        switch tabCount {
        case 1:
            return 70
        case 2:
            return 147
        case 3:
            return 214
        case 4, 5:
            return 282
        default:
            return 282
        }
    }
    
        
    var body: some View {
        NavigationView {
            contentView
        }
        .accentColor(.pink)
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
                                                Text("On Scroll Down").tag(TabBarMinimizeBehaviorOption.onScrollDown)
                                                Text("On Scroll Up").tag(TabBarMinimizeBehaviorOption.onScrollUp)
                                                Text("Automatic").tag(TabBarMinimizeBehaviorOption.automatic)
                                                Text("Never").tag(TabBarMinimizeBehaviorOption.never)
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
                                            Toggle("", isOn: $tabs.hasBottomAccessory)
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
                                            Stepper("", value: $quantity, in: 2...5)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color(.secondarySystemGroupedBackground))
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                // Tab 1 Section
                                if quantity >= 1 {
                                    TabConfigurationView(tabNumber: 1, quantity: quantity, tabs: tabs)
                                }
                                
                                // Tab 2 Section
                                if quantity >= 2 {
                                    TabConfigurationView(tabNumber: 2, quantity: quantity, tabs: tabs)
                                }
                                
                                // Tab 3 Section
                                if quantity >= 3 {
                                    TabConfigurationView(tabNumber: 3, quantity: quantity, tabs: tabs)
                                }
                                
                                // Tab 4 Section
                                if quantity >= 4 {
                                    TabConfigurationView(tabNumber: 4, quantity: quantity, tabs: tabs)
                                }
                                
                                // Tab 5 Section
                                if quantity >= 5 {
                                    TabConfigurationView(tabNumber: 5, quantity: quantity, tabs: tabs)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20)
                        } header: {
                            ZStack {
                                if tabs.hasBottomAccessory {
                                    HStack(alignment: .top, spacing: 0) {
                                        Image(systemName: "play.fill")
                                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 8))
                                        Text("Call to Action")
                                            .font(.caption)
                                        Spacer()
                                        Text("Action")
                                            .font(.caption)
                                            .padding(.trailing, 4)
                                    }
                                        .frame(width: 280, height: 30)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(.infinity)
                                        .offset(y: -34.0)
                                }
                                ZStack {
                                    if tabs.hasSearchRole {
                                        HStack(alignment: .top, spacing: 0) {
                                            ZStack {
                                                HStack(alignment: .top, spacing: 0) {}
                                                .frame(width: calculateTabBarWidth(for: quantity) - 60, height: 44)
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 4)
                                                .glassEffect(.clear)
                                                HStack(alignment: .top, spacing: 0) {
                                                    if quantity >= 1 {
                                                        SFTabBar.tabItem(icon: tabs.tab1Icon, label: tabs.tab1Label, color: tabs.tabTintColor, weight: tabs.tab1FontWeight, isSelected: true)
                                                    }
                                                    if quantity >= 2 && quantity > 2 {
                                                        SFTabBar.tabItem(icon: tabs.tab2Icon, label: tabs.tab2Label, color: tabs.tabItemColor, weight: tabs.tab2FontWeight, isSelected: false)
                                                    }
                                                    if quantity >= 3 && quantity > 3 {
                                                        SFTabBar.tabItem(icon: tabs.tab3Icon, label: tabs.tab3Label, color: tabs.tabItemColor, weight: tabs.tab3FontWeight, isSelected: false)
                                                    }
                                                    if quantity >= 4 && quantity > 4 {
                                                        SFTabBar.tabItem(icon: tabs.tab4Icon, label: tabs.tab4Label, color: tabs.tabItemColor, weight: tabs.tab4FontWeight, isSelected: false)
                                                    }
                                                }
                                                .frame(width: calculateTabBarWidth(for: quantity) - (quantity == 5 ? 68 : 62))
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 4)
                                            }
                                            Spacer()
                                            if quantity >= 1 {
                                                let searchTabIcon = quantity == 1 ? tabs.tab1Icon : 
                                                                   quantity == 2 ? tabs.tab2Icon :
                                                                   quantity == 3 ? tabs.tab3Icon :
                                                                   quantity == 4 ? tabs.tab4Icon : tabs.tab5Icon
                                                ZStack{
                                                    ZStack {
                                                    }
                                                    .frame(width: 50, height: 50)
                                                    .glassEffect(.clear)
                                                    Image(systemName: searchTabIcon)
                                                        .font(.system(size: 20))
                                                        .frame(width: 44, height: 44)
                                                        .foregroundColor(Color.primary)
                                                        .padding(.horizontal, 4)
                                                        .padding(.vertical, 4)
                                                }
                                            }
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
                                                if quantity >= 1 {
                                                    SFTabBar.tabItem(icon: tabs.tab1Icon, label: tabs.tab1Label, color: tabs.tabTintColor, weight: tabs.tab1FontWeight, isSelected: true)
                                                }
                                                if quantity >= 2 {
                                                    SFTabBar.tabItem(icon: tabs.tab2Icon, label: tabs.tab2Label, color: tabs.tabItemColor, weight: tabs.tab2FontWeight, isSelected: false)
                                                }
                                                if quantity >= 3 {
                                                    SFTabBar.tabItem(icon: tabs.tab3Icon, label: tabs.tab3Label, color: tabs.tabItemColor, weight: tabs.tab3FontWeight, isSelected: false)
                                                }
                                                if quantity >= 4 {
                                                    SFTabBar.tabItem(icon: tabs.tab4Icon, label: tabs.tab4Label, color: tabs.tabItemColor, weight: tabs.tab4FontWeight, isSelected: false)
                                                }
                                                if quantity >= 5 {
                                                    SFTabBar.tabItem(icon: tabs.tab5Icon, label: tabs.tab5Label, color: tabs.tabItemColor, weight: tabs.tab5FontWeight, isSelected: false)
                                                }
                                            }
                                            .frame(width: calculateTabBarWidth(for: quantity) - (quantity == 5 ? 8 : 2))
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
                            .offset(y: 4.0)
                            .padding(.bottom)
                            .background(Color(.systemGroupedBackground))
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
                        NavigationLink(destination: DocumentionView()) {
                            Image(systemName: "book.pages")
                        }
                    }
                }
            }
            
    
}


struct tabItem: View {
    
    var icon: String
    var label: String
    var color: Color
    var weight: Font.Weight
    var isSelected: Bool = false
                
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

