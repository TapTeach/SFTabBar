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
    
    var tabLocation: String
    
    @ObservedObject var tabs = TabsViewModel()
    
    @State private var searchText : String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List {
                ForEach(sflibrary) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.items.filter {
                            self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
                        }) { item in
                            SymbolRow(name: item)
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                    tabs.tab1Icon = item
                                    print("the tab I want to update" + tabLocation + " I just selected:" + item + " updated var value" + tabs.tab1Icon )
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
}


struct SymbolsListView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolsListView(tabLocation: "tab1Icon")
            .environment(\.colorScheme, .dark)
    }
}

