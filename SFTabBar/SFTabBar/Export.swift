//
//  Export.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/1/20.
//

import SwiftUI
import MobileCoreServices

struct Export: View {
    
    var tabCount: Int
    
    @ObservedObject var tabs: TabsViewModel
    
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
            List {
                Section(header: Text("")) {
                Text("Below is an example of each tab's implementation with SwiftUI. Your .tabItem should be a modifier of a view and contained within a TabView() \n\rTab views only support tab items of type Text, Image, or an image followed by text. Passing any other type of view results in a visible but empty tab item.")
                    .font(.footnote)
                    .padding(.top, 4.0)
                }
                if tabCount >= 1 {
                    exportRow(tabTag: 1, tabIcon: tabs.tab1Icon, tabLabel: tabs.tab1Label, iconWeight: tabs.tab1Weight)
                }
                if tabCount >= 2 {
                exportRow(tabTag: 2, tabIcon: tabs.tab2Icon, tabLabel: tabs.tab2Label, iconWeight: tabs.tab2Weight)
                }
                if tabCount >= 3 {
                exportRow(tabTag: 3, tabIcon: tabs.tab3Icon, tabLabel: tabs.tab3Label, iconWeight: tabs.tab3Weight)
                }
                if tabCount >= 4 {
                exportRow(tabTag: 4, tabIcon: tabs.tab4Icon, tabLabel: tabs.tab4Label, iconWeight: tabs.tab4Weight)
                }
                if tabCount >= 5 {
                exportRow(tabTag: 5, tabIcon: tabs.tab5Icon, tabLabel: tabs.tab5Label, iconWeight: tabs.tab5Weight)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Share")
            .slateToolbarStyle()
    }
}

struct exportRow: View {
    
    var tabTag: Int
    var tabIcon: String
    var tabLabel: String
    var iconWeight: String
        
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        Section(header: Text("Tab " + String(tabTag))) {
        VStack(alignment: .leading) {
            Text(".tabItem({").foregroundColor(Color("modifier"))
            Text("  Image(systemName:").foregroundColor(Color("modifier")) +
                Text("\"" + tabIcon + "\"").foregroundColor(.primary) +
            Text(")").foregroundColor(Color("modifier"))
//            Text("  .font(.system(size: 16, weight: ").foregroundColor(Color("modifier")) +
//            Text(iconWeight).foregroundColor(.primary) +
//            Text("))").foregroundColor(Color("modifier"))
            Text("  Text(").foregroundColor(Color("modifier")) +
            Text("\"" + tabLabel + "\"").foregroundColor(.primary) +
            Text(")").foregroundColor(Color("modifier"))
            Text("})").foregroundColor(Color("modifier"))
            Text(".tag(" + String(tabTag - 1) + ")").foregroundColor(Color("modifier"))
        }
        .padding([.top, .bottom])
            Button("Copy to Clipboard") {
                UIPasteboard.general.setValue(String(".tabItem({ \r Image(systemName:\"" + tabIcon + "\")\r" + "Text(\"") + tabLabel + "\")\r" + "})\r" + ".tag(" + String(tabTag - 1) + ")",
                            forPasteboardType: kUTTypePlainText as String)
                self.generator.notificationOccurred(.success)
            }
        }
        
    }
}

struct Export_Previews: PreviewProvider {
    static var previews: some View {
        Export(tabCount: 5, tabs: TabsViewModel())
            //.environment(\.colorScheme, .dark)
    }
}
