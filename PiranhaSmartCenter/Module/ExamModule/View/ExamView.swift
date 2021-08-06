//
//  ExamView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct ExamView: View {
    private let bounds = UIScreen.main.bounds
    
    @StateObject var examViewModel = ExamViewModel()
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    init(runScript: @escaping () -> Void = {}) {
        runScript()
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: OnBoardExamView().environmentObject(examViewModel), isActive: $examViewModel.isOpenOnBoard) {
                EmptyView()
            }
            NavigationLink(destination: HistoryExamView(), isActive: $examViewModel.isOpenHistory) {
                EmptyView()
            }
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    Spacer()
                    Text(ExamString.title)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.bottom, -8)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Text(ExamString.subtitle)
                        .padding(.horizontal)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image("ExamImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: bounds.size.width / 1.3 - 32)
                        .padding(.horizontal)
                    Spacer()
                    Text(ExamString.readyQuestion)
                        .padding(.horizontal)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    HStack {
                        ButtonComponentView.primaryButton(title: ExamString.ready, action: {
                            if rootViewModel.dataUser?.statusAccount == "verified" {
                                // Open exam main page
                                examViewModel.isOpenOnBoard = true
                            } else {
                                examViewModel.isOpenBecomeMemberRecomendation = true
                            }
                        })
                        ButtonComponentView.secondaryButton(title: ExamString.seeHistory, action: {
                            if rootViewModel.dataUser?.statusAccount == "verified" {
                                // Open exam history page
                                examViewModel.isOpenHistory = true
                            } else {
                                examViewModel.isOpenBecomeMemberRecomendation = true
                            }
                        })
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                }
                .frame(minWidth: bounds.size.width, minHeight: bounds.size.height - bounds.size.height / 8 - 32, alignment: .center)
            }
        }
        .sheet(isPresented: $examViewModel.isOpenBecomeMemberRecomendation) {
            NotActivatedAccount(
                title: ExamString.premiumMemberAlertTitle,
                subtitle: ExamString.premiumMemberAlertSubitle,
                desc: ExamString.premiumMemberAlertDesc
            )
        }
    }
}

#if DEBUG
struct ExamView_Previews: PreviewProvider {
    static var previews: some View {
        ExamView().previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
#endif
