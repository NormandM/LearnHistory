//
//  IAPManager.swift
//  HistoryCards
//
//  Created by Normand Martin on 2020-05-19.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import StoreKit
import SwiftUI
import UIKit
import Combine

class IAPManager: NSObject{
    let purchasePublisher = PassthroughSubject<(String, Bool), Never>()
    var coins = UserDefaults.standard.integer(forKey: "coins")
    var totalRestoredPurchases = 0
    static let shared = IAPManager()
    override init() {
        super.init()
    }
    func returnProductIDs() -> [String]? {
        return ["CoinLearnHistory"]
    }
    func getProductsV5(){
        let productIDs = returnProductIDs()
        let request = SKProductsRequest(productIdentifiers: Set(productIDs!))
        request.delegate = self
        
        request.start()
    }
    
    func getPriceFormatted(for product: SKProduct) -> String? {

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    func startObserving() {

        SKPaymentQueue.default().add(self)
    }
    func stopObserving() {

        SKPaymentQueue.default().remove(self)
    }
    func restorePurchasesV5() {
        totalRestoredPurchases = 0
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if totalRestoredPurchases != 0 {
            purchasePublisher.send(("IAP: Purchases successfull restored!",true))
        } else {
            purchasePublisher.send(("IAP: No purchases to restore!",true))
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if let error = error as? SKError {
            if error.code != .paymentCancelled {
                purchasePublisher.send(("IAP Restore Error: " + error.localizedDescription,false))
            } else {
                purchasePublisher.send(("IAP Error: " + error.localizedDescription,false))
            }
        }
    }
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    func purchaseV5(product: SKProduct) -> Bool {

        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
        return true
    }
}
final class productsDB: ObservableObject, Identifiable {
    static let shared = productsDB()
    var items:[SKProduct] = []
    {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}
extension IAPManager: SKProductsRequestDelegate, SKRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let badProducts = response.invalidProductIdentifiers
        let goodProducts = response.products
        if goodProducts.count > 0 {
            productsDB.shared.items = response.products
            print("bon ",productsDB.shared.items)
        }
        func request(_ request: SKRequest, didFailWithError error: Error) {
            print("didFailWithError ",error)
            purchasePublisher.send(("Purchase request failed ",true))
        }
        
        print("badProducts ",badProducts)
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    coins = UserDefaults.standard.integer(forKey: "coins")
                    coins += 200
                    UserDefaults.standard.set(coins, forKey: "coins")
                    purchasePublisher.send((String(coins),true))
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                    
                default: break
                }}}
    }
}
struct Purchased {
    static let shared = Purchased()
    var isPurchased: Bool?
    private init() { }
}
