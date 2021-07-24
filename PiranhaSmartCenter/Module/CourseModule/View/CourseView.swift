//
//  CourseView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct CourseView: View {
    private let bounds = UIScreen.main.bounds
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    init(runScript: @escaping () -> Void = {}) {
        runScript()
    }
    
    var body: some View {
        RefreshableComponentView(refreshing: $rootViewModel.courseRefresh) {
            if rootViewModel.courseRefresh == false {
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text(CourseString.title)
                        .fontWeight(.black)
                        .padding()
                    Spacer()
                    HStack {
                        TextFieldComponentView(commit: {
                            rootViewModel.initDataMaterialsFromNetwork(index: rootViewModel.selectedCourseIdx, isSearch: true)
                        }, text: $rootViewModel.materialKeyword).primary(title: CourseString.search, icon: "magnifyingglass", position: .right, keyboardType: .default)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    ZStack {
                        Color("BackgroundColor")
                        VStack(alignment: .leading, spacing: 16) {
                            Text(CourseString.category)
                                .fontWeight(.bold)
                            ScrollView(.horizontal) {
                                HStack {
                                    if (rootViewModel.dataStatusCourses == .InProgressToNetwork) {
                                        ChipComponentView(title: CourseString.loadCourseName, action: {}, isLoading: true, isActive: false)
                                        ChipComponentView(title: CourseString.loadCourseName, action: {}, isLoading: true, isActive: false)
                                    }
                                    if (rootViewModel.dataStatusCourses == .NotInLocal) {
                                        ErrorComponentView.simple() {
                                            rootViewModel.initDataCoursesFromNetwork()
                                        }
                                    }
                                    if (rootViewModel.dataStatusCourses == .InNetwork) {
                                        courses
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding(.horizontal, -16)
                            Text(CourseString.materials)
                                .fontWeight(.bold)
                            if (rootViewModel.dataStatusCourses == .InProgressToNetwork) {
                                MaterialCardComponentView()
                            }
                            if (rootViewModel.dataStatusCourses == .NotInLocal) {
                                ErrorComponentView.simple() {
                                    rootViewModel.initDataCoursesFromNetwork()
                                }
                            }
                            if (rootViewModel.dataStatusCourses == .InNetwork) {
                                materials
                            }
                        }
                        .padding()
                        .padding(.bottom, bounds.size.height)
                    }
                    .cornerRadius(24)
                    .padding(.bottom, -bounds.size.height)
                }
                Spacer()
            } else {
                VStack(alignment: .center) {
                    Text(RootString.refreshingData)
                        .fontWeight(.bold)
                }
                .frame(width: bounds.size.width, height: bounds.size.height/2, alignment: .center)
            }
        }
    }
    
    private var courses: some View {
        ForEach(
            Array(rootViewModel.dataCourses.enumerated()),
            id: \.1
        ) { iCourse, course in
            ChipComponentView(
                title: HomeString.brevet + " " + course.name!.uppercased(),
                action: {
                    withAnimation {
                        rootViewModel.selectedCourseIdx = iCourse
                        if rootViewModel.dataStatusMaterials[iCourse] != .InNetwork && rootViewModel.dataStatusMaterials[iCourse] != .InProgressToNetwork {
                            rootViewModel.initDataMaterialsFromNetwork(index: iCourse)
                        }
                    }
                },
                isActive: rootViewModel.selectedCourseIdx == iCourse
            )
        }
    }
    
    private var materials: some View {
        ForEach(
            Array(rootViewModel.dataCourses.enumerated()),
            id: \.1
        ) { iCourse, course in
            if rootViewModel.selectedCourseIdx == iCourse {
                if rootViewModel.dataStatusMaterials[iCourse] == .InNetwork {
                    VStack {
                        if rootViewModel.dataMaterials[iCourse].count <= 0 {
                            Divider()
                                .padding(.top)
                                .padding(.bottom, 8)
                            Text("Data tidak ditemukan")
                            Divider()
                                .padding(.top, 8)
                                .padding(.bottom)
                        }
                        ForEach(
                            Array(rootViewModel.dataMaterials[iCourse].enumerated()),
                            id: \.1
                        ) { iMaterial, material in
                            MaterialCardComponentView(
                                url: material.picture,
                                name: material.name,
                                chapterCount: "\(material.chapterShorts.count)",
                                material: material
                            )
                        }
                        if !rootViewModel.isFinalPage[iCourse] && rootViewModel.dataMaterials[iCourse].count > 0 {
                            Divider()
                                .padding(.top)
                                .padding(.bottom, 8)
                            if rootViewModel.dataStatusMaterialsPerPage[iCourse] == .InProgressToNetwork {
                                ProgressView()
                            } else {
                                Button(action: {
                                    rootViewModel.initDataMaterialsFromNetwork(index: iCourse, isNextPage: true)
                                }) {
                                    HStack {
                                        Text(CourseString.loadNextPage + "\(rootViewModel.coursePage[iCourse])")
                                        Image(systemName: "chevron.down")
                                    }
                                }
                            }
                        }
                    }
                } else {
                    MaterialCardComponentView()
                }
            }
        }
    }
}

#if DEBUG
struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView().previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
#endif

