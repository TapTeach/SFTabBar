//
//  ContentView.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/16/20.
//

import SwiftUI

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
}

struct ContentView: View {
    
    @State private var editMode = EditMode.inactive
    
    @State private var tabItemColor = Color.white
    @State private var tintColor = Color.red
    @State private var tbColor = Color.green
    
    @State var isWhiteHomeIndicator = false
    @State var quantity: Int = 5
    
    @ObservedObject var tabs = TabsViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 0, style: .continuous)
                            .fill(tbColor)
                        HStack(alignment: .top){
                            SFTabBar.tabItem(icon: tabs.tab1Icon, label: tabs.tab1Label)
                            SFTabBar.tabItem(icon: tabs.tab2Icon, label: tabs.tab2Label)
                            SFTabBar.tabItem(icon: tabs.tab3Icon, label: tabs.tab3Label)
                            SFTabBar.tabItem(icon: tabs.tab4Icon, label: tabs.tab4Label)
                            SFTabBar.tabItem(icon: tabs.tab5Icon, label: tabs.tab5Label)
                        }
                        .padding([.leading, .bottom, .trailing])
                        Image(isWhiteHomeIndicator ? "img_homeIndicator_white" : "img_homeIndicator_black" )
                            .offset(y: 24.0)
                    }
                    .frame(width: 315, height: 74)
                    .offset(y: 34.0)
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
                            ColorPicker("", selection: $tabItemColor, supportsOpacity: false)
                                .frame(width: 40, alignment: .center)
                        }
                        HStack {
                            Text("Tint Color")
                            Spacer()
                            ColorPicker("", selection: $tintColor, supportsOpacity: false)
                                .frame(width: 40, alignment: .center)
                        }
                        Stepper("Display \(quantity) Tabs ", value: $quantity, in: 1...5)
                        
                    }
                    Section(header: Text("Tab 1")) {
                        TextField("Tab Label", text: $tabs.tab1Label)
                        NavigationLink("Select a SF Symbol", destination: Text("Detail").navigationBarTitle(Text("Select SFSymbol")))
                    }
                    Section(header: Text("Tab 2")) {
                        TextField("Tab Label", text: $tabs.tab2Label)
                        NavigationLink("Select a SF Symbol", destination: Text("Detail").navigationBarTitle(Text("Select SFSymbol")))
                    }
                    Section(header: Text("Tab 3")) {
                        TextField("Tab Label", text: $tabs.tab3Label)
                        NavigationLink("Select a SF Symbol", destination: Text("Detail").navigationBarTitle(Text("Select SFSymbol")))
                    }
                    Section(header: Text("Tab 4")) {
                        TextField("Tab Label", text: $tabs.tab4Label)
                        NavigationLink("Select a SF Symbol", destination: Text("Detail").navigationBarTitle(Text("Select SFSymbol")))
                    }
                    Section(header: Text("Tab 5")) {
                        TextField("Tab Label", text: $tabs.tab5Label)
                        NavigationLink("Select a SF Symbol", destination: Text("Detail").navigationBarTitle(Text("Select SFSymbol")))
                    }
                }
                .navigationBarTitle("SF TabBar")
                .navigationBarItems(trailing:
                    Button(action: {
                        print("Share Me!")
                    }) {
                        Image(systemName: "square.and.arrow.up").imageScale(.large)
                            .foregroundColor(.pink)
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
        
    var body: some View {
        VStack{
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 16.0, height: 16.0)
                .foregroundColor(Color.white)
            Text(label)
                .foregroundColor(Color.white)
                .font(.system(size: 9))
                .lineLimit(1)
               
        } .frame(maxWidth: .infinity)
    }
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = .black
        standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .black
        scrollEdgeAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationBar.standardAppearance = standardAppearance
        navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
