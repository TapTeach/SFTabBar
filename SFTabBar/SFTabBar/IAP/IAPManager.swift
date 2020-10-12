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
    @Published var largeTip: SKProduct?
    @Published var smallTip: SKProduct?
    
    init() {
        Purchases.shared.products(Tip.allCases.map({ $0.identifier })) { (products) in
            self.largeTip = products.first(where: { $0.productIdentifier == Tip.large.identifier })
            self.smallTip = products.first(where: { $0.productIdentifier == Tip.small.identifier })
        }
    }

    public func PurchaseTip(tip: Tip) {
        guard let product: SKProduct = {
            switch tip {
            case .large:
                return largeTip
            case .small:
                return smallTip
            }
        }() else { return }
        self.state = .inProgress
        Purchases.shared.purchaseProduct(product) { (transaction, purchaserInfo, error, userCancelled) in
            if transaction?.transactionState == .purchased {
                self.state = .success
            } else {
                self.state = .inactive
            }
        }
    }
}

