//
//  ExerciseQuestionView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import SwiftUI

struct ExerciseQuestionView: View {
    @EnvironmentObject var exerciseViewModel: ExerciseViewModel
    
    @StateObject var exerciseQuestionViewModel = ExerciseQuestionViewModel()
    
    private let bounds = UIScreen.main.bounds
    
    let material: MaterialModel
    
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
                            Text("\(exerciseQuestionViewModel.indexQuestionShow + 1) / \(exerciseQuestionViewModel.dataQuestion.count)")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(.vertical, 8)
                                .padding(.trailing)
                        }
                        .background(Color("BackgroundColor"))
                        .cornerRadius(128)
                        Spacer()
                        HStack {
                            Text("\(exerciseQuestionViewModel.timerDisplay)")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(.vertical, 8)
                                .padding(.leading)
                                .onReceive(exerciseQuestionViewModel.timer) { input in
                                    let dateTo = DateHelper.stringToDate(
                                        s: exerciseQuestionViewModel.dataExercise?.lifetimeExercise ?? DateHelper.dateToString(d: input, format: "yyyy-MM-dd HH:mm:ss"),
                                        format: "yyyy-MM-dd HH:mm:ss"
                                    )
                                    
                                    let diffComponents = Calendar.current.dateComponents(
                                        [.minute, .second],
                                        from: input,
                                        to: dateTo
                                    )
                                    
                                    let minutes = diffComponents.minute ?? 0
                                    let seconds = diffComponents.second ?? 0
                                    
                                    exerciseQuestionViewModel.timerDisplay = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
                                    
                                    if input >= dateTo && exerciseQuestionViewModel.dataQuestion.count > 0 {
                                        exerciseQuestionViewModel.finish() {
                                            // finish and call this
                                            exerciseViewModel.onboardingPageIsActive = nil
                                            exerciseViewModel.questionPageIsActive = false
                                            exerciseViewModel.selectedCourseIdx = 99
                                            // get latest history data
                                            exerciseViewModel.initDataHistoriesFromNetwork()
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
                            if (exerciseQuestionViewModel.dataStatusQuestion == .InProgressToNetwork || exerciseQuestionViewModel.dataStatusAnswer == .InProgressToNetwork) {
                                ProgressView()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            } else if (exerciseQuestionViewModel.dataStatusQuestion == .NotInLocal) {
                                ErrorComponentView.simple() {
                                    exerciseQuestionViewModel.initDataQuestion(idMaterial: material.id)
                                }
                            } else if (exerciseQuestionViewModel.dataStatusQuestion == .InNetwork) {
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
                                title: ExerciseString.prev,
                                action: {
                                    exerciseQuestionViewModel.indexQuestionShow -= 1
                                    exerciseQuestionViewModel.answer = ""
                                },
                                isLoading: exerciseQuestionViewModel.dataStatusQuestion == .InProgressToNetwork || exerciseQuestionViewModel.dataStatusAnswer == .InProgressToNetwork,
                                isDisabled: exerciseQuestionViewModel.indexQuestionShow <= 0 || exerciseQuestionViewModel.dataStatusQuestion != .InNetwork || exerciseQuestionViewModel.dataStatusAnswer == .InProgressToNetwork,
                                leadingImg: "chevron.backward"
                            )
                            Spacer()
                            ButtonComponentView.primaryButton(
                                title: exerciseQuestionViewModel.dataQuestion.count - 1 <= exerciseQuestionViewModel.indexQuestionShow ? ExerciseString.complete : ExerciseString.next,
                                action: {
                                    if exerciseQuestionViewModel.dataQuestion.count - 1 <= exerciseQuestionViewModel.indexQuestionShow {
                                        // post answer
                                        exerciseQuestionViewModel.postDataAnswer() {
                                            exerciseQuestionViewModel.finish() {
                                                // finish and call this
                                                exerciseViewModel.onboardingPageIsActive = nil
                                                exerciseViewModel.questionPageIsActive = false
                                                exerciseViewModel.selectedCourseIdx = 99
                                                // get latest history data
                                                exerciseViewModel.initDataHistoriesFromNetwork()
                                            }
                                        }
                                    } else {
                                        // post answer
                                        exerciseQuestionViewModel.postDataAnswer()
                                    }
                                },
                                isLoading: exerciseQuestionViewModel.dataStatusQuestion == .InProgressToNetwork || exerciseQuestionViewModel.dataStatusAnswer == .InProgressToNetwork,
                                isDisabled: exerciseQuestionViewModel.dataStatusQuestion != .InNetwork || exerciseQuestionViewModel.dataStatusAnswer == .InProgressToNetwork,
                                traillingImg: exerciseQuestionViewModel.dataQuestion.count - 1 <= exerciseQuestionViewModel.indexQuestionShow ? nil : "chevron.forward"
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
            exerciseQuestionViewModel.initDataQuestion(idMaterial: material.id) {
                exerciseViewModel.onboardingPageIsActive = nil
                exerciseViewModel.questionPageIsActive = false
            }
        }
    }
    
    var question: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                Text("\(exerciseQuestionViewModel.indexQuestionShow + 1). ")
                VStack(alignment: .leading, spacing: 16) {
                    Text(exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].name ?? "")
                        .fixedSize(horizontal: false, vertical: true)
                    Button(action: {
                        exerciseQuestionViewModel.answer = exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionA ?? ""
                    }) {
                        HStack(alignment: .top) {
                            Text("A. ")
                            HStack(alignment: .center) {
                                Text(exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionA ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyleHelper(
                        disabled: false,
                        isTransformToPrimary: (
                            exerciseQuestionViewModel.answer == "" ?
                                (
                                    exerciseQuestionViewModel.dataAnswer[exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].id] == nil ?
                                        
                                        (exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].answer == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionA)
                                        :
                                        (exerciseQuestionViewModel.dataAnswer[exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].id] == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionA)
                                )
                                :
                                (
                                    (exerciseQuestionViewModel.answer == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionA)
                                )
                        )
                    ))
                    // ============================================================
                    Button(action: {
                        exerciseQuestionViewModel.answer = exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionB ?? ""
                    }) {
                        HStack(alignment: .top) {
                            Text("B. ")
                            HStack(alignment: .center) {
                                Text(exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionB ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyleHelper(
                        disabled: false,
                        isTransformToPrimary: (
                            exerciseQuestionViewModel.answer == "" ?
                                (
                                    exerciseQuestionViewModel.dataAnswer[exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].id] == nil ?
                                        
                                        (exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].answer == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionB)
                                        :
                                        (exerciseQuestionViewModel.dataAnswer[exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].id] == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionB)
                                )
                                :
                                (
                                    (exerciseQuestionViewModel.answer == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionB)
                                )
                        )
                    ))
                    // ============================================================
                    Button(action: {
                        exerciseQuestionViewModel.answer = exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionC ?? ""
                    }) {
                        HStack(alignment: .top) {
                            Text("C. ")
                            HStack(alignment: .center) {
                                Text(exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionC ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyleHelper(
                        disabled: false,
                        isTransformToPrimary: (
                            exerciseQuestionViewModel.answer == "" ?
                                (
                                    exerciseQuestionViewModel.dataAnswer[exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].id] == nil ?
                                        
                                        (exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].answer == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionC)
                                        :
                                        (exerciseQuestionViewModel.dataAnswer[exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].id] == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionC)
                                )
                                :
                                (
                                    (exerciseQuestionViewModel.answer == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionC)
                                )
                        )
                    ))
                    // ============================================================
                    Button(action: {
                        exerciseQuestionViewModel.answer = exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionD ?? ""
                    }) {
                        HStack(alignment: .top) {
                            Text("D. ")
                            HStack(alignment: .center) {
                                Text(exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionD ?? "")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryButtonStyleHelper(
                        disabled: false,
                        isTransformToPrimary: (
                            exerciseQuestionViewModel.answer == "" ?
                                (
                                    exerciseQuestionViewModel.dataAnswer[exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].id] == nil ?
                                        
                                        (exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].answer == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionD)
                                        :
                                        (exerciseQuestionViewModel.dataAnswer[exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].id] == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionD)
                                )
                                :
                                (
                                    (exerciseQuestionViewModel.answer == exerciseQuestionViewModel.dataQuestion[exerciseQuestionViewModel.indexQuestionShow].optionD)
                                )
                        )
                    ))
                }
                Spacer()
            }
        }
    }
}
