//
//  HomeViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 14/07/21.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var exercisePageIsActive: Bool = false
    @Published var isOpenBecomeMemberRecomendation: Bool = false
}
