//
//  BecomeMemberViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import Foundation
import RealmSwift
import StoreKit

class BecomeMemberViewModel: NSObject, ObservableObject {
    @Published var infoPaymentPageIsActive = false
    @Published var uploadEvidencePageIsActive = false
    @Published var confirmationPageIsActive = false
    
    @Published var dataStatusBanks: DataStatus = .Init
    @Published var dataStatusEvidence: DataStatus = .Init
    @Published var dataBanks = [BankModel]()
    
    @Published var isShowSelectionEvidencePicture = false
    @Published var isShowPhotoLibrary = false
    @Published var isShowCamera = false
    @Published var evidencePicture: UIImage? = nil
    
    @Published var selectedBank: BankModel?
    
    let bankProvider = BankProvider()
    let sendInvoiceProvider = SendInvoiceProvider()
    
    /// App store policy
    @Published var isCompletedFetchProduct = false
    @Published var isPrecessingPayment = false
    @Published var isErrorFetch = false
    let allStoreProductIdentifiers = Set([
        "premium_member_psc_001"
    ])
    var productsRequest: SKProductsRequest?
    var fetchedProducts = [SKProduct]()
    var fetchedCompletionHandler: (([SKProduct]) -> Void)?
    var completedPurchased = [String]()
    var purchaseCompletionHandler: ((SKPaymentTransaction?) -> Void)?
    
    override init() {
        super.init()
        
        startObservingPaymentQueue()
        
        fetchProducts { products in
            self.isCompletedFetchProduct = true
        }
    }
    
    func initListBank() {
        dataStatusBanks = .InProgressToNetwork
        bankProvider.doAction(response: { res, err in
            DispatchQueue.main.async {
                if err != nil {
                    NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: err?.desc ?? "")
                    self.dataStatusBanks = .NotInLocal
                }
                if res != nil {
                    self.dataBanks = RealmListHelper<BankModel>().listToArray(list: res?.data?.data ?? List<BankModel>())
                    self.dataStatusBanks = .InNetwork
                }
            }
        })
    }
    
    func sendEvidence(callback: @escaping () ->Void) {
        if selectedBank == nil {
            NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle, subtitle: BecomeMemberString.requiredBank)
            return
        }
        if evidencePicture == nil {
            NotificationComponentView.showErrorNotification(title: ErrorString.shortTitle, subtitle: BecomeMemberString.requiredEvidence)
            return
        }
        
        dataStatusEvidence = .InProgressToNetwork
        sendInvoiceProvider.doAction(
            request: SendInvoiceRequestModel(
                bankId: "\(selectedBank!.id)",
                attachment: (evidencePicture ?? UIImage()).jpegData(compressionQuality: 0.7) ?? Data()
            ),
            response: { res, err in
                DispatchQueue.main.async {
                    if err != nil {
                        NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: err?.desc ?? "")
                        self.dataStatusEvidence = .NotInLocal
                    }
                    if res != nil {
                        NotificationComponentView.showSuccessNotification(title: BecomeMemberString.successTitle, subtitle: BecomeMemberString.success)
                        self.infoPaymentPageIsActive = false
                        self.uploadEvidencePageIsActive = false
                        self.confirmationPageIsActive = false
                        
                        callback()
                        
                        self.dataStatusEvidence = .InNetwork
                    }
                }
            }
        )
    }
    
    /// App store policy
    func inAppPurchase(callback: @escaping () -> Void) {
        // request in-app-purchase
        // callback set status account and pcode in local
        // call endpoind in-app-purchase
        // call callback
        
        if fetchedProducts.count <= 0 {
            NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: ErrorString.cannotLoadProducts)
            return
        }
        
        startObservingPaymentQueue()
        buy(product: fetchedProducts[0]) { paymentTransaction in
            if paymentTransaction?.transactionState == .purchased || paymentTransaction?.transactionState == .restored {
                self.isPrecessingPayment = true
                
                let inAppPurchaseProvider = InAppPurchaseProvider()
                
                let request = InAppPurchaseRequestModel(
                    token: GlobalStaticData.tokenInAppPurchase,
                    status: "success",
                    pcode: paymentTransaction?.transactionIdentifier ?? ""
                )
                
                inAppPurchaseProvider.doAction(request: request) { res, err in
                    DispatchQueue.main.async {
                        if err != nil {
                            NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: err?.desc ?? "")
                        }
                        if res != nil {
                            NotificationComponentView.showSuccessNotification(title: BecomeMemberString.successPurchasing, subtitle: BecomeMemberString.successPurchasingDesc)
                            callback()
                        }
                        self.isPrecessingPayment = false
                    }
                }
            }
        }
    }
    
    func fetchProducts(completion: @escaping ([SKProduct]) -> Void) {
        guard productsRequest == nil else {
            return
        }
        
        fetchedCompletionHandler = completion
        
        productsRequest = SKProductsRequest(productIdentifiers: allStoreProductIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    func buy(product: SKProduct, completion: @escaping (SKPaymentTransaction?) -> Void) {
        purchaseCompletionHandler = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension BecomeMemberViewModel: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var shouldFinishTransaction = false
            switch transaction.transactionState {
            case .purchasing, .deferred:
                break
            case .purchased, .restored:
                completedPurchased.append(transaction.payment.productIdentifier)
                shouldFinishTransaction = true
            case .failed:
                shouldFinishTransaction = true
            @unknown default:
                break
            }
            
            if shouldFinishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
        }
    }
}

extension BecomeMemberViewModel: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProduct = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            DispatchQueue.main.async {
                NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: ErrorString.cannotLoadProducts)
            }
            if !invalidProduct.isEmpty {
                DispatchQueue.main.async {
                    NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: ErrorString.invalidProductsFound)
                }
            }
            productsRequest = nil
            DispatchQueue.main.async {
                self.isErrorFetch = true
            }
            return
        }
        
        // cache
        fetchedProducts = loadedProducts
        
        // notify
        DispatchQueue.main.async {
            self.fetchedCompletionHandler?(loadedProducts)
            
            self.fetchedCompletionHandler = nil
            self.productsRequest = nil
        }
    }
}
