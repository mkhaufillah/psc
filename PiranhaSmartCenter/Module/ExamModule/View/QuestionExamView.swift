//
//  QuestionExamView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import SwiftUI

import SwiftUI

struct QuestionExamView: View {
    @EnvironmentObject var examViewModel: ExamViewModel
    
    @StateObject var questionExamViewModel = QuestionExamViewModel()
    
    private let bounds = UIScreen.main.bounds
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("BackgroundAccentColor"), Color("BackgroundAccent2Color")]), startPoint: .leading, endPoint: .trailing)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    Color("TransparentColor")
                        .frame(
                            width: bounds.size.width,
                            height: 1,
                            alignment: .center
                        )
                    HStack {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 18))
                                .padding(.vertical, 8)
                                .padding(.leading)
                            Text("\(questionExamViewModel.indexQuestionShow + 1) / \(questionExamViewModel.dataQuestion.count)")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(.vertical, 8)
                                .padding(.trailing)
                        }
                        .background(Color("BackgroundColor"))
                        .cornerRadius(128)
                        Spacer()
                        HStack {
                            Text("\(questionExamViewModel.timerDisplay)")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(.vertical, 8)
                                .padding(.leading)
                                .onReceive(questionExamViewModel.timer) { input in
                                    let dateTo = DateHelper.stringToDate(
                                        s: questionExamViewModel.dataExam?.lifetimeExam ?? DateHelper.dateToString(d: input, format: "yyyy-MM-dd HH:mm:ss"),
                                        format: "yyyy-MM-dd HH:mm:ss"
                                    )
                                    
                                    let diffComponents = Calendar.current.dateComponents(
                                        [.minute, .second],
                                        from: input,
                                        to: dateTo
                                    )
                                    
                                    let minutes = diffComponents.minute ?? 0
                                    let seconds = diffComponents.second ?? 0
                                    
                                    questionExamViewModel.timerDisplay = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
                                    
                                    if input >= dateTo && questionExamViewModel.dataQuestion.count > 0 {
                                        questionExamViewModel.finish() {
                                            examViewModel.isOpenQuestion = false
                                            examViewModel.isOpenOnBoard = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                examViewModel.isOpenHistory = true
                                            }
                                        }
                                    }
                                }
                            Image(systemName: "stopwatch.fill")
                                .font(.system(size: 18))
                                .padding(.vertical, 8)
                                .padding(.trailing)
                        }
                        .background(Color("BackgroundColor"))
                        .cornerRadius(128)
                    }
                    .padding()
                    ScrollView {
                        VStack(alignment: .center, spacing: 16) {
                            if (questionExamViewModel.dataStatusQuestion == .InProgressToNetwork || questionExamViewModel.dataStatusAnswer == .InProgressToNetwork) {
                                ProgressView()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            } else if (questionExamViewModel.dataStatusQuestion == .NotInLocal) {
                                ErrorComponentView.simple() {
                                    questionExamViewModel.initDataQuestion()
                                }
                            } else if (questionExamViewModel.dataStatusQuestion == .InNetwork) {
                                question
                            }
                        }
                        .padding()
                        .padding(.bottom, bounds.size.height)
                        .frame(width: bounds.size.width)
                    }
                    .background(Color("BackgroundColor"))
                    .cornerRadius(24)
                    .padding(.bottom, -bounds.size.height)
                    VStack {
                        Divider()
                        HStack {
                            ButtonComponentView.secondaryButton(
                                title: ExamString.prev,
                                action: {
                                    questionExamViewModel.indexQuestionShow -= 1
                                    questionExamViewModel.answer = ""
                                },
                                isLoading: questionExamViewModel.dataStatusQuestion == .InProgressToNetwork || questionExamViewModel.dataStatusAnswer == .InProgressToNetwork,
                                isDisabled: questionExamViewModel.indexQuestionShow <= 0 || questionExamViewModel.dataStatusQuestion != .InNetwork || questionExamViewModel.dataStatusAnswer == .InProgressToNetwork,
                                leadingImg: "chevron.backward"
                            )
                            Spacer()
                            ButtonComponentView.primaryButton(
                                title: questionExamViewModel.dataQuestion.count - 1 <= questionExamViewModel.indexQuestionShow ? ExamString.done : ExamString.next,
                                action: {
                                    if questionExamViewModel.dataQuestion.count - 1 <= questionExamViewModel.indexQuestionShow {
                                        // post answer
                                        questionExamViewModel.postDataAnswer() {
                                            questionExamViewModel.finish() {
                                                examViewModel.isOpenQuestion = false
                                                examViewModel.isOpenOnBoard = false
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    examViewModel.isOpenHistory = true
                                                }
                                            }
                                        }
                                    } else {
                                        // post answer
                                        questionExamViewModel.postDataAnswer()
                                    }
                                },
                                isLoading: questionExamViewModel.dataStatusQuestion == .InProgressToNetwork || questionExamViewModel.dataStatusAnswer == .InProgressToNetwork,
                                isDisabled: questionExamViewModel.dataStatusQuestion != .InNetwork || questionExamViewModel.dataStatusAnswer == .InProgressToNetwork,
                                traillingImg: questionExamViewModel.dataQuestion.count - 1 <= questionExamViewModel.indexQuestionShow ? nil : "chevron.forward"
                            )
                        }
                        .padding(8)
                        .padding(.bottom, 32)
                        .padding(.horizontal, 4)
                    }
                    .background(Color("BackgroundColor"))
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            questionExamViewModel.initDataQuestion() {
                examViewModel.isOpenQuestion = false
                examViewModel.isOpenOnBoard = false
            }
        }
    }
    
    var question: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                Text("\(questionExamViewModel.indexQuestionShow + 1). ")
                VStack(alignment: .leading, spacing: 16) {
                    Text(questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].name ?? "")
                        .fixedSize(horizontal: false, vertical: true)
                    Button(action: {
                        questionExamViewModel.answer = questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionA ?? ""
                    }) {
                        HStack(alignment: .top) {
                            Text("A. ")
                            HStack(alignment: .center) {
                                Text(questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionA ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyleHelper(
                        disabled: false,
                        isTransformToPrimary: (
                            questionExamViewModel.answer == "" ?
                                (
                                    questionExamViewModel.dataAnswer[questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].id] == nil ?
                                        
                                        (questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].answer == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionA)
                                        :
                                        (questionExamViewModel.dataAnswer[questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].id] == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionA)
                                )
                                :
                                (
                                    (questionExamViewModel.answer == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionA)
                                )
                        )
                    ))
                    // ============================================================
                    Button(action: {
                        questionExamViewModel.answer = questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionB ?? ""
                    }) {
                        HStack(alignment: .top) {
                            Text("B. ")
                            HStack(alignment: .center) {
                                Text(questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionB ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyleHelper(
                        disabled: false,
                        isTransformToPrimary: (
                            questionExamViewModel.answer == "" ?
                                (
                                    questionExamViewModel.dataAnswer[questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].id] == nil ?
                                        
                                        (questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].answer == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionB)
                                        :
                                        (questionExamViewModel.dataAnswer[questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].id] == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionB)
                                )
                                :
                                (
                                    (questionExamViewModel.answer == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionB)
                                )
                        )
                    ))
                    // ============================================================
                    Button(action: {
                        questionExamViewModel.answer = questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionC ?? ""
                    }) {
                        HStack(alignment: .top) {
                            Text("C. ")
                            HStack(alignment: .center) {
                                Text(questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionC ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyleHelper(
                        disabled: false,
                        isTransformToPrimary: (
                            questionExamViewModel.answer == "" ?
                                (
                                    questionExamViewModel.dataAnswer[questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].id] == nil ?
                                        
                                        (questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].answer == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionC)
                                        :
                                        (questionExamViewModel.dataAnswer[questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].id] == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionC)
                                )
                                :
                                (
                                    (questionExamViewModel.answer == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionC)
                                )
                        )
                    ))
                    // ============================================================
                    Button(action: {
                        questionExamViewModel.answer = questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionD ?? ""
                    }) {
                        HStack(alignment: .top) {
                            Text("D. ")
                            HStack(alignment: .center) {
                                Text(questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionD ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyleHelper(
                        disabled: false,
                        isTransformToPrimary: (
                            questionExamViewModel.answer == "" ?
                                (
                                    questionExamViewModel.dataAnswer[questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].id] == nil ?
                                        
                                        (questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].answer == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionD)
                                        :
                                        (questionExamViewModel.dataAnswer[questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].id] == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionD)
                                )
                                :
                                (
                                    (questionExamViewModel.answer == questionExamViewModel.dataQuestion[questionExamViewModel.indexQuestionShow].optionD)
                                )
                        )
                    ))
                }
                Spacer()
            }
        }
    }
    
}
