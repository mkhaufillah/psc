//
//  HomeView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 08/07/21.
//

import SwiftUI

struct HomeView: View {
    private let bounds = UIScreen.main.bounds
    
    @StateObject var homeViewModel = HomeViewModel()
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    @Namespace var adsID
    
    init(runScript: @escaping () -> Void = {}) {
        runScript()
    }
    
    var body: some View {
        ZStack {
            ScrollViewReader { scrollView in
                RefreshableComponentView(refreshing: $rootViewModel.homeRefresh) {
                    if rootViewModel.homeRefresh == false {
                        Spacer()
                        ZStack {
                            NavigationLink(destination: ExerciseView().environmentObject(homeViewModel), isActive: $homeViewModel.exercisePageIsActive) {
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
                                        Group {
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
                                        }
                                        Group {
                                            HStack {
                                                Text(HomeString.publications)
                                                    .fontWeight(.bold)
                                                Spacer()
                                                NavigationLink(destination: PublicationListView()) {
                                                    Text(HomeString.more)
                                                }
                                            }
                                            ScrollView(.horizontal) {
                                                HStack(spacing: 8) {
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
                                                NavigationLink(destination: ActivityListView()) {
                                                    Text(HomeString.more)
                                                }
                                            }
                                            ScrollView(.horizontal) {
                                                HStack(spacing: 8) {
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
                                            if homeViewModel.goToAds {
                                                Text("")
                                                    .frame(height: 0)
                                                    .onAppear() {
                                                        withAnimation() {
                                                            scrollView.scrollTo(adsID)
                                                        }
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                            homeViewModel.goToAds = false
                                                        }
                                                    }
                                            }
                                            Text(HomeString.newPromotion)
                                                .fontWeight(.bold)
                                            ScrollView(.horizontal) {
                                                HStack {
                                                    if (rootViewModel.dataStatusAds == .InProgressToNetwork) {
                                                        AdsCardComponentView()
                                                        AdsCardComponentView()
                                                        AdsCardComponentView()
                                                    }
                                                    if (rootViewModel.dataStatusAds == .NotInLocal) {
                                                        ErrorComponentView.simple() {
                                                            rootViewModel.initDataAdsFromNetwork()
                                                        }
                                                    }
                                                    if (rootViewModel.dataStatusAds == .InNetwork) {
                                                        ads
                                                    }
                                                }
                                                .padding(.horizontal, 16)
                                            }
                                            .padding(.horizontal, -16)
                                            .padding(.bottom, 16)
                                        }
                                        Text("")
                                            .frame(height: 0)
                                            .id(adsID)
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
                .sheet(isPresented: $homeViewModel.isOpenBecomeMemberRecomendation) {
                    NotActivatedAccount(
                        title: HomeString.premiumMemberAlertTitle,
                        subtitle: HomeString.premiumMemberAlertSubitle,
                        desc: HomeString.premiumMemberAlertDesc
                    )
                }
                .blur(radius: rootViewModel.statusConnection != 0 && rootViewModel.isOpenAds ? 3 : 0)
            }
            if rootViewModel.statusConnection != 0 && rootViewModel.isOpenAds {
                VStack(alignment: .center) {
                    Spacer()
                    ZStack(alignment: .topTrailing) {
                        AdsCardComponentView(
                            url: rootViewModel.dataStatusAds != .InNetwork &&
                                rootViewModel.dataAds.count <= 0
                                ? nil : rootViewModel.dataAds[0].photo
                        )
                        Button(action: {
                            withAnimation(.easeInOut) {
                                rootViewModel.isOpenAds = false
                            }
                        }) {
                            ZStack() {
                                Color("BackgroundColor")
                                    .frame(width: 39, height: 39)
                                    .cornerRadius(100)
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(rootViewModel.dataStatusAds == .InProgressToNetwork ? Color("ForegroundLayer2Color") : Color("ErrorColor"))
                            }
                        }
                        .buttonStyle(DefaultButtonStyleHelper())
                        .disabled(rootViewModel.dataStatusAds == .InProgressToNetwork)
                        .padding(.top, -16)
                        .padding(.trailing, -16)
                    }
                    .padding(.bottom, 16)
                    .shadow(radius: 24)
                    ButtonComponentView.primaryButton(
                        title: "       " + HomeString.checkPromotion + "       ",
                        action: {
                            withAnimation(.easeInOut) {
                                rootViewModel.isOpenAds = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                homeViewModel.goToAds = true
                            }
                        },
                        isDisabled: rootViewModel.dataStatusAds != .InNetwork &&
                            rootViewModel.dataAds.count <= 0
                    )
                    .shadow(radius: 24)
                    Spacer()
                }
                .frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
                .background(Color("OverlayLayer1Color"))
                .ignoresSafeArea()
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
        TopBannerComponentView(
            actionCourse: {
                rootViewModel.currentTab = .Course
            },
            actionExercise: {
                if rootViewModel.dataUser?.statusAccount == "verified" {
                    homeViewModel.exercisePageIsActive = true
                } else {
                    homeViewModel.isOpenBecomeMemberRecomendation = true
                }
            },
            actionExam: {
                rootViewModel.currentTab = .Exam
            },
            isLoading:
                (
                    rootViewModel.dataStatusUser == .InProgressToNetwork ||
                        rootViewModel.dataStatusRecapCourses == .InProgressToNetwork ||
                        rootViewModel.dataStatusActivities == .InProgressToNetwork ||
                        rootViewModel.dataStatusPublications == .InProgressToNetwork
                )
        )
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
    
    private var ads: some View {
        ForEach(
            rootViewModel.dataAds,
            id: \.id
        ) { ads in
            AdsCardComponentView(
                url: ads.photo,
                isCard: true
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
