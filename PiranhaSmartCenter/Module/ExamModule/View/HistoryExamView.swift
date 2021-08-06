//
//  HistoryExamView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import SwiftUI

struct HistoryExamView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var historyExamViewModel = HistoryExamViewModel()
    
    private let bounds = UIScreen.main.bounds
    
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
                        Text(ExamString.titleHistory)
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(DefaultButtonStyleHelper())
                .padding()
                ScrollView {
                    VStack(alignment: .center, spacing: 16) {
                        if (historyExamViewModel.dataStatusHistories == .InProgressToNetwork) {
                            ProgressView()
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                        if (historyExamViewModel.dataStatusHistories == .NotInLocal) {
                            ErrorComponentView.simple() {
                                historyExamViewModel.initDataHistoriesFromNetwork()
                            }
                        }
                        if (historyExamViewModel.dataStatusHistories == .InNetwork) {
                            ForEach(
                                historyExamViewModel.dataHistories,
                                id: \.id
                            ) { history in
                                Group {
                                    HStack() {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(history.name ?? ExerciseString.loadHistoryName)
                                                .fontWeight(.bold)
                                                .lineLimit(2)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .padding(.top, 8)
                                                .padding(.bottom, 8)
                                            if history.statusExamMultiple == "complete" {
                                                VStack {
                                                    Text(ExerciseString.complete)
                                                        .fontWeight(.bold)
                                                        .lineLimit(1)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .foregroundColor(Color("BackgroundLayer1Color"))
                                                }
                                                .background(Color("SuccessColor"))
                                                .cornerRadius(12)
                                            } else if history.statusExamMultiple == "incomplete" {
                                                VStack {
                                                    Text(ExerciseString.incomplete)
                                                        .fontWeight(.bold)
                                                        .lineLimit(1)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .foregroundColor(Color("BackgroundLayer1Color"))
                                                }
                                                .background(Color("ErrorColor"))
                                                .cornerRadius(12)
                                            } else {
                                                VStack {
                                                    Text(ExerciseString.loadStatusExercise)
                                                        .fontWeight(.bold)
                                                        .lineLimit(1)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .foregroundColor(Color("BackgroundLayer1Color"))
                                                }
                                                .background(Color("ForegroundLayer2Color"))
                                                .cornerRadius(12)
                                            }
                                            Text(ExerciseString.score + (history.totalValueExam ?? ExerciseString.loadTotalValueExercise))
                                                .fontWeight(.bold)
                                                .lineLimit(1)
                                                .padding(.top, 8)
                                            Text(DateHelper.stringToRelativeDate(s: history.createdAt ?? "", format: "dd/MM/yyyy HH:mm"))
                                                .lineLimit(1)
                                                .padding(.top, 8)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                }
                                .frame(width: bounds.size.width - 32)
                                .background(Color("BackgroundLayer1Color"))
                                .cornerRadius(18)
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
            historyExamViewModel.initDataHistoriesFromNetwork()
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}
