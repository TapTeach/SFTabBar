//
//  ContentView.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/16/20.
//

import SwiftUI



struct ContentView: View {
    
    @State private var editMode = EditMode.inactive
    
    @State private var tabItemColor = Color.white
    @State private var tintColor = Color.red
    @State private var tbColor = Color.green
    
    @State var isDarkMode = false
    @State var quantity: Int = 3
    @State var tab1Label: String = ""
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(tbColor)
                        HStack(alignment: .top){
                            SFTabBar.tabItem()
                            SFTabBar.tabItem()
                            SFTabBar.tabItem()
                        }
                        .padding(.bottom)
                    }
                    .frame(width: 320, height: 85)
                    .offset(y: 52.0)
                    Image("img_iphone11")
                        
                }.clipped()
                Form {
                    Section(header: Text("Tab Bar Setting")) {
                        Toggle(isOn: $isDarkMode) {
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
                        Stepper("\(quantity) Tabs ", value: $quantity, in: 0...5)
                        
                    }
                    Section(header: Text("Tab 1")) {
                        TextField("Tab Label", text: $tab1Label)
                        NavigationLink("Select a SF Symbol", destination: Text("Detail").navigationBarTitle(Text("Select SFSymbol")))
                    }
                    Section(header: Text("Tab 2")) {
                        TextField("Tab Label", text: $tab1Label)
                        NavigationLink("Select a SF Symbol", destination: Text("Detail").navigationBarTitle(Text("Select SFSymbol")))
                    }
                }
                .navigationBarTitle("SF TabBar")
            }
        }
        
    }
}

struct tabItem: View {

    
    var body: some View {
        VStack{
            Image(systemName: "hare")
                .foregroundColor(Color.white)
            Text("Label")
                .font(.caption2)
                .foregroundColor(Color.white)
               
        } .frame(maxWidth: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
