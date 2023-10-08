//
//  ExerciseView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import SwiftUI

struct ExerciseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var exerciseViewModel = ExerciseViewModel()
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    private let bounds = UIScreen.main.bounds
    
    @GestureState private var dragOffset = CGSize.zero
    
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
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                TextFieldComponentView(commit: {
                                    exerciseViewModel.initDataMaterialsFromNetwork(index: exerciseViewModel.selectedCourseIdx, isSearch: true)
                                }, text: $exerciseViewModel.materialKeyword).primary(title: CourseString.search + " " + ExerciseString.title, icon: "magnifyingglass", position: .right, keyboardType: .default)
                                .padding()
                            }
                            ZStack {
                                Color("BackgroundColor")
                                VStack(alignment: .leading, spacing: 16) {
                                    ScrollView(.horizontal) {
                                        HStack {
                                            if (exerciseViewModel.dataStatusCourses == .InProgressToNetwork) {
                                                ChipComponentView(title: CourseString.loadCourseName, action: {}, isLoading: true, isActive: false)
                                                ChipComponentView(title: CourseString.loadCourseName, action: {}, isLoading: true, isActive: false)
                                            }
                                            if (exerciseViewModel.dataStatusCourses == .NotInLocal) {
                                                ErrorComponentView.simple() {
                                                    exerciseViewModel.initDataCoursesFromNetwork()
                                                }
                                            }
                                            if (exerciseViewModel.dataStatusCourses == .InNetwork) {
                                                ChipComponentView(
                                                    title: ExerciseString.history,
                                                    action: {
                                                        exerciseViewModel.onboardingPageIsActive = nil
                                                        exerciseViewModel.selectedCourseIdx = 99
                                                        // get history data
                                                        if exerciseViewModel.dataStatusHistories != .InNetwork && exerciseViewModel.dataStatusHistories != .InProgressToNetwork {
                                                            exerciseViewModel.initDataHistoriesFromNetwork()
                                                        }
                                                    },
                                                    isActive: exerciseViewModel.selectedCourseIdx == 99
                                                )
                                                courses
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                    }
                                    .padding(.horizontal, -16)
                                    if exerciseViewModel.selectedCourseIdx != 99 {
                                        if (exerciseViewModel.dataStatusCourses == .InProgressToNetwork) {
                                            MaterialCardComponentView(isExercise: true)
                                        }
                                        if (exerciseViewModel.dataStatusCourses == .NotInLocal) {
                                            ErrorComponentView.simple() {
                                                exerciseViewModel.initDataCoursesFromNetwork()
                                            }
                                        }
                                        if (exerciseViewModel.dataStatusCourses == .InNetwork) {
                                            materials
                                        }
                                    } else {
                                        if (exerciseViewModel.dataStatusHistories == .InProgressToNetwork) {
                                            HistoryExerciseCardComponentView()
                                        }
                                        if (exerciseViewModel.dataStatusHistories == .NotInLocal) {
                                            ErrorComponentView.simple() {
                                                exerciseViewModel.initDataHistoriesFromNetwork()
                                            }
                                        }
                                        if (exerciseViewModel.dataStatusHistories == .InNetwork) {
                                            histories
                                        }
                                    }
                                }
                                .padding()
                            }
                            .cornerRadius(24)
                        }
                        .padding(.bottom, bounds.size.height)
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
        .onAppear {
            if exerciseViewModel.dataStatusCourses != .InNetwork && exerciseViewModel.dataStatusCourses != .InProgressToNetwork {
                exerciseViewModel.initDataCoursesFromNetwork()
            }
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
    
    private var courses: some View {
        ForEach(
            Array(exerciseViewModel.dataCourses.enumerated()),
            id: \.1
        ) { iCourse, course in
            ChipComponentView(
                title: HomeString.brevet + " " + course.name!.uppercased(),
                action: {
                    exerciseViewModel.onboardingPageIsActive = nil
                    withAnimation {
                        exerciseViewModel.selectedCourseIdx = iCourse
                        if exerciseViewModel.dataStatusMaterials[iCourse] != .InNetwork && exerciseViewModel.dataStatusMaterials[iCourse] != .InProgressToNetwork {
                            exerciseViewModel.initDataMaterialsFromNetwork(index: iCourse)
                        }
                    }
                },
                isActive: exerciseViewModel.selectedCourseIdx == iCourse
            )
        }
    }
    
    private var materials: some View {
        ForEach(
            Array(exerciseViewModel.dataCourses.enumerated()),
            id: \.1
        ) { iCourse, course in
            if exerciseViewModel.selectedCourseIdx == iCourse {
                if exerciseViewModel.dataStatusMaterials[iCourse] == .InNetwork {
                    VStack(spacing: 16) {
                        if exerciseViewModel.dataMaterials[iCourse].count <= 0 {
                            Divider()
                                .padding(.top)
                                .padding(.bottom, 8)
                            Text(ErrorString.notFoundData)
                            Divider()
                                .padding(.top, 8)
                                .padding(.bottom)
                        }
                        ForEach(
                            Array(exerciseViewModel.dataMaterials[iCourse].enumerated()),
                            id: \.1
                        ) { iMaterial, material in
                            MaterialCardComponentView(
                                url: material.picture,
                                name: material.name,
                                chapterCount: "\(material.chapterShorts.count)",
                                material: material,
                                isExercise: true
                            )
                            .environmentObject(exerciseViewModel)
                        }
                        if !exerciseViewModel.isFinalPage[iCourse] && exerciseViewModel.dataMaterials[iCourse].count > 0 {
                            Divider()
                                .padding(.top)
                                .padding(.bottom, 8)
                            if exerciseViewModel.dataStatusMaterialsPerPage[iCourse] == .InProgressToNetwork {
                                ProgressView()
                            } else {
                                Button(action: {
                                    exerciseViewModel.initDataMaterialsFromNetwork(index: iCourse, isNextPage: true)
                                }) {
                                    HStack {
                                        Text(CourseString.loadNextPage + "\(exerciseViewModel.coursePage[iCourse])")
                                        Image(systemName: "chevron.down")
                                    }
                                }
                            }
                        }
                    }
                } else {
                    MaterialCardComponentView(isExercise: true)
                }
            }
        }
    }
    
    private var histories: some View {
        Group {
            ForEach(
                exerciseViewModel.dataHistories,
                id: \.id
            ) { history in
                HistoryExerciseCardComponentView(historyExercise: history)
            }
            if !exerciseViewModel.isHistoryFinalPage && exerciseViewModel.dataHistories.count > 0 {
                Divider()
                    .padding(.top)
                    .padding(.bottom, 8)
                if exerciseViewModel.dataStatusHistoriesPerPage == .InProgressToNetwork {
                    ProgressView().frame(minWidth: 0, maxWidth: .infinity)
                } else {
                    Button(action: {
                        exerciseViewModel.initDataHistoriesFromNetwork(isNextPage: true)
                    }) {
                        HStack {
                            Text(CourseString.loadNextPage + "\(exerciseViewModel.historyPage)")
                            Image(systemName: "chevron.down")
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView().previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
#endif
