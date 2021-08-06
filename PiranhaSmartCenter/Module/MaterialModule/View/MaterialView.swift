//
//  MaterialView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 21/07/21.
//

import SwiftUI
import AVKit

struct MaterialDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let bounds = UIScreen.main.bounds
    
    let material: MaterialModel
    @Binding var image: UIImage?
    
    @StateObject var materialViewModel = MaterialViewModel()
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    @GestureState private var dragOffset = CGSize.zero
    
    init(material: MaterialModel, image: Binding<UIImage?>) {
        self.material = material
        self._image = image
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: VideoView(video: materialViewModel.selectedVideo ?? ShortVideoModel())
                        .environmentObject(materialViewModel)
                        .onAppear(
                            perform: {
                                do {
                                    try AVAudioSession.sharedInstance().setCategory(.playback)
                                } catch {
                                    NotificationComponentView.showErrorNotification(title: ErrorString.title, subtitle: ErrorString.audioSystemError)
                                }
                            }
                        ),
                    isActive: $materialViewModel.videoPageIsActive) {
                    EmptyView()
                }
                Group {
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
                                Text(MaterialString.title)
                                    .fontWeight(.bold)
                            }
                        }
                        .buttonStyle(DefaultButtonStyleHelper())
                        .padding()
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                Text((material.name ?? ""))
                                    .fontWeight(.black)
                                    .padding(.top)
                                    .padding(.horizontal)
                                Image(uiImage: image ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: bounds.size.width - 32)
                                    .background(Color("ForegroundLayer2Color").shadow(radius: 5))
                                    .cornerRadius(12)
                                    .padding()
                                VStack(alignment: .leading, spacing: 16) {
                                    ForEach(
                                        material.chapterShorts,
                                        id: \.id
                                    ) { chapterShort in
                                        if materialViewModel.selectedChapter == chapterShort.id {
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(chapterShort.name ?? "")
                                                    .lineLimit(5)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .padding()
                                                // foreach from list videos show loader if detail chapter still loading
                                                if materialViewModel.dataStatusVideos[chapterShort.id] != .InNetwork {
                                                    ProgressView().frame(minWidth: 0, maxWidth: .infinity).padding()
                                                } else {
                                                    ForEach(
                                                        materialViewModel.dataVideos[chapterShort.id] ?? [ShortVideoModel](),
                                                        id: \.id
                                                    ) { video in
                                                        Button(
                                                            action: {
                                                                if (video.videoType == "premium" && rootViewModel.dataUser?.statusAccount == "verified") || video.videoType == "free" {
                                                                    materialViewModel.selectedVideo = video
                                                                    materialViewModel.player = AVPlayer(url: URL(string: video.path!)!)
                                                                    materialViewModel.videoPageIsActive = true
                                                                } else {
                                                                    materialViewModel.isOpenBecomeMemberRecomendation = true
                                                                }
                                                            }
                                                        ) {
                                                            Group {
                                                                HStack {
                                                                    Text(video.name ?? "")
                                                                        .lineLimit(1)
                                                                    if video.videoType == "free" {
                                                                        VStack {
                                                                            Text(MaterialString.sample)
                                                                                .fontWeight(.bold)
                                                                                .font(.system(size: 12))
                                                                                .lineLimit(1)
                                                                                .padding(.horizontal, 8)
                                                                                .padding(.vertical, 4)
                                                                                .foregroundColor(Color("BackgroundLayer1Color"))
                                                                        }
                                                                        .background(Color.accentColor)
                                                                        .cornerRadius(12)
                                                                    }
                                                                    if video.viewed == "true" {
                                                                        Image(systemName: "checkmark.circle.fill")
                                                                            .foregroundColor(Color.accentColor)
                                                                    }
                                                                    Spacer()
                                                                    Image(systemName: "chevron.forward")
                                                                }
                                                                .padding()
                                                            }
                                                            .background(Color("BackgroundLayer1Color"))
                                                            .foregroundColor(Color("ForegroundColor"))
                                                            .cornerRadius(12)
                                                        }
                                                        .padding()
                                                        .buttonStyle(DefaultButtonStyleHelper())
                                                    }
                                                }
                                            }
                                            .background(materialViewModel.selectedChapter == chapterShort.id ? Color.accentColor : Color("BackgroundLayer1Color"))
                                            .foregroundColor(materialViewModel.selectedChapter == chapterShort.id ? Color("BackgroundLayer1Color") : Color("ForegroundColor"))
                                            .cornerRadius(12)
                                        } else {
                                            Button(action: {
                                                withAnimation {
                                                    if materialViewModel.dataStatusVideos[materialViewModel.selectedChapter] != .InProgressToNetwork {
                                                        materialViewModel.selectedChapter = chapterShort.id
                                                        if materialViewModel.dataStatusVideos[chapterShort.id] != .InNetwork && materialViewModel.dataStatusVideos[chapterShort.id] != .InProgressToNetwork {
                                                            materialViewModel.initDataChapterFromNetwork()
                                                        }
                                                    }
                                                }
                                            }) {
                                                Group {
                                                    HStack {
                                                        Text(chapterShort.name ?? "")
                                                            .lineLimit(1)
                                                        Spacer()
                                                        Image(systemName: materialViewModel.selectedChapter == chapterShort.id ? "chevron.up" : "chevron.down")
                                                    }
                                                    .padding()
                                                }
                                                .background(materialViewModel.selectedChapter == chapterShort.id ? Color.accentColor : Color("BackgroundLayer1Color"))
                                                .foregroundColor(materialViewModel.selectedChapter == chapterShort.id ? Color("BackgroundLayer1Color") : Color("ForegroundColor"))
                                                .cornerRadius(12)
                                            }
                                            .buttonStyle(DefaultButtonStyleHelper())
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                            .padding(.bottom, bounds.size.height)
                        }
                        .background(Color("BackgroundColor"))
                        .cornerRadius(24)
                        .padding(.bottom, -bounds.size.height)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $materialViewModel.isOpenBecomeMemberRecomendation) {
            NotActivatedAccount(
                title: MaterialString.premiumMemberAlertTitle,
                subtitle: MaterialString.premiumMemberAlertSubitle,
                desc: MaterialString.premiumMemberAlertDesc
            )
        }
        .onDisappear {
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}
