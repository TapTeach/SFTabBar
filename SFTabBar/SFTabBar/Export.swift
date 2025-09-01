//
//  Export.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/1/20.
//

import SwiftUI
import UniformTypeIdentifiers

struct Export: View {
    
    var tabCount: Int
    
    @ObservedObject var tabs: TabsViewModel
    
    let generator = UINotificationFeedbackGenerator()
    
    var body: some View {
        List {
            Section(header: Text("iOS 26 TabView Code")) {
                HStack {
                    Text("Below is an implementation based on your configuration. Copy and paste this into your SwiftUI project.")
                        .font(.footnote)
                        .padding(.horizontal)
                    Button {
                        copyCompleteCodeToClipboard()
                        self.generator.notificationOccurred(.success)
                    } label: {
                        Image(systemName: "document.on.document")
                    }
                    .buttonStyle(.glassProminent)
                    .padding()
                    
                }
                VStack(alignment: .leading, spacing: 8) {
                    // TabView structure
                    Text("TabView {")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)
                    
                    // Individual tabs
                    ForEach(1...tabCount, id: \.self) { tabNumber in
                        generateTabCode(tabNumber: tabNumber)
                    }
                    
                    Text("}")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.blue)
                    
                    // Modifiers
                    generateModifiers()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Code Snippet")
    }
    
    // Generate individual tab code
    private func generateTabCode(tabNumber: Int) -> some View {
        let icon = getTabIcon(tabNumber)
        let label = getTabLabel(tabNumber)
        let hasSearchRole = tabNumber == tabCount && tabs.hasSearchRole
        
        return VStack(alignment: .leading, spacing: 4) {
            if hasSearchRole {
                Text("    Tab(\"\(label)\", systemImage: \"\(icon)\", role: .search) {")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.green)
                Text("        // Your search view here")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .padding(.leading, 16)
                Text("    }")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.green)
            } else {
                Text("    Tab(\"\(label)\", systemImage: \"\(icon)\") {")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.green)
                Text("        EmptyView() // Your view here")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .padding(.leading, 16)
                Text("    }")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.green)
            }
        }
    }
    
    // Generate modifiers section
    private func generateModifiers() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("")
            Text(".tabViewStyle(.sidebarAdaptable)")
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.orange)
            
            // Minimize behavior
            Text(".tabBarMinimizeBehavior(.\(tabs.tabBarMinimizeBehavior.rawValue))")
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.orange)
            
            // Bottom accessory if enabled
            if tabs.hasBottomAccessory {
                Text("")
                Text(".tabViewBottomAccessory {")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.purple)
                Text("    // Your bottom accessory content here")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .padding(.leading, 16)
                Text("}")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.purple)
            }
            
            // Color customizations
            Text("")
            Text(".accentColor(\(generateColorCode(tabs.tabTintColor)))")
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.orange)
        }
    }
    
    // Helper functions
    private func getTabIcon(_ tabNumber: Int) -> String {
        switch tabNumber {
        case 1: return tabs.tab1Icon
        case 2: return tabs.tab2Icon
        case 3: return tabs.tab3Icon
        case 4: return tabs.tab4Icon
        case 5: return tabs.tab5Icon
        default: return "circle"
        }
    }
    
    private func getTabLabel(_ tabNumber: Int) -> String {
        switch tabNumber {
        case 1: return tabs.tab1Label
        case 2: return tabs.tab2Label
        case 3: return tabs.tab3Label
        case 4: return tabs.tab4Label
        case 5: return tabs.tab5Label
        default: return "Tab \(tabNumber)"
        }
    }
    
    private func generateColorCode(_ color: Color) -> String {
        // Convert common colors to readable names
        if color == .black { return ".black" }
        if color == .white { return ".white" }
        if color == .blue { return ".blue" }
        if color == .red { return ".red" }
        if color == .green { return ".green" }
        if color == .orange { return ".orange" }
        if color == .pink { return ".pink" }
        if color == .purple { return ".purple" }
        if color == .yellow { return ".yellow" }
        return "Color(red: \(color.description))" // Fallback
    }
    
    private func copyCompleteCodeToClipboard() {
        var code = "struct SFTabBarExport: View {\n"
        code += "    var body: some View {\n"
        code += "        TabView {\n"
        
        // Add tabs
        for tabNumber in 1...tabCount {
            let icon = getTabIcon(tabNumber)
            let label = getTabLabel(tabNumber)
            let hasSearchRole = tabNumber == tabCount && tabs.hasSearchRole
            
            if hasSearchRole {
                code += "            Tab(\"\(label)\", systemImage: \"\(icon)\", role: .search) {\n"
                code += "                // Your search view here\n"
                code += "            }\n"
            } else {
                code += "            Tab(\"\(label)\", systemImage: \"\(icon)\") {\n"
                code += "                EmptyView() // Your view here\n"
                code += "            }\n"
            }
        }
        
        code += "        }\n"
        code += "        .tabViewStyle(.sidebarAdaptable)\n"
        code += "        .tabBarMinimizeBehavior(.\(tabs.tabBarMinimizeBehavior.rawValue))\n"
        
        if tabs.hasBottomAccessory {
            code += "        .tabViewBottomAccessory {\n"
            code += "            // Your bottom accessory content here\n"
            code += "        }\n"
        }
        
        code += "        .accentColor(\(generateColorCode(tabs.tabTintColor)))\n"
        code += "    }\n"
        code += "}"
        
        UIPasteboard.general.setValue(code, forPasteboardType: UTType.plainText.identifier)
        //print(code)
        
    }
}

struct Export_Previews: PreviewProvider {
    static var previews: some View {
        Export(tabCount: 5, tabs: TabsViewModel())
    }
}
