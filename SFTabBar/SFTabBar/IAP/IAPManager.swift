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
    let tipProduct = products.first
    print(tipProduct)
    self.PurchaseTip(skproduct: skproduct)
    }
}

public func PurchaseTip(skproduct: String) {
    //purchase here?
    //Purchases.shared.purchaseProduct(skproduct, Purchases.PurchaseCompletedBlock)
    print("Purchase")
    inProgress = false
    }
}

