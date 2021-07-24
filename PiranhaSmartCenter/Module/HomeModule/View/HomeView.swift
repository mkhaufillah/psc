//
//  HomeView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 08/07/21.
//

import SwiftUI

struct HomeView: View {
    private let bounds = UIScreen.main.bounds
    
    @ObservedObject var homeViewModel = HomeViewModel()
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    init(runScript: @escaping () -> Void = {}) {
        runScript()
    }
    
    var body: some View {
        RefreshableComponentView(refreshing: $rootViewModel.homeRefresh) {
            if rootViewModel.homeRefresh == false {
                Spacer()
                ZStack {
                    NavigationLink(destination: ExerciseView(), isActive: $homeViewModel.exercisePageIsActive) {
                        EmptyView()
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        shortUserInfo
                        if rootViewModel.statusConnection == 0 {
                            TickerComponentView.error(text: ErrorString.noDataConnection)
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                        }
                        Spacer()
                        topBanner
                        ZStack {
                            Color("BackgroundColor")
                            VStack(alignment: .leading, spacing: 16) {
                                Spacer(minLength: 64)
                                Text(HomeString.courses)
                                    .fontWeight(.bold)
                                if (rootViewModel.dataStatusRecapCourses == .InProgressToNetwork) {
                                    CourseCardComponentView()
                                }
                                if (rootViewModel.dataStatusRecapCourses == .NotInLocal) {
                                    ErrorComponentView.simple() {
                                        rootViewModel.initDataRecapCoursesFromNetwork()
                                    }
                                }
                                if (rootViewModel.dataStatusRecapCourses == .InNetwork) {
                                    courses
                                }
                                HStack {
                                    Text(HomeString.publications)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Button(action: {}) {
                                        Text(HomeString.more)
                                    }
                                }
                                ScrollView(.horizontal) {
                                    HStack {
                                        if (rootViewModel.dataStatusPublications == .InProgressToNetwork) {
                                            PublicationCardComponentView()
                                            PublicationCardComponentView()
                                            PublicationCardComponentView()
                                        }
                                        if (rootViewModel.dataStatusPublications == .NotInLocal) {
                                            ErrorComponentView.simple() {
                                                rootViewModel.initDataPublicationsFromNetwork()
                                            }
                                        }
                                        if (rootViewModel.dataStatusPublications == .InNetwork) {
                                            publications
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                                .padding(.horizontal, -16)
                                HStack {
                                    Text(HomeString.activities)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Button(action: {}) {
                                        Text(HomeString.more)
                                    }
                                }
                                ScrollView(.horizontal) {
                                    HStack {
                                        if (rootViewModel.dataStatusActivities == .InProgressToNetwork) {
                                            ActivityCardComponentView()
                                            ActivityCardComponentView()
                                            ActivityCardComponentView()
                                        }
                                        if (rootViewModel.dataStatusActivities == .NotInLocal) {
                                            ErrorComponentView.simple() {
                                                rootViewModel.initDataActivitiesFromNetwork()
                                            }
                                        }
                                        if (rootViewModel.dataStatusActivities == .InNetwork) {
                                            activities
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                                .padding(.horizontal, -16)
                                .padding(.bottom, 16)
                            }
                            .padding()
                            .padding(.bottom, bounds.size.height)
                        }
                        .cornerRadius(24)
                        .offset(y: -64)
                        .padding(.bottom, -64-bounds.size.height)
                    }
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
    
    private var shortUserInfo: some View {
        ShortUserInfoComponentView(
            url: (rootViewModel.dataUser?.picture ?? "").contains("https://") ? (rootViewModel.dataUser?.picture ?? "") : "",
            name: rootViewModel.dataUser?.name ?? HomeString.loadName
        ) {
            rootViewModel.currentTab = .Profile
        }
        .padding()
    }
    
    private var topBanner: some View {
        TopBannerComponentView(actionCourse: {
            rootViewModel.currentTab = .Course
        }, actionExercise: {
            homeViewModel.exercisePageIsActive = true
        }, actionExam: {
            rootViewModel.currentTab = .Exam
        })
        .padding(.horizontal)
        .zIndex(99)
    }
    
    private var courses: some View {
        ForEach(
            Array(rootViewModel.dataRecapCourses.enumerated()),
            id: \.1
        ) { iRecapCourse, recapCourse in
            CourseCardComponentView(
                name: HomeString.brevet + " " + recapCourse.courseName!.uppercased(),
                materialCount: recapCourse.totalMaterial,
                chapterCount: recapCourse.totalChapter,
                videoCount: recapCourse.totalVideo,
                alphabet: recapCourse.courseName?.first?.uppercased()
            ) {
                rootViewModel.currentTab = .Course
                rootViewModel.selectedCourseIdx = iRecapCourse
                if rootViewModel.dataStatusCourses == .InNetwork && rootViewModel.dataStatusMaterials[iRecapCourse] != .InNetwork && rootViewModel.dataStatusMaterials[iRecapCourse] != .InProgressToNetwork {
                    rootViewModel.initDataMaterialsFromNetwork(index: iRecapCourse)
                }
            }
        }
    }
    
    private var publications: some View {
        ForEach(
            rootViewModel.dataPublications,
            id: \.id
        ) { publication in
            PublicationCardComponentView(
                url: publication.photo,
                name: publication.title,
                time: DateHelper.stringToRelativeDate(s: publication.date ?? "", format: "yyyy-MM-dd"),
                publication: publication
            )
        }
    }
    
    private var activities: some View {
        ForEach(
            rootViewModel.dataActivities,
            id: \.id
        ) { activity in
            ActivityCardComponentView(
                url: activity.photo,
                name: activity.name,
                time: DateHelper.stringToRelativeDate(s: activity.dateEvent ?? "", format: "yyyy-MM-dd"),
                activity: activity
            )
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
#endif
