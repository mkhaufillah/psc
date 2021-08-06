//
//  ActivityListView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 01/08/21.
//

import SwiftUI

struct ActivityListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let bounds = UIScreen.main.bounds
    
    @StateObject var activityListViewModel = ActivityListViewModel()
    
    var items: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    
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
                        Text(ActivityString.title)
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(DefaultButtonStyleHelper())
                .padding()
                ScrollView {
                    VStack {
                        if (activityListViewModel.dataStatusActivities == .NotInLocal) {
                            ErrorComponentView.simple() {
                                activityListViewModel.initDataActivitiesFromNetwork()
                            }
                        } else {
                            LazyVGrid(columns: items, spacing: 16) {
                                if (activityListViewModel.dataStatusActivities == .InProgressToNetwork) {
                                    ActivityCardComponentView(isForGrid: true)
                                    ActivityCardComponentView(isForGrid: true)
                                    ActivityCardComponentView(isForGrid: true)
                                    ActivityCardComponentView(isForGrid: true)
                                }
                                if (activityListViewModel.dataStatusActivities == .InNetwork) {
                                    ForEach(
                                        activityListViewModel.dataActivities,
                                        id: \.id
                                    ) { activity in
                                        ActivityCardComponentView(url: activity.photo, name: activity.name, time: activity.dateEvent, activity: activity, isForGrid: true)
                                    }
                                }
                            }
                        }
                        if (activityListViewModel.dataStatusActivities == .InNetwork) {
                            if !activityListViewModel.isActivityFinalPage && activityListViewModel.dataActivities.count > 0 {
                                Divider()
                                    .padding(.top)
                                    .padding(.bottom, 8)
                                if activityListViewModel.dataStatusActivitiesPerPage == .InProgressToNetwork {
                                    ProgressView().frame(minWidth: 0, maxWidth: .infinity)
                                } else {
                                    Button(action: {
                                        activityListViewModel.initDataActivitiesFromNetwork(isNextPage: true)
                                    }) {
                                        HStack {
                                            Text(CourseString.loadNextPage + "\(activityListViewModel.activityPage)")
                                            Image(systemName: "chevron.down")
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                    .padding(.bottom, bounds.size.height)
                }
                .background(Color("BackgroundColor"))
                .cornerRadius(24)
                .padding(.bottom, -bounds.size.height)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear {
            if activityListViewModel.dataStatusActivities != .InNetwork && activityListViewModel.dataStatusActivities != .InProgressToNetwork {
                activityListViewModel.initDataActivitiesFromNetwork()
            }
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}
