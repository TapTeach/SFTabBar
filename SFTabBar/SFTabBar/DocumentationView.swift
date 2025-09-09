//
//  DocumentationView.swift
//  SFTabBar
//
//  Created by Adam Jones on 8/31/25.
//

import SwiftUI

struct DocumentionView: View {
    
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    @State private var showingShareSheet = false
    
    var body: some View {
        List {
            Section(header: Text("Tab Bar Resources")) {
                Link("Apple HIG Tab Bars", destination: URL(string: "https://developer.apple.com/design/human-interface-guidelines/ios/bars/tab-bars/")!)
                Link("TabView", destination: URL(string: "https://developer.apple.com/documentation/swiftui/tabview")!)
                Link("TabSearchActivation", destination: URL(string: "https://developer.apple.com/documentation/swiftui/tabsearchactivation")!)
                Link("TabBarMinimizeBehavior", destination: URL(string: "https://developer.apple.com/documentation/swiftui/tabbarminimizebehavior")!)
                Link("TabViewBottomAccessoryPlacement", destination: URL(string: "https://developer.apple.com/documentation/swiftui/tabviewbottomaccessoryplacement")!)
                Link("TabRole", destination: URL(string: "https://developer.apple.com/documentation/swiftui/tabrole")!)
            }
            Section(header: Text("Liquid Glass Resources")) {
                Link("Adopting Liquid Glass", destination: URL(string: "https://developer.apple.com/documentation/TechnologyOverviews/adopting-liquid-glass")!)
                Link("Applying Liquid Glass to Custom Views", destination: URL(string: "https://developer.apple.com/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views")!)
                Link(".glassEfftect()", destination: URL(string: "https://developer.apple.com/documentation/SwiftUI/View/glassEffect(_:in:)")!)
                
            }
            Section(header: Text("SFSymbols Resources")) {
                Link("SF Symbols 7.0", destination: URL(string: "https://developer.apple.com/sf-symbols/")!)
            }
            Section(header: Text("Share the App")) {
                HStack {
                    Link(destination: URL(string: "https://apps.apple.com/us/app/id1533863571?mt=8&action=write-review")!) {
                        Text("Rate the App")
                    }
                }
                HStack {
                    Button(action: {
                        self.showingShareSheet = true
                    }) {
                        Text("Share with Friends")
                    }
                    .sheet(isPresented: $showingShareSheet,
                           content: {
                            ActivityView(activityItems: [NSURL(string: "https://apps.apple.com/us/app/id1533863571")!] as [Any], applicationActivities: nil) })
                }
                HStack {
                    Text("App Version")
                    Spacer()
                    Text(appVersionString)
                        .foregroundColor(Color.gray)
                }
            }
        }
        .accentColor(.pink)
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("Documentation")
    }
}

struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {

    }
}

#Preview {
    NavigationStack {
        DocumentionView()
    }
}
