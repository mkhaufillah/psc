//
//  ExerciseAnswerView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import SwiftUI

struct ExerciseAnswerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var excerciseAnswerViewModel = ExcerciseAnswerViewModel()
    
    private let bounds = UIScreen.main.bounds
    
    let history: GetResultExerciseModel
    
    init(history: GetResultExerciseModel) {
        self.history = history
    }
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
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
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text(ExerciseString.answerTitle)
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(DefaultButtonStyleHelper())
                .padding()
                ScrollView {
                    VStack(alignment: .center, spacing: 16) {
                        if (excerciseAnswerViewModel.dataStatusAnswer == .InProgressToNetwork) {
                            ProgressView()
                                .frame(minWidth: 0, maxWidth: .infinity)
                        } else if (excerciseAnswerViewModel.dataStatusAnswer == .NotInLocal) {
                            ErrorComponentView.simple() {
                                excerciseAnswerViewModel.initDataAnswer(idExam: history.id)
                            }
                        } else if (excerciseAnswerViewModel.dataStatusAnswer == .InNetwork) {
                            if excerciseAnswerViewModel.dataAnswer.count <= 0 {
                                Text(ErrorString.notFoundData)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            ForEach(
                                Array(excerciseAnswerViewModel.dataAnswer.enumerated()),
                                id: \.1
                            ) { i, data in
                                VStack(spacing: 16) {
                                    HStack(alignment: .top) {
                                        Text("\(i + 1). ")
                                            .fontWeight(.bold)
                                        VStack(alignment: .leading, spacing: 16) {
                                            Text(data.question ?? "")
                                                .fontWeight(.bold)
                                                .fixedSize(horizontal: false, vertical: true)
                                            HStack(alignment: .top) {
                                                Text("A. ")
                                                HStack(alignment: .center) {
                                                    Text(data.optionA ?? "")
                                                        .fixedSize(horizontal: false, vertical: true)
                                                    if data.answer == data.optionA && data.answer != data.key {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .foregroundColor(Color("ErrorColor"))
                                                    } else if data.key == data.optionA {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(Color("SuccessColor"))
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            HStack(alignment: .top) {
                                                Text("B. ")
                                                HStack(alignment: .center) {
                                                    Text(data.optionB ?? "")
                                                        .fixedSize(horizontal: false, vertical: true)
                                                    if data.key == data.optionB {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(Color("SuccessColor"))
                                                    }
                                                    if data.answer == data.optionB && data.answer != data.key {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .foregroundColor(Color("ErrorColor"))
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            HStack(alignment: .top) {
                                                Text("C. ")
                                                HStack(alignment: .center) {
                                                    Text(data.optionC ?? "")
                                                        .fixedSize(horizontal: false, vertical: true)
                                                    if data.key == data.optionC {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(Color("SuccessColor"))
                                                    }
                                                    if data.answer == data.optionC && data.answer != data.key {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .foregroundColor(Color("ErrorColor"))
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            HStack(alignment: .top) {
                                                Text("D. ")
                                                HStack(alignment: .center) {
                                                    Text(data.optionD ?? "")
                                                        .fixedSize(horizontal: false, vertical: true)
                                                    if data.key == data.optionD {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(Color("SuccessColor"))
                                                    }
                                                    if data.answer == data.optionD && data.answer != data.key {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .foregroundColor(Color("ErrorColor"))
                                                    }
                                                }
                                                Spacer()
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                        }
                                        Spacer()
                                    }
                                    Divider()
                                }
                            }
                        }
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
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            excerciseAnswerViewModel.initDataAnswer(idExam: history.id)
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}
