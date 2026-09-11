//
//  SymbolsListView.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/29/20.
//

import SwiftUI

struct SymbolRow: View {
    var name: String
    var isNew: Bool = false

    var body: some View {
        HStack {
            Image(systemName: name)
                .frame(width:40)
                .padding(.trailing, 6.0)
                .imageScale(.large)
            Text(name)
                .font(.subheadline)
            Spacer()
            if isNew {
                Text("New")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.pink)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.pink.opacity(0.15), in: Capsule())
            }
        }
        .contentShape(Rectangle())
        .padding(.all, 6.0)
        .frame(maxWidth: .infinity)
    }
}

struct SymbolsListView: View {

    var tabIndex: Int

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

    private func matches(_ section: Library) -> [String] {
        guard !searchText.isEmpty else { return section.items }
        let query = searchText.lowercased()
        return section.items.filter { $0.lowercased().contains(query) }
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 20))
                    Spacer()
                    Text("You can choose any SF Symbol, but iOS may display a variant depending on context. For example, TabViews automatically use the .filled version per Apple's Human Interface Guidelines.")
                        .font(.footnote)
                        .foregroundColor(Color.primary)
                        .padding(.vertical, 4.0)
                }
            }
            ForEach(sflibrary) { section in
                if (section.title == filter) || (filter == "All") {
                    let items = matches(section)
                    if !items.isEmpty {
                        Section {
                            // Keyed by name rather than a fresh UUID per row so
                            // typing in the search field doesn't reallocate
                            // identity for every symbol in the catalog.
                            ForEach(items, id: \.self) { item in
                                SymbolRow(name: item, isNew: symbolCatalog.isNew(item))
                                    .onTapGesture {
                                        presentationMode.wrappedValue.dismiss()
                                        tabs.update(icon: item, at: tabIndex)
                                        selectionFeedback.selectionChanged()
                                    }
                            }
                        } header: {
                            HStack {
                                if let icon = section.icon {
                                    Image(systemName: icon)
                                }
                                Text("\(section.title) (\(items.count))")
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search SF Symbols")
        .accentColor(.pink)
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Select SF Symbol")
            .navigationBarItems(trailing:
                Button("Categories") {
                    self.showingSheet = true
                }
                .actionSheet(isPresented: $showingSheet) {
                    ActionSheet(title: Text("Filter by Category"),
                              buttons: categoryButtons)
                }
            )
    }
}


struct SymbolsListView_Previews: PreviewProvider {
    static var previews: some View {
        SymbolsListView(tabIndex: 0, tabs: TabsViewModel())
            .environment(\.colorScheme, .dark)
    }
}
