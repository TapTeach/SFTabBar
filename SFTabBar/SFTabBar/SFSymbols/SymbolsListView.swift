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
                                buttons: [ .default(Text("All")) { filter = "All" }
                                           , .default(Text("What's New")) { filter = "What's New" }
                                           , .default(Text("Communication")) { filter = "Communication" }
                                           , .default(Text("Weather")) { filter = "Weather" }
                                           , .default(Text("Objects & Tools")) { filter = "Objects & Tools" }
                                           , .default(Text("Devices")) { filter = "Devices" }
                                           , .default(Text("Connectivity")) { filter = "Connectivity" }
                                           , .default(Text("Transportation")) { filter = "Transportation" }
                                           , .default(Text("Human")) { filter = "Human" }
                                           , .default(Text("Nature")) { filter = "Nature" }
                                           , .default(Text("Editing")) { filter = "Editing" }
                                           , .default(Text("Text Formatting")) { filter = "Text Formatting" }
                                           , .default(Text("Media")) { filter = "Media" }
                                           , .default(Text("Keyboard")) { filter = "Keyboard" }
                                           , .default(Text("Commerce")) { filter = "Commerce" }
                                           , .default(Text("Time")) { filter = "Time" }
                                           , .default(Text("Health")) { filter = "Health" }
                                           , .default(Text("Shapes")) { filter = "Shapes" }
                                           , .default(Text("Arrows")) { filter = "Arrows" }
                                           , .default(Text("Indices")) { filter = "Indices" }
                                           , .default(Text("Math")) { filter = "Math" }
                                           , .cancel()
                                ])
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

