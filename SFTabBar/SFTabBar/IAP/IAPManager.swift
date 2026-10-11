//
//  IAPManager.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/9/20.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // App-wide navigation-title colour. SwiftUI has no per-view API for the
        // navigation title colour, so it is set through the appearance proxy --
        // once here at launch, before any bar is created, rather than in a view
        // initialiser that re-runs on every ContentView init. Only the title
        // text colour is set; the bar keeps its default (blurred) background,
        // which the compact iPhone layout relies on to hide content that
        // scrolls past the pinned canvas.
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.systemPink]

        // IAP configuration removed - no longer using RevenueCat
        return true
    }
}

public class TipManager: ObservableObject {
    
    enum State {
        case inactive
        case inProgress
        case success
    }
    
    public enum Tip: CaseIterable {
        case large
        case small
        
        var identifier: String {
            switch self {
            case .large:
                return "com.tapteachapps.SFTabBar.largeTip"
            case .small:
                return "com.tapteachapps.SFTabBar.smallTip"
            }
        }
    }
    
    @Published var state: State = .inactive
    @Published var alertStatus = false
    
    init() {
        // IAP functionality removed - no longer using RevenueCat
    }

    public func PurchaseTip(tip: Tip) {
        // IAP functionality removed - no longer using RevenueCat
        // This method is kept for interface compatibility but doesn't perform purchases
        self.state = .inactive
    }
    
    public func price(for tip: Tip) -> String {
        // IAP functionality removed - no longer using RevenueCat
        return "IAP Disabled"
    }
}

