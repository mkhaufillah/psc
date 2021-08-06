//
//  OnBoardExerciseView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 31/07/21.
//

import SwiftUI

struct OnBoardExerciseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var exerciseViewModel: ExerciseViewModel
    
    private let bounds = UIScreen.main.bounds
    
    let material: MaterialModel
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: ExerciseQuestionView(material: material)
                        .environmentObject(exerciseViewModel),
                    isActive: $exerciseViewModel.questionPageIsActive
                ) {
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
                            Text(ExerciseString.title)
                                .fontWeight(.bold)
                        }
                    }
                    .buttonStyle(DefaultButtonStyleHelper())
                    .padding()
                    ScrollView {
                        VStack(alignment: .center, spacing: 16) {
                            Spacer()
                            Text(ExerciseString.titleDesc)
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.bottom, -8)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            Text(ExerciseString.subtitleDesc)
                                .padding(.horizontal)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Image("ExerciseImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: bounds.size.width / 1.3 - 32)
                                .padding(.horizontal)
                            Spacer()
                            Text(ExerciseString.desc)
                                .padding(.horizontal)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            ButtonComponentView.primaryButton(title: ExerciseString.ready, action: {
                                exerciseViewModel.questionPageIsActive = true
                            })
                            .padding(.horizontal)
                            Spacer()
                            
                        }
                        .frame(minWidth: bounds.size.width, minHeight: bounds.size.height - bounds.size.height / 8 - 32, alignment: .center)
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
                if !exerciseViewModel.questionPageIsActive {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }))
    }
}
