//
//  VideoView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 25/07/21.
//

import SwiftUI
import AVKit
import RealmSwift

struct VideoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Namespace var bottomID
    
    let video: ShortVideoModel
    
    private let bounds = UIScreen.main.bounds
    
    @EnvironmentObject var materialViewModel: MaterialViewModel
    
    @StateObject var videoViewModel = VideoViewModel()
    
    @GestureState private var dragOffset = CGSize.zero
    
    init(video: ShortVideoModel) {
        self.video = video
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if UIDevice.current.orientation.isLandscape {
                Color.black.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    ZStack{
                        VideoPlayer(player: $materialViewModel.player)
                        if videoViewModel.showcontrols {
                            Controls(player: $materialViewModel.player, isPlaying: $videoViewModel.isPlaying, pannel: $videoViewModel.showcontrols,value: $videoViewModel.value, resolution: $materialViewModel.playerRes, video: video)
                        }
                    }
                    .frame(width: bounds.size.width, height: bounds.size.height)
                    .onTapGesture {
                        videoViewModel.showcontrols = true
                    }
                }
                .onAppear {
                    materialViewModel.player!.play()
                    videoViewModel.isPlaying = true
                }
            } else {
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
                            Text(VideoString.title)
                                .fontWeight(.bold)
                        }
                    }
                    .buttonStyle(DefaultButtonStyleHelper())
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack{
                            VideoPlayer(player: $materialViewModel.player)
                            if videoViewModel.showcontrols {
                                Controls(player: $materialViewModel.player, isPlaying: $videoViewModel.isPlaying, pannel: $videoViewModel.showcontrols,value: $videoViewModel.value, resolution: $materialViewModel.playerRes, video: video)
                            }
                        }
                        .frame(width: bounds.size.width, height: bounds.size.width / 1.7777777778)
                        .onTapGesture {
                            videoViewModel.showcontrols = true
                        }
                        ScrollViewReader { scrollView in
                            ScrollView {
                                VStack(alignment: .leading, spacing: 16) {
                                    if videoViewModel.isReply {
                                        CommentComponentView(comment: videoViewModel.selectedComment!)
                                    } else if videoViewModel.dataStatusComments == .InProgressToNetwork {
                                        ProgressView().padding()
                                    } else if videoViewModel.dataStatusComments == .NotInLocal {
                                        Text(VideoString.errorWhenLoadComments).padding()
                                    } else if videoViewModel.dataStatusUser == .NotInLocal {
                                        Text(VideoString.errorWhenLoadUser).padding()
                                    } else if videoViewModel.dataStatusComments == .InNetwork && videoViewModel.dataStatusUser == .InLocal {
                                        if videoViewModel.dataComments.count > 0 {
                                            // Comments
                                            ForEach(
                                                Array(videoViewModel.dataComments.enumerated()),
                                                id: \.1
                                            ) { iComment, comment in
                                                if videoViewModel.idEditedComment != 0 || videoViewModel.selectedComment != nil {
                                                    if videoViewModel.idEditedComment == comment.id {
                                                        CommentComponentView(video: video, comment: comment)
                                                            .id(bottomID)
                                                            .environmentObject(videoViewModel)
                                                    } else if videoViewModel.selectedComment != nil && videoViewModel.selectedComment!.id == comment.id {
                                                        CommentComponentView(video: video, comment: comment)
                                                            .id(bottomID)
                                                            .environmentObject(videoViewModel)
                                                    } else if videoViewModel.idParentEditedComment == comment.id {
                                                        CommentComponentView(video: video, comment: comment)
                                                            .id(bottomID)
                                                            .environmentObject(videoViewModel)
                                                    } else {
                                                        CommentComponentView(video: video, comment: comment)
                                                            .environmentObject(videoViewModel)
                                                    }
                                                } else {
                                                    if iComment == videoViewModel.dataComments.count - 1 {
                                                        CommentComponentView(video: video, comment: comment)
                                                            .id(bottomID)
                                                            .environmentObject(videoViewModel)
                                                    } else {
                                                        CommentComponentView(video: video, comment: comment)
                                                            .environmentObject(videoViewModel)
                                                    }
                                                }
                                            }
                                            .onAppear {
                                                withAnimation {
                                                    scrollView.scrollTo(bottomID)
                                                }
                                                if videoViewModel.isFirstTime {
                                                    
                                                    let videos = materialViewModel.dataVideos[Int(video.chapterId ?? "0") ?? 0]
                                                    for (i, video) in (videos ?? []).enumerated() {
                                                        if video.id == self.video.id {
                                                            (materialViewModel.dataVideos[Int(video.chapterId ?? "0") ?? 0] ?? [])[i].viewed = "true"
                                                        }
                                                    }
                                                    
                                                    videoViewModel.isFirstTime = false
                                                }
                                            }
                                            // End of comments
                                        } else {
                                            Text(VideoString.noComments)
                                                .padding()
                                                .onAppear {
                                                    if videoViewModel.isFirstTime {
                                                        
                                                        let videos = materialViewModel.dataVideos[Int(video.chapterId ?? "0") ?? 0]
                                                        for (i, video) in (videos ?? []).enumerated() {
                                                            if video.id == self.video.id {
                                                                (materialViewModel.dataVideos[Int(video.chapterId ?? "0") ?? 0] ?? [])[i].viewed = "true"
                                                            }
                                                        }
                                                        
                                                        videoViewModel.isFirstTime = false
                                                    }
                                                }
                                        }
                                    }
                                }
                                .frame(width: bounds.width - 32)
                                .padding()
                            }
                        }
                        Group {
                            TextFieldComponentView(
                                commit: {
                                    if videoViewModel.comment != "" {
                                        if videoViewModel.isEdit {
                                            videoViewModel.updateMyComment(
                                                idComment: videoViewModel.idEditedComment,
                                                idVideo: video.id,
                                                parentId: videoViewModel.parentComment,
                                                callback: {
                                                    videoViewModel.initDataComments(typeVideo: video.videoType ?? "free", idVideo: video.id)
                                                }
                                            )
                                        } else {
                                            videoViewModel.postMyComment(
                                                idVideo: video.id,
                                                parentId: videoViewModel.parentComment,
                                                callback: {
                                                    videoViewModel.initDataComments(typeVideo: video.videoType ?? "free", idVideo: video.id)
                                                }
                                            )
                                        }
                                    }
                                },
                                text: $videoViewModel.comment
                            )
                            .primary(title: videoViewModel.parentComment == "" ? VideoString.giveNewComment : VideoString.replyComment, icon: "text.bubble", position: .right, keyboardType: .default)
                        }
                        .padding()
                    }
                    .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
                    .onAppear {
                        materialViewModel.player!.play()
                        videoViewModel.isPlaying = true
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if video.id != 0 && video.videoType != nil {
                videoViewModel.initDataComments(typeVideo: video.videoType ?? "free", idVideo: video.id)
            }
        }
        .onDisappear {
            materialViewModel.player!.pause()
            materialViewModel.selectedVideo = nil
            materialViewModel.player = nil
            
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

struct Controls : View {
    @Binding var player : AVPlayer?
    @Binding var isPlaying : Bool
    @Binding var pannel : Bool
    @Binding var value : Float
    @Binding var resolution : ResolutionVideo?
    var video: ShortVideoModel
    
    var body : some View{
        VStack{
            Spacer()
            HStack{
                Button(action: {
                    player!.seek(to: CMTime(seconds: getSeconds() - 10, preferredTimescale: 1))
                }) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                .buttonStyle(DefaultButtonStyleHelper())
                Spacer()
                Button(action: {
                    if isPlaying{
                        player!.pause()
                        isPlaying = false
                    }
                    else{
                        player!.play()
                        isPlaying = true
                    }
                    
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                .buttonStyle(DefaultButtonStyleHelper())
                Spacer()
                Button(action: {
                    player!.seek(to: CMTime(seconds: getSeconds() + 10, preferredTimescale: 1))
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                }
                .buttonStyle(DefaultButtonStyleHelper())
            }
            Spacer()
            HStack {
                CustomProgressBar(value: $value, player: $player, isPlaying: $isPlaying)
                Button(action: {
                    player!.pause()
                    isPlaying = false
                    if (resolution == .p360 && video.path480 != nil) {
                        player!.replaceCurrentItem(with: AVPlayerItem(url: URL(string: video.path480!)!))
                        resolution = .p480
                    } else if (resolution == .p360 && video.path != nil) {
                        player!.replaceCurrentItem(with: AVPlayerItem(url: URL(string: video.path!)!))
                        resolution = .p
                    } else if (resolution == .p480 && video.path360 != nil) {
                        player!.replaceCurrentItem(with: AVPlayerItem(url: URL(string: video.path360!)!))
                        resolution = .p360
                    } else if (resolution == .p480 && video.path != nil) {
                        player!.replaceCurrentItem(with: AVPlayerItem(url: URL(string: video.path!)!))
                        resolution = .p
                    } else if (resolution == .p && video.path360 != nil) {
                        player!.replaceCurrentItem(with: AVPlayerItem(url: URL(string: video.path360!)!))
                        resolution = .p360
                    } else if (resolution == .p && video.path480 != nil) {
                        player!.replaceCurrentItem(with: AVPlayerItem(url: URL(string: video.path480!)!))
                        resolution = .p480
                    }
                    player!.play()
                    isPlaying = true
                }){
                    Text(resolution == .p360 ? "360p" : resolution == .p480 ? "480p" : "default")
                        .foregroundColor(.white)
                }
                .buttonStyle(DefaultButtonStyleHelper())
                Button(action: {
                    if UIDevice.current.orientation.isLandscape {
                        DispatchQueue.main.async {
                            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                        }
                    } else {
                        DispatchQueue.main.async {
                            AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
                            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                        }
                    }
                    UINavigationController.attemptRotationToDeviceOrientation()
                }) {
                    Image(systemName: UIDevice.current.orientation.isLandscape ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                        .foregroundColor(.white)
                }
                .buttonStyle(DefaultButtonStyleHelper())
            }
        }.padding()
        .background(Color.black.opacity(0.4))
        .onTapGesture {
            pannel = false
        }
        .onAppear {
            player!.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { (_) in
                value = getSliderValue()
                if value == 1.0{
                    isPlaying = false
                }
            }
        }
    }
    
    func getSliderValue()->Float{
        if player == nil {return 0}
        return Float(player!.currentTime().seconds / (player!.currentItem?.duration.seconds)!)
    }
    
    func getSeconds()->Double{
        if player == nil {return 0}
        return Double(Double(value) * (player!.currentItem?.duration.seconds)!)
    }
}

struct CustomProgressBar : UIViewRepresentable {
    @Binding var value : Float
    @Binding var player : AVPlayer?
    @Binding var isPlaying : Bool
    
    func makeCoordinator() -> CustomProgressBar.Coordinator {
        return CustomProgressBar.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomProgressBar>) -> UISlider {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .gray
        slider.thumbTintColor = .red
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.value = value
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.changed(slider:)), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: UIViewRepresentableContext<CustomProgressBar>) {
        uiView.value = value
    }
    
    class Coordinator : NSObject{
        var parent : CustomProgressBar
        
        init(parent1 : CustomProgressBar) {
            parent = parent1
        }
        
        @objc func changed(slider : UISlider){
            if slider.isTracking {
                parent.player!.pause()
                let sec = Double(slider.value * Float((parent.player!.currentItem?.duration.seconds)!))
                parent.player!.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
            } else {
                let sec = Double(slider.value * Float((parent.player!.currentItem?.duration.seconds)!))
                parent.player!.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
                if parent.isPlaying {
                    parent.player!.play()
                }
            }
        }
    }
}

class Host : UIHostingController<VideoView>{
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

struct VideoPlayer : UIViewControllerRepresentable {
    @Binding var player : AVPlayer?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPlayer>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<VideoPlayer>) {
    }
}
