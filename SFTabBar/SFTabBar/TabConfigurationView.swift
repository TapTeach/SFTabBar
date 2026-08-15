//
//  TabConfigurationView.swift
//  SFTabBar
//
//  Created for reusable tab configuration
//

import SwiftUI

struct TabConfigurationView: View {
    let tabIndex: Int
    @ObservedObject var tabs: TabsViewModel

    private var config: TabConfig {
        tabs.tabs[tabIndex]
    }

    /// Explains the trailing slot, which Search and Prominent compete for.
    ///
    /// Only one tab gets the separate button beside the tab bar. When both
    /// roles are assigned, Prominent wins it and the Search tab drops back
    /// into the bar, which is the surprising part worth spelling out.
    private var roleNote: String? {
        switch config.role {
        case .none:
            return nil
        case .prominent:
            if tabs.searchIndex != nil {
                return "Prominent takes priority, so your other tab with Search will move inside the tab bar."
            }
        case .search:
            if tabs.prominentIndex != nil {
                return "You have another tab with Prominent, so Search will sit inside the tab bar."
            }
        }
        return "Search and Prominent share the button. Only one tab can use it, and Prominent takes priority."
    }

    private var roleBinding: Binding<TabRoleOption> {
        Binding(
            get: { tabs.tabs[tabIndex].role },
            // Routed through the model so the previous holder of the role is
            // cleared -- only one tab may be search, and only one prominent.
            set: { tabs.setRole($0, at: tabIndex) }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Tab \(tabIndex + 1)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                // Tab Label
                HStack {
                    TextField("Tab Label", text: $tabs.tabs[tabIndex].label)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemGroupedBackground))

                Divider()
                    .padding(.leading, 16)

                // Icon Selection
                NavigationLink(destination: SymbolsListView(tabIndex: tabIndex, tabs: tabs)) {
                    HStack {
                        Image(systemName: config.icon)
                            .opacity(0.5)
                        Text(config.icon)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color(.secondarySystemGroupedBackground))

                Divider()
                    .padding(.leading, 16)

                // Weight Selection
                NavigationLink(destination: WeightListView(tabIndex: tabIndex, currentWeight: config.weight, tabIcon: config.icon, tabs: tabs)) {
                    HStack {
                        Text(config.weight)
                            .fontWeight(.regular)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color(.secondarySystemGroupedBackground))

                Divider()
                    .padding(.leading, 16)

                // Role - any tab can take one
                HStack {
                    Text("Role")
                        .foregroundColor(.primary)
                    Spacer()
                    Picker("", selection: roleBinding.animation(.spring(response: 0.5, dampingFraction: 0.7))) {
                        ForEach(TabRoleOption.allCases) { role in
                            Text(role.displayName).tag(role)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 170, alignment: .trailing)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemGroupedBackground))

                if let note = roleNote {
                    Divider()
                        .padding(.leading, 16)

                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        Text(note)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    // Without this the HStack sizes to its text and the parent
                    // VStack centres it, insetting the row from the ones above
                    // and below.
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground))
                }

                // Notification Dot - a search tab has no room for a badge
                if config.canShowBadge {
                    Divider()
                        .padding(.leading, 16)

                    HStack {
                        Text("Notification Dot")
                            .foregroundColor(.primary)
                        Spacer()
                        Toggle("", isOn: $tabs.tabs[tabIndex].hasNotification.animation(.spring(response: 0.4, dampingFraction: 0.6)))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))

                    if config.hasNotification {
                        Divider()
                            .padding(.leading, 16)

                        HStack {
                            TextField("Notification Value", text: $tabs.tabs[tabIndex].notificationValue)
                                .onChange(of: config.notificationValue) { _, newValue in
                                    if newValue.count > 3 {
                                        tabs.tabs[tabIndex].notificationValue = String(newValue.prefix(3))
                                    }
                                }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.secondarySystemGroupedBackground))
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    TabConfigurationView(tabIndex: 0, tabs: TabsViewModel())
        .padding()
}
