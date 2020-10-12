//
//  SFTabBarApp.swift
//  SFTabBar
//
//  Created by Adam Jones on 9/16/20.
//

import SwiftUI

@main
struct SFTabBarApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
