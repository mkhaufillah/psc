//
//  HistoryExerciseCardComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import SwiftUI

struct HistoryExerciseCardComponentView: View {
    private let bounds = UIScreen.main.bounds
    
    let historyExercise: GetResultExerciseModel?
    
    init(historyExercise: GetResultExerciseModel? = nil) {
        self.historyExercise = historyExercise
    }
    
    var body: some View {
        if historyExercise == nil {
            Group {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        } else {
            ZStack {
                // for bugs reason
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }
                // ----
                NavigationLink(
                    destination: ExerciseAnswerView(history: historyExercise!)
                ) {
                    content
                }
                .buttonStyle(DefaultButtonStyleHelper())
                // for bugs reason
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }
                // ----
            }
        }
    }
    
    private var content: some View {
        Group {
            HStack() {
                VStack(alignment: .leading, spacing: 8) {
                    Text(historyExercise?.name ?? ExerciseString.loadHistoryName)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                    Text(historyExercise?.titleExercise ?? ExerciseString.loadTitleExercise)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 8)
                    if historyExercise?.statusExercise == "complete" {
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
                    } else if historyExercise?.statusExercise == "incomplete" {
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
                    Text(ExerciseString.score + (historyExercise?.totalValueExercise ?? ExerciseString.loadTotalValueExercise))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .padding(.top, 8)
                    Text(historyExercise?.createdAt ?? "")
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
