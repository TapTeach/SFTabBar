//
//  WeightListView.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/2/20.
//

import SwiftUI

struct Weight: Identifiable {
    var id = UUID()
    var name: String
    var weight: Font.Weight
}

struct WeightListView: View {
    
    var tabLocation: String
    var currentWeight: String
    var tabIcon: String
        
    @ObservedObject var tabs: TabsViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        
        let u = Weight(name: ".ultralight", weight: .ultraLight)
        let t = Weight(name: ".thin", weight: .thin)
        let l = Weight(name: ".light", weight: .light)
        let r = Weight(name: ".regular", weight: .regular)
        let m = Weight(name: ".medium", weight: .medium)
        let s = Weight(name: ".semibold", weight: .semibold)
        let b = Weight(name: ".bold", weight: .bold)
        let h = Weight(name: ".heavy", weight: .heavy)
        let bl = Weight(name: ".black", weight: .black)
        let weights = [u, t, l, r, m, s, b, h, bl]
        
        return VStack {
            List {
                Section(header: Text("")) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 20))
                        Spacer()
                        Text("Weight is not currently supported on a .tabitem image. However, you can use this to get a sense of the impact weight has on an SF Symbol.")
                            .font(.footnote)
                            .foregroundColor(Color.primary)
                            .padding(.vertical, 4.0)
                    }
                }
                Section(header: Text("Weights")) {
                    ForEach(weights) { weight in
                        WeightRow(symbol: tabIcon, current: currentWeight, weight: weight)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                                tabs.updateWeight(location: tabLocation, to: weight.name, font: weight.weight)
                                selectionFeedback.selectionChanged()
                            }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("SF Symbol Weight")
        //.slateToolbarStyle()
    }
    }
}

struct WeightRow: View {
    
    var symbol: String
    var current: String
    var weight: Weight
    
    var body: some View {
        HStack {
            Label(weight.name, systemImage: symbol)
                .font(.system(size: 16, weight: weight.weight))
            Spacer()
            if current == weight.name {
            Image(systemName: "checkmark")
                .foregroundColor(.pink)
            }
        }.contentShape(Rectangle())
        
    }
}

struct WeightListView_Previews: PreviewProvider {
    static var previews: some View {
        WeightListView(tabLocation: "tab1Icon", currentWeight: ".regular",  tabIcon: "globe", tabs: TabsViewModel())
    }
}
