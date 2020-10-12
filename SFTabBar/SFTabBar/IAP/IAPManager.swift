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


public class TipManager {
    
    var inProgress = false

    public func PrepTip(skproduct: String) {
        guard !inProgress else { return }
        inProgress = true
        Purchases.shared.products([skproduct]) { (products) in
            guard let tipProduct = products.first else { return }
            print(tipProduct)
            self.PurchaseTip(skproduct: tipProduct)
        }
    }

    public func PurchaseTip(skproduct: SKProduct) {
        Purchases.shared.purchaseProduct(skproduct) { (transaction, purchaserInfo, error, userCancelled) in
            if transaction?.transactionState == .purchased {
                print("Thanks!")
            } else {
                print("Boo")
            }
            self.inProgress = false
        }
    }
}

