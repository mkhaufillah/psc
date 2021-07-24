//
//  MainTabView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 09/07/21.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var rootViewModel = RootViewModel()
    
    var body: some View {
        if rootViewModel.dataUser == nil {
            SignInView().environmentObject(rootViewModel)
        } else {
            NavigationView {
                ZStack {
                    NavigationLink(destination: BecomeMemberView(), isActive: $rootViewModel.becomeMemberPageIsActive) {
                        EmptyView()
                    }
                    if rootViewModel.currentTab != .Exam {
                        LinearGradient(gradient: Gradient(colors: [Color("BackgroundAccentColor"), Color("BackgroundAccent2Color")]), startPoint: .leading, endPoint: .trailing)
                            .ignoresSafeArea()
                    }
                    GeometryReader { geometry in
                        VStack(spacing: 0) {
                            Color("TransparentColor")
                                .frame(
                                    width: geometry.size.width,
                                    height: 1,
                                    alignment: .center
                                )
                            switch rootViewModel.currentTab {
                            case .Home:
                                HomeView() {
                                    if rootViewModel.dataStatusUser != .InNetwork && rootViewModel.dataStatusUser != .InProgressToNetwork {
                                        rootViewModel.initDataUserFromNetwork()
                                    }
                                    if rootViewModel.dataStatusRecapCourses != .InNetwork && rootViewModel.dataStatusRecapCourses != .InProgressToNetwork {
                                        rootViewModel.initDataRecapCoursesFromNetwork()
                                    }
                                    if rootViewModel.dataStatusActivities != .InNetwork && rootViewModel.dataStatusActivities != .InProgressToNetwork {
                                        rootViewModel.initDataActivitiesFromNetwork()
                                    }
                                    if rootViewModel.dataStatusPublications != .InNetwork && rootViewModel.dataStatusPublications != .InProgressToNetwork {
                                        rootViewModel.initDataPublicationsFromNetwork()
                                    }
                                }
                            case .Course:
                                CourseView() {
                                    if rootViewModel.dataStatusCourses != .InNetwork && rootViewModel.dataStatusCourses != .InProgressToNetwork {
                                        rootViewModel.initDataCoursesFromNetwork()
                                    }
                                }
                            case .Exam:
                                ExamView() {
                                }
                            case .Profile:
                                ProfileView() {
                                    if rootViewModel.dataStatusUser != .InNetwork && rootViewModel.dataStatusUser != .InProgressToNetwork {
                                        rootViewModel.initDataUserFromNetwork()
                                    }
                                }
                            }
                            ZStack {
                                if rootViewModel.isShowPopupMenu {
                                    PopupMenuComponentView(widthAndHeight: geometry.size.width/7)
                                        .offset(y: -geometry.size.height/6)
                                }
                                HStack {
                                    TabBarIconComponentView(
                                        width: geometry.size.width/5,
                                        height: geometry.size.height/28,
                                        systemIconNameActive: "house.fill",
                                        systemIconNameInactive: "house",
                                        tabName: RootString.home,
                                        assignedPage: .Home
                                    )
                                    TabBarIconComponentView(
                                        width: geometry.size.width/5,
                                        height: geometry.size.height/28,
                                        systemIconNameActive: "book.fill",
                                        systemIconNameInactive: "book",
                                        tabName: RootString.course,
                                        assignedPage: .Course
                                    )
                                    Button(action: {
                                        withAnimation {
                                            rootViewModel.isShowPopupMenu.toggle()
                                        }
                                    }) {
                                        ZStack(alignment: .center) {
                                            Circle()
                                                .foregroundColor(
                                                    rootViewModel.isShowPopupMenu ?
                                                        Color("ForegroundColor")
                                                        :Color("ForegroundLayer1Color")
                                                )
                                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                                .shadow(radius: 4)
                                            Image(systemName: "command.circle.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(
                                                    width: geometry.size.width/7-6 < 0 ? 0 : geometry.size.width/7-6,
                                                    height: geometry.size.width/7-6 < 0 ? 0 : geometry.size.width/7-6
                                                )
                                                .foregroundColor(Color("BackgroundLayer1Color"))
                                                .rotationEffect(Angle(degrees: rootViewModel.isShowPopupMenu ? 90 : 0))
                                        }
                                    }
                                    .buttonStyle(DefaultButtonStyleHelper())
                                    .offset(y: rootViewModel.isShowPopupMenu ? -geometry.size.height/8/2.5 : -geometry.size.height/8/3)
                                    TabBarIconComponentView(
                                        width: geometry.size.width/5,
                                        height: geometry.size.height/28,
                                        systemIconNameActive: "doc.fill",
                                        systemIconNameInactive: "doc",
                                        tabName: RootString.exam,
                                        assignedPage: .Exam
                                    )
                                    TabBarIconComponentView(
                                        width: geometry.size.width/5,
                                        height: geometry.size.height/28,
                                        systemIconNameActive: "person.fill",
                                        systemIconNameInactive: "person",
                                        tabName: RootString.profile,
                                        assignedPage: .Profile
                                    )
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height/8)
                                .background(Color("BackgroundLayer1Color").shadow(radius: 2))
                            }
                        }
                        .edgesIgnoringSafeArea(.bottom)
                        .environmentObject(rootViewModel)
                    }
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .background(Color("BackgroundColor"))
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
#endif

// Global extension

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
