//
//  BecomeMemberViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import Foundation
import RealmSwift

class BecomeMemberViewModel: ObservableObject {
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
}
