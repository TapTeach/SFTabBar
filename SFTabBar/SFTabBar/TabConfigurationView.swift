//
//  TabConfigurationView.swift
//  SFTabBar
//
//  Created for reusable tab configuration
//

import SwiftUI

struct TabConfigurationView: View {
    let tabNumber: Int
    let quantity: Int
    @ObservedObject var tabs: TabsViewModel
    
    private var labelBinding: Binding<String> {
        switch tabNumber {
        case 1: return $tabs.tab1Label
        case 2: return $tabs.tab2Label
        case 3: return $tabs.tab3Label
        case 4: return $tabs.tab4Label
        case 5: return $tabs.tab5Label
        default: return .constant("")
        }
    }
    
    private var iconBinding: Binding<String> {
        switch tabNumber {
        case 1: return $tabs.tab1Icon
        case 2: return $tabs.tab2Icon
        case 3: return $tabs.tab3Icon
        case 4: return $tabs.tab4Icon
        case 5: return $tabs.tab5Icon
        default: return .constant("")
        }
    }
    
    private var weightBinding: Binding<String> {
        switch tabNumber {
        case 1: return $tabs.tab1Weight
        case 2: return $tabs.tab2Weight
        case 3: return $tabs.tab3Weight
        case 4: return $tabs.tab4Weight
        case 5: return $tabs.tab5Weight
        default: return .constant("")
        }
    }
    
    private var notificationBinding: Binding<Bool> {
        switch tabNumber {
        case 1: return $tabs.tab1HasNotification
        case 2: return $tabs.tab2HasNotification
        case 3: return $tabs.tab3HasNotification
        case 4: return $tabs.tab4HasNotification
        case 5: return $tabs.tab5HasNotification
        default: return .constant(false)
        }
    }
    
    private var notificationValueBinding: Binding<String> {
        switch tabNumber {
        case 1: return $tabs.tab1NotificationValue
        case 2: return $tabs.tab2NotificationValue
        case 3: return $tabs.tab3NotificationValue
        case 4: return $tabs.tab4NotificationValue
        case 5: return $tabs.tab5NotificationValue
        default: return .constant("")
        }
    }
    
    private var tabLocation: String {
        "tab\(tabNumber)Icon"
    }
    
    private var isLastTab: Bool {
        tabNumber == quantity
    }
    
    private var hasSearchRole: Bool {
        isLastTab && tabs.hasSearchRole
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Tab \(tabNumber)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                // Tab Label
                HStack {
                    TextField("Tab Label", text: labelBinding)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemGroupedBackground))
                
                Divider()
                    .padding(.leading, 16)
                
                // Icon Selection
                NavigationLink(destination: SymbolsListView(tabLocation: tabLocation, tabs: tabs)) {
                    HStack {
                        Image(systemName: iconBinding.wrappedValue)
                            .opacity(0.5)
                        Text(iconBinding.wrappedValue)
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
                NavigationLink(destination: WeightListView(tabLocation: tabLocation, currentWeight: weightBinding.wrappedValue, tabIcon: iconBinding.wrappedValue, tabs: tabs)) {
                    HStack {
                        Text(weightBinding.wrappedValue)
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
                
                // Search Role Toggle - only show on last tab
                if isLastTab {
                    Divider()
                        .padding(.leading, 16)
                    
                    HStack {
                        Text("Search Role")
                            .foregroundColor(.primary)
                        Spacer()
                        Toggle("", isOn: $tabs.hasSearchRole)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                }
                
                // Notification Dot - only show if not search role
                if !hasSearchRole {
                    Divider()
                        .padding(.leading, 16)
                    
                    HStack {
                        Text("Notification Dot")
                            .foregroundColor(.primary)
                        Spacer()
                        Toggle("", isOn: notificationBinding.animation(.spring(response: 0.4, dampingFraction: 0.6)))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    
                    if notificationBinding.wrappedValue {
                        Divider()
                            .padding(.leading, 16)
                        
                        HStack {
                            TextField("Notification Value", text: notificationValueBinding)
                                .onChange(of: notificationValueBinding.wrappedValue) { _, newValue in
                                    if newValue.count > 3 {
                                        notificationValueBinding.wrappedValue = String(newValue.prefix(3))
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
    TabConfigurationView(tabNumber: 1, quantity: 3, tabs: TabsViewModel())
        .padding()
}
