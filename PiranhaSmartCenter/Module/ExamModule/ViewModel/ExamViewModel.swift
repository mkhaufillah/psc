//
//  ExamViewModel.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import Foundation

class ExamViewModel: ObservableObject {
    @Published var isOpenBecomeMemberRecomendation: Bool = false
    @Published var isOpenOnBoard: Bool = false
    @Published var isOpenQuestion: Bool = false
    @Published var isOpenHistory: Bool = false
}
