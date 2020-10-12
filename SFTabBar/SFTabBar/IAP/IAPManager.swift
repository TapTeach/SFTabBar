//
//  IAPManager.swift
//  SFTabBar
//
//  Created by Adam Jones on 10/9/20.
//

import Purchases

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "GnoYhAKVaDHJUPWVgSzYIWXYPfRIfiFj")
        return true
    }
}


public class TipManager: ObservableObject {
    
    enum State {
        case inactive
        case inProgress
        case success
    }
    
    @Published var state: State = .inactive

    public func PrepTip(skproduct: String) {
        state = .inProgress
        Purchases.shared.products([skproduct]) { (products) in
            guard let tipProduct = products.first else {
                self.state = .inactive
                return
            }
            self.PurchaseTip(skproduct: tipProduct)
        }
    }

    public func PurchaseTip(skproduct: SKProduct) {
        Purchases.shared.purchaseProduct(skproduct) { (transaction, purchaserInfo, error, userCancelled) in
            if transaction?.transactionState == .purchased {
                self.state = .success
            } else {
                self.state = .inactive
            }
        }
    }
}

