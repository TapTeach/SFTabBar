//
//  ContentView.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/16/20.
//

import SwiftUI
import UIKit

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
    
    @Published var tab5Label = "Settings"
    @Published var tab5Icon = "slider.horizontal.3"
    @Published var tab5Weight = ".regular"
    @Published var tab5FontWeight: Font.Weight = .regular
    
    @Published var tabBarColor = Color.pink
    @Published var tabItemColor = Color("defaultLabel")
    @Published var tabTintColor = Color.white
    

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

    @State private var showingSheet = false
        
    @State var isWhiteHomeIndicator = false
    @State var quantity: Int = 5
    
    @State var progress: Float = 4
    
    @ObservedObject var tabs = TabsViewModel()
    
    let generator = UINotificationFeedbackGenerator()
    
        
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                contentView
            }
        } else {
            NavigationView {
                contentView
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        NavigationStack {
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 0, style: .continuous)
                            .fill(tabs.tabBarColor)
                        HStack(alignment: .top){
                            if quantity >= 1 {
                                SFTabBar.tabItem(icon: tabs.tab1Icon, label: tabs.tab1Label, color: tabs.tabTintColor, weight: tabs.tab1FontWeight)
                            }
                            if quantity >= 2 {
                                SFTabBar.tabItem(icon: tabs.tab2Icon, label: tabs.tab2Label, color: tabs.tabItemColor, weight: tabs.tab2FontWeight)
                            }
                            if quantity >= 3 {
                                SFTabBar.tabItem(icon: tabs.tab3Icon, label: tabs.tab3Label, color: tabs.tabItemColor, weight: tabs.tab3FontWeight)
                            }
                            if quantity >= 4 {
                                SFTabBar.tabItem(icon: tabs.tab4Icon, label: tabs.tab4Label, color: tabs.tabItemColor, weight: tabs.tab4FontWeight)
                            }
                            if quantity >= 5 {
                                SFTabBar.tabItem(icon: tabs.tab5Icon, label: tabs.tab5Label, color: tabs.tabItemColor, weight: tabs.tab5FontWeight)
                            }
                        }
                        .padding([.leading, .bottom, .trailing])
                        Image(isWhiteHomeIndicator ? "img_homeIndicator_white" : "img_homeIndicator_black" )
                            .offset(y: 28.0)
                        VRule()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(height: 1)
                            .offset(x: 0.6, y: -105.0)
                            .opacity(0.5)
                        VRule()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(height: 1)
                            .offset(x: 314.0, y: -105.0)
                            .opacity(0.5)
                    }
                    .frame(width: 315, height: 74)
                    .offset(y: 18.0)
                    Image("device_iphone11")
                        .offset(y: -10.0)
                    HRule()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                        .offset(y: -19.2)
                        .opacity(0.5)
                    HRule()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                        .offset(y: -91.0)
                        .opacity(0.5)
                }.clipped()
                .offset(y: 4.0)
                .padding(.bottom)
                Form {
                    Section(header: Text("Tab Bar Setting")) {
                        Toggle(isOn: $isWhiteHomeIndicator) {
                            Text("White Home Indicator")
                        }
                        HStack {
                            Text("Tab Bar Color")
                            Spacer()
                            ColorPicker("", selection: $tabs.tabBarColor, supportsOpacity: false)
                                .frame(width: 40, alignment: .center)
                        }
                        HStack {
                            Text("Label Color")
                            Spacer()
                            ColorPicker("", selection: $tabs.tabItemColor, supportsOpacity: false)
                                .frame(width: 40, alignment: .center)
                        }
                        HStack {
                            Text("Tint Color")
                            Spacer()
                            ColorPicker("", selection: $tabs.tabTintColor, supportsOpacity: false)
                                .frame(width: 40, alignment: .center)
                        }
                        Stepper("Display \(quantity) Tabs ", value: $quantity, in: 1...5)
                        
                    }
                    if quantity >= 1 {
                        Section(header: Text("Tab 1")) {
                            TextField("Tab Label", text: $tabs.tab1Label)
                            NavigationLink(destination: SymbolsListView(tabLocation: "tab1Icon", tabs: tabs)) {
                                Image(systemName: tabs.tab1Icon)
                                    .opacity(0.5)
                                Text(tabs.tab1Icon)
                            }
                            NavigationLink(destination: WeightListView(tabLocation: "tab1Icon", currentWeight: tabs.tab1Weight, tabIcon: tabs.tab1Icon, tabs: tabs)) {
                                Text(tabs.tab1Weight)
                                    .fontWeight(.regular)
                            }
                        }
                    }
                    if quantity >= 2 {
                        Section(header: Text("Tab 2")) {
                            TextField("Tab Label", text: $tabs.tab2Label)
                            NavigationLink(destination: SymbolsListView(tabLocation: "tab2Icon", tabs: tabs)) {
                                Image(systemName: tabs.tab2Icon)
                                    .opacity(0.5)
                                Text(tabs.tab2Icon)
                            }
                            NavigationLink(destination: WeightListView(tabLocation: "tab2Icon", currentWeight: tabs.tab2Weight, tabIcon: tabs.tab2Icon, tabs: tabs)) {
                                Text(tabs.tab2Weight)
                                    .fontWeight(.regular)
                            }
                        }
                    }
                    if quantity >= 3 {
                        Section(header: Text("Tab 3")) {
                            TextField("Tab Label", text: $tabs.tab3Label)
                            NavigationLink(destination: SymbolsListView(tabLocation: "tab3Icon", tabs: tabs)) {
                                Image(systemName: tabs.tab3Icon)
                                    .opacity(0.5)
                                Text(tabs.tab3Icon)
                            }
                            NavigationLink(destination: WeightListView(tabLocation: "tab3Icon", currentWeight: tabs.tab3Weight, tabIcon: tabs.tab3Icon, tabs: tabs)) {
                                Text(tabs.tab3Weight)
                                    .fontWeight(.regular)
                            }
                        }
                    }
                    if quantity >= 4 {
                        Section(header: Text("Tab 4")) {
                            TextField("Tab Label", text: $tabs.tab4Label)
                            NavigationLink(destination: SymbolsListView(tabLocation: "tab4Icon", tabs: tabs)) {
                                Image(systemName: tabs.tab4Icon)
                                    .opacity(0.5)
                                Text(tabs.tab4Icon)
                            }
                            NavigationLink(destination: WeightListView(tabLocation: "tab4Icon", currentWeight: tabs.tab4Weight, tabIcon: tabs.tab4Icon, tabs: tabs)) {
                                Text(tabs.tab4Weight)
                                    .fontWeight(.regular)
                            }
                        }
                    }
                    if quantity >= 5 {
                        Section(header: Text("Tab 5")) {
                            TextField("Tab Label", text: $tabs.tab5Label)
                            NavigationLink(destination: SymbolsListView(tabLocation: "tab5Icon", tabs: tabs)) {
                                Image(systemName: tabs.tab5Icon)
                                    .opacity(0.5)
                                Text(tabs.tab5Icon)
                            }
                            NavigationLink(destination: WeightListView(tabLocation: "tab5Icon", currentWeight: tabs.tab5Weight, tabIcon: tabs.tab5Icon, tabs: tabs)) {
                                Text(tabs.tab5Weight)
                                    .fontWeight(.regular)
                            }
                        }
                    }
                }
                .navigationTitle("SF TabBar")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(destination: TipJar()) {
                            Image(systemName: "hands.clap")
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        NavigationLink(destination: PlayView(tabCount: quantity, tabs: tabs)) {
                            Image(systemName: "play")
                        }
                        NavigationLink(destination: Export(tabCount: quantity, tabs: tabs)) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
                .slateToolbarStyle()
        }
        .accentColor(.pink)
        .onAppear {
            UIView.configureAlertAppearance()
        }
    }
}


struct tabItem: View {
    
    var icon: String
    var label: String
    var color: Color
    var weight: Font.Weight
                
    var body: some View {
        VStack(spacing: 4.0){
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 16.0, height: 16.0)
                .foregroundColor(color)
                .font(.system(size: 16, weight: weight))
            Text(label)
                .foregroundColor(color)
                .font(.system(size: 9))
                .lineLimit(1)
               
        } .frame(maxWidth: .infinity)
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

struct SlateToolbarStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarBackground(Color("slate"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

extension View {
    func slateToolbarStyle() -> some View {
        modifier(SlateToolbarStyle())
    }
}

// Keep alert controller styling
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
