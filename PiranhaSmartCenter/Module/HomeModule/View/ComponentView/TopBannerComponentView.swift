//
//  TopBannerComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct TopBannerComponentView: View {
    private let bounds = UIScreen.main.bounds
    
    let actionCourse: () -> Void
    let actionExercise: () -> Void
    let actionExam: () -> Void
    let isLoading: Bool
    
    init(actionCourse: @escaping () -> Void, actionExercise: @escaping () -> Void, actionExam: @escaping () -> Void, isLoading: Bool) {
        self.actionCourse = actionCourse
        self.actionExercise = actionExercise
        self.actionExam = actionExam
        self.isLoading = isLoading
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundLayer1Color")
            VStack(alignment: .leading, spacing: 4) {
                Text(HomeString.menuTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("ForegroundColor"))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .font(.system(size: 18))
                Text(HomeString.submenuTitle)
                    .foregroundColor(Color("ForegroundLayer1Color"))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                HStack(alignment: .center, spacing: 8) {
                    Spacer()
                    ButtonTopBarComponentView(
                        title: HomeString.course,
                        backgroundColorImg: isLoading ? "ForegroundLayer2Color" : "CourseColor",
                        foregroundColorImg: "BackgroundLayer1Color",
                        foregroundColorText: "ForegroundColor",
                        icon: "book",
                        action: {
                            actionCourse()
                        },
                        isLoading: isLoading
                    )
                    Spacer()
                    ButtonTopBarComponentView(
                        title: HomeString.exercise,
                        backgroundColorImg: isLoading ? "ForegroundLayer2Color" : "ExerciseColor",
                        foregroundColorImg: "BackgroundLayer1Color",
                        foregroundColorText: "ForegroundColor",
                        icon: "highlighter",
                        action: {
                            actionExercise()
                        },
                        isLoading: isLoading
                    )
                    Spacer()
                    ButtonTopBarComponentView(
                        title: HomeString.exam,
                        backgroundColorImg: isLoading ? "ForegroundLayer2Color" : "ExamColor",
                        foregroundColorImg: "BackgroundLayer1Color",
                        foregroundColorText: "ForegroundColor",
                        icon: "doc",
                        action: {
                            actionExam()
                        },
                        isLoading: isLoading
                    )
                    Spacer()
                }
                .padding(.vertical)
            }
            .padding()
        }
        .cornerRadius(18)
    }
}
