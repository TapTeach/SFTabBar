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
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(.all, 6.0)
        .frame(maxWidth: .infinity)
    }
}

struct SymbolsListView: View {
    
    var tabLocation: String
    
    @ObservedObject var tabs: TabsViewModel
    
    @State private var searchText : String = ""
    @State private var filter : String = "All"
    @State private var showingSheet = false
    
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var categoryButtons: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = [.default(Text("All")) { filter = "All" }]
        
        // Add buttons for each category from the JSON data
        for section in sflibrary {
            buttons.append(.default(Text(section.title)) { filter = section.title })
        }
        
        // Add cancel button at the end
        buttons.append(.cancel())
        
        return buttons
    }
    
    var body: some View {
            VStack {
                SearchBar(text: $searchText)
                List {
                    ForEach(sflibrary) { section in
                        if (section.title == filter) || (filter == "All") {
                            Section(header: Text(section.title + " (" + String(section.items.count) + ")")) {
                                ForEach(section.items.filter {
                                    self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
                                }) { item in
                                    SymbolRow(name: item)
                                        .onTapGesture {
                                            presentationMode.wrappedValue.dismiss()
                                            tabs.update(location: tabLocation, to: item)
                                            selectionFeedback.selectionChanged()
                                        }
                                }
                            }
                        }
                    }
                    
                }
                .accentColor(.pink)
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Select SF Symbol")
            }
            .navigationBarItems(trailing:
                Button("Categories") {
                    self.showingSheet = true
                }
                .actionSheet(isPresented: $showingSheet) {
                    ActionSheet(title: Text("Filter SF Symbols by Category"),
                              buttons: categoryButtons)
                }
            )
    }
}


struct SymbolsListView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolsListView(tabLocation: "tab1Icon", tabs: TabsViewModel())
            .environment(\.colorScheme, .dark)
    }
}

