//
//  SymbolsListView.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/29/20.
//

import SwiftUI

struct SymbolRow: View {
    var name: String
    
    var body: some View {
        HStack {
            Image(systemName: name)
                .frame(width:40)
                .padding(.trailing, 6.0)
                .imageScale(.large)
                
            Text(name)
                .font(.subheadline)
        }
        .padding(.all, 6.0)
        
    }
}

struct SymbolsListView: View {
    
    var tab: String
    
    @ObservedObject var tabs = TabsViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        List {
            ForEach(sflibrary) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.items) { item in
                        SymbolRow(name: item)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                                //tabs.tab1icon = item
                                print(tab)
                                //need to pass name to form
                            }
                    }
                }
            }
            
        }
        .accentColor(.pink)
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Select SF Symbol")
    }
}


struct SymbolsListView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolsListView(tab: "tab1Icon")
            .environment(\.colorScheme, .dark)
    }
}

