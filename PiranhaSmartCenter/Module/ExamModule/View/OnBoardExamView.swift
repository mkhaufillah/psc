//
//  OnBoardExamView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import SwiftUI

struct OnBoardExamView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var examViewModel: ExamViewModel
    
    private let bounds = UIScreen.main.bounds
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: QuestionExamView().environmentObject(examViewModel), isActive: $examViewModel.isOpenQuestion) {
                    EmptyView()
                }
                LinearGradient(gradient: Gradient(colors: [Color("BackgroundAccentColor"), Color("BackgroundAccent2Color")]), startPoint: .leading, endPoint: .trailing)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    Color("TransparentColor")
                        .frame(
                            width: bounds.size.width,
                            height: 1,
                            alignment: .center
                        )
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text(ExamString.titleExam)
                                .fontWeight(.bold)
                        }
                    }
                    .buttonStyle(DefaultButtonStyleHelper())
                    .padding()
                    ScrollView {
                        VStack(alignment: .center, spacing: 16) {
                            Spacer()
                            Group {
                                HStack() {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(ExamString.importantInfo)
                                            .fontWeight(.bold)
                                            .lineLimit(1)
                                            .padding(.top, 8)
                                        HStack(alignment: .top) {
                                            Text("1.")
                                                .fixedSize(horizontal: false, vertical: true)
                                            Text(ExamString.importantInfoDesc1)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .padding(.bottom, 8)
                                        HStack(alignment: .top) {
                                            Text("2.")
                                                .fixedSize(horizontal: false, vertical: true)
                                            Text(ExamString.importantInfoDesc2)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .padding(.bottom, 8)
                                        HStack(alignment: .top) {
                                            Text("3.")
                                                .fixedSize(horizontal: false, vertical: true)
                                            Text(ExamString.importantInfoDesc3)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .padding(.bottom, 8)
                                        HStack(alignment: .top) {
                                            Text("4.")
                                                .fixedSize(horizontal: false, vertical: true)
                                            Text(ExamString.importantInfoDesc4)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .padding(.bottom, 8)
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                            .frame(width: bounds.size.width - 32)
                            .background(Color("BackgroundLayer1Color"))
                            .cornerRadius(18)
                            Spacer()
                            ButtonComponentView.primaryFullButton(title: ExamString.start, action: {
                                examViewModel.isOpenQuestion = true
                            })
                            Spacer()
                        }
                        .padding()
                        .padding(.bottom, bounds.size.height)
                        .frame(width: bounds.size.width)
                    }
                    .background(Color("BackgroundColor"))
                    .cornerRadius(24)
                    .padding(.bottom, -bounds.size.height)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                if !examViewModel.isOpenQuestion {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }))
    }
}
