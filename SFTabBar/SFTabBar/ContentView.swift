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
    
    @Published var tab2Label = "Trends"
    @Published var tab2Icon = "flame"
    
    @Published var tab3Label = "Shop"
    @Published var tab3Icon = "bag"
    
    @Published var tab4Label = "Profile"
    @Published var tab4Icon = "person.crop.circle"
    
    @Published var tab5Label = "More"
    @Published var tab5Icon = "ellipsis"
    
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
}

struct ContentView: View {

    @State private var showingSheet = false
    
    @State private var tbColor = Color.pink
    
    @State var isWhiteHomeIndicator = false
    @State var quantity: Int = 5
    
    @ObservedObject var tabs = TabsViewModel()
    
    let generator = UINotificationFeedbackGenerator()
    
        
    var body: some View {
        
        NavigationView {
            VStack {
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 0, style: .continuous)
                            .fill(tbColor)
                        HStack(alignment: .top){
                            if quantity >= 1 {
                                SFTabBar.tabItem(icon: tabs.tab1Icon, label: tabs.tab1Label, color: tabs.tabTintColor)
                            }
                            if quantity >= 2 {
                                SFTabBar.tabItem(icon: tabs.tab2Icon, label: tabs.tab2Label, color: tabs.tabItemColor)
                            }
                            if quantity >= 3 {
                                SFTabBar.tabItem(icon: tabs.tab3Icon, label: tabs.tab3Label, color: tabs.tabItemColor)
                            }
                            if quantity >= 4 {
                                SFTabBar.tabItem(icon: tabs.tab4Icon, label: tabs.tab4Label, color: tabs.tabItemColor)
                            }
                            if quantity >= 5 {
                                SFTabBar.tabItem(icon: tabs.tab5Icon, label: tabs.tab5Label, color: tabs.tabItemColor)
                            }
                        }
                        .padding([.leading, .bottom, .trailing])
                        Image(isWhiteHomeIndicator ? "img_homeIndicator_white" : "img_homeIndicator_black" )
                            .offset(y: 28.0)
                    }
                    .frame(width: 315, height: 74)
                    .offset(y: 18.0)
                    Image("device_iphone11")
                        .offset(y: -10.0)
                        
                }.clipped()
                Form {
                    Section(header: Text("Tab Bar Setting")) {
                        Toggle(isOn: $isWhiteHomeIndicator) {
                            Text("White Home Indicator")
                        }
                        HStack {
                            Text("Tab Bar Color")
                            Spacer()
                            ColorPicker("", selection: $tbColor, supportsOpacity: false)
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
                    Section(header: Text("Tab 1")) {
                        TextField("Tab Label", text: $tabs.tab1Label)
                        NavigationLink(destination: SymbolsListView(tabLocation: "tab1Icon", tabs: tabs)) {
                            Image(systemName: tabs.tab1Icon)
                                .opacity(0.5)
                            Text(tabs.tab1Icon)
                        }
                    }
                    Section(header: Text("Tab 2")) {
                        TextField("Tab Label", text: $tabs.tab2Label)
                        NavigationLink(destination: SymbolsListView(tabLocation: "tab2Icon", tabs: tabs)) {
                            Image(systemName: tabs.tab2Icon)
                                .opacity(0.5)
                            Text(tabs.tab2Icon)
                        }
                    }
                    Section(header: Text("Tab 3")) {
                        TextField("Tab Label", text: $tabs.tab3Label)
                        NavigationLink(destination: SymbolsListView(tabLocation: "tab3Icon", tabs: tabs)) {
                            Image(systemName: tabs.tab3Icon)
                                .opacity(0.5)
                            Text(tabs.tab3Icon)
                        }
                    }
                    Section(header: Text("Tab 4")) {
                        TextField("Tab Label", text: $tabs.tab4Label)
                        NavigationLink(destination: SymbolsListView(tabLocation: "tab4Icon", tabs: tabs)) {
                            Image(systemName: tabs.tab4Icon)
                                .opacity(0.5)
                            Text(tabs.tab4Icon)
                        }
                    }
                    Section(header: Text("Tab 5")) {
                        TextField("Tab Label", text: $tabs.tab5Label)
                        NavigationLink(destination: SymbolsListView(tabLocation: "tab5Icon", tabs: tabs)) {
                            Image(systemName: tabs.tab5Icon)
                                .opacity(0.5)
                            Text(tabs.tab5Icon)
                        }
                    }
                    Section(header: Text("Documentation")) {
                    Link("SF Symbols 2.0", destination: URL(string: "https://developer.apple.com/sf-symbols/")!)
                    Link("Apple HIG Tab Bars", destination: URL(string: "https://developer.apple.com/design/human-interface-guidelines/ios/bars/tab-bars/")!)
                    }
                }
                .navigationBarTitle("SF TabBar")
                .navigationBarItems(trailing:
                                        NavigationLink(destination: Export(tabCount: quantity)) {
                        Image(systemName: "square.and.arrow.up")
                        }

                )
            }
        }
        .accentColor(.pink)
    }
}

struct tabItem: View {
    
    var icon: String
    var label: String
    var color: Color
                
    var body: some View {
        VStack{
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 16.0, height: 16.0)
                .foregroundColor(color)
            Text(label)
                .foregroundColor(color)
                .font(.system(size: 9))
                .lineLimit(1)
               
        } .frame(maxWidth: .infinity)
    }
}

struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {

    }
}


extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = UIColor(named: "slate")
        standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = UIColor(named: "slate")
        scrollEdgeAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        scrollEdgeAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationBar.standardAppearance = standardAppearance
        navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
    }
}
