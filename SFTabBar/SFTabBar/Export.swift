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
    
    @ObservedObject var tabs = TabsViewModel()
    
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
            List {
                Text("Below is an example of each tab's implementation with SwiftUI. Your .tabItem should be a modifier of a view and contained within a TabView()")
                    .font(.callout)
                    .padding(.top, 4.0)
                Link("Learn about TabView()", destination: URL(string: "https://developer.apple.com/documentation/swiftui/tabview")!)
                    .padding(.top, 4.0)
                //need to add if statements to exlude unused tabs
                if tabCount >= 1 {
                exportRow(tabTag: 1, tabIcon: tabs.tab1Icon, tabLabel: tabs.tab1Label)
                }
                if tabCount >= 2 {
                exportRow(tabTag: 2, tabIcon: tabs.tab2Icon, tabLabel: tabs.tab2Label)
                }
                if tabCount >= 3 {
                exportRow(tabTag: 3, tabIcon: tabs.tab3Icon, tabLabel: tabs.tab3Label)
                }
                if tabCount >= 4 {
                exportRow(tabTag: 4, tabIcon: tabs.tab4Icon, tabLabel: tabs.tab4Label)
                }
                if tabCount >= 5 {
                exportRow(tabTag: 5, tabIcon: tabs.tab5Icon, tabLabel: tabs.tab5Label)
                }
            }
            .padding(.top)
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Share")
    }
}

struct exportRow: View {
    
    var tabTag: Int
    var tabIcon: String
    var tabLabel: String
        
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        Section(header: Text("Tab " + String(tabTag))) {
        VStack(alignment: .leading) {
            Text(".tabItem({").foregroundColor(Color("modifier"))
            Text("  Image(systemName:").foregroundColor(Color("modifier")) +
                Text("\"" + tabIcon + "\"").foregroundColor(.primary) +
            Text(")").foregroundColor(Color("modifier"))
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
        Export(tabCount: 5)
            //.environment(\.colorScheme, .dark)
    }
}
