//
//  Export.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/1/20.
//

import SwiftUI
import UniformTypeIdentifiers

/// One line of generated Swift, with the colour it renders in.
///
/// Display and clipboard both read from this, so the copied code can't drift
/// from the code on screen.
private struct CodeLine: Identifiable {
    let id = UUID()
    let text: String
    var color: Color = .primary
}

struct Export: View {

    var tabCount: Int

    @ObservedObject var tabs: TabsViewModel

    let generator = UINotificationFeedbackGenerator()

    var body: some View {
        List {
            Section(header: Text("iOS 27 TabView Code")) {
                HStack {
                    Text("Below is an implementation based on your configuration. Copy and paste this into your SwiftUI project.")
                        .font(.footnote)
                        .padding(.horizontal)
                    Button {
                        UIPasteboard.general.setValue(plainText, forPasteboardType: UTType.plainText.identifier)
                        self.generator.notificationOccurred(.success)
                    } label: {
                        Image(systemName: "document.on.document")
                    }
                    .buttonStyle(.glassProminent)
                    .padding()

                }
                // Code scrolls sideways rather than wrapping -- a wrapped
                // `Tab(..., role: .prominent)` line is unreadable as code.
                ScrollView(.horizontal, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(codeLines) { line in
                            Text(line.text)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(line.color)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Code Snippet")
    }

    private var plainText: String {
        codeLines.map(\.text).joined(separator: "\n")
    }

    // MARK: - Generation

    private var codeLines: [CodeLine] {
        var lines: [CodeLine] = []

        lines.append(CodeLine(text: "struct SFTabBarExport: View {", color: .blue))
        lines.append(CodeLine(text: "    var body: some View {", color: .blue))
        lines.append(CodeLine(text: "        TabView {", color: .blue))

        for index in 0..<tabCount {
            lines.append(contentsOf: tabLines(at: index))
        }

        lines.append(CodeLine(text: "        }", color: .blue))
        lines.append(contentsOf: modifierLines())
        lines.append(CodeLine(text: "    }", color: .blue))
        lines.append(CodeLine(text: "}", color: .blue))

        return lines
    }

    private func tabLines(at index: Int) -> [CodeLine] {
        let config = tabs.tabs[index]
        var lines: [CodeLine] = []

        var arguments = "\(swiftString(config.label)), systemImage: \(swiftString(config.icon))"
        if let role = config.role.codeArgument {
            arguments += ", role: \(role)"
        }

        lines.append(CodeLine(text: "            Tab(\(arguments)) {", color: .green))

        switch config.role {
        case .search:
            lines.append(CodeLine(text: "                // Your search view here", color: .secondary))
        case .prominent:
            lines.append(CodeLine(text: "                EmptyView() // The destination this tab highlights", color: .secondary))
        case .none:
            lines.append(CodeLine(text: "                EmptyView() // Your view here", color: .secondary))
        }

        lines.append(CodeLine(text: "            }", color: .green))

        if config.canShowBadge && config.hasNotification {
            lines.append(CodeLine(text: "            .badge(\(swiftString(config.badgeText)))", color: .red))
        }

        return lines
    }

    private func modifierLines() -> [CodeLine] {
        var lines: [CodeLine] = []

        lines.append(CodeLine(text: ""))
        lines.append(CodeLine(text: "        .tabViewStyle(.sidebarAdaptable)", color: .orange))
        lines.append(CodeLine(text: "        .tabBarMinimizeBehavior(.\(tabs.tabBarMinimizeBehavior.rawValue))", color: .orange))

        if tabs.hasBottomAccessory {
            lines.append(CodeLine(text: ""))
            lines.append(CodeLine(text: "        .tabViewBottomAccessory {", color: .purple))
            lines.append(CodeLine(text: "            // Your bottom accessory content here", color: .secondary))
            lines.append(CodeLine(text: "        }", color: .purple))
        }

        lines.append(CodeLine(text: ""))
        lines.append(CodeLine(text: "        .tint(\(colorLiteral(tabs.tabTintColor)))", color: .orange))
        lines.append(CodeLine(text: "        .foregroundStyle(\(colorLiteral(tabs.tabItemColor)))", color: .orange))

        return lines
    }

    // MARK: - Swift literals

    /// Quotes and escapes a string so a label containing `"` or `\` still
    /// produces code that compiles.
    private func swiftString(_ value: String) -> String {
        let escaped = value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        return "\"\(escaped)\""
    }

    /// A named colour where one matches, otherwise explicit components.
    ///
    /// The previous fallback interpolated `Color.description`, which does not
    /// produce valid Swift for a colour picked in the colour wheel.
    private func colorLiteral(_ color: Color) -> String {
        let named: [(Color, String)] = [
            (.primary, ".primary"),
            (.secondary, ".secondary"),
            (.black, ".black"),
            (.white, ".white"),
            (.blue, ".blue"),
            (.red, ".red"),
            (.green, ".green"),
            (.orange, ".orange"),
            (.pink, ".pink"),
            (.purple, ".purple"),
            (.yellow, ".yellow"),
            (.gray, ".gray"),
            (.brown, ".brown"),
            (.cyan, ".cyan"),
            (.indigo, ".indigo"),
            (.mint, ".mint"),
            (.teal, ".teal"),
        ]

        for (candidate, name) in named where candidate == color {
            return name
        }

        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        func component(_ value: CGFloat) -> String {
            String(format: "%.3f", value)
        }
        return "Color(red: \(component(red)), green: \(component(green)), blue: \(component(blue)))"
    }
}

struct Export_Previews: PreviewProvider {
    static var previews: some View {
        Export(tabCount: 5, tabs: TabsViewModel())
    }
}
