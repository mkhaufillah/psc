//
//  CourseCardComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 19/07/21.
//

import SwiftUI

struct MaterialCardComponentView: View {
    private let bounds = UIScreen.main.bounds
    
    let name: String?
    let chapterCount: String?
    let material: MaterialModel?
    
    @ObservedObject var imageLoaderProvider: ImageLoaderProvider
    @State var image:UIImage? = nil
    
    @EnvironmentObject var rootViewModel: RootViewModel
    @EnvironmentObject var exerciseViewModel: ExerciseViewModel
    
    let isExercise: Bool
    
    init(url: String? = nil, name: String? = nil, chapterCount: String? = nil, material: MaterialModel? = nil, isExercise: Bool = false) {
        imageLoaderProvider = ImageLoaderProvider(urlString: url ?? "")
        self.name = name
        self.chapterCount = chapterCount
        self.material = material
        
        self.isExercise = isExercise
    }
    
    var body: some View {
        if material == nil {
            Group {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        } else {
            if isExercise {
                Group {
                    ZStack {
                        // for bugs reason
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        // ----
                        NavigationLink(
                            destination: OnBoardExerciseView(material: material!)
                                .environmentObject(exerciseViewModel),
                            tag: material!.id,
                            selection: $exerciseViewModel.onboardingPageIsActive
                        ) {
                            content
                        }
                        .buttonStyle(DefaultButtonStyleHelper())
                        // for bugs reason
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        // ----
                    }
                }
            } else {
                Group {
                    ZStack {
                        // for bugs reason
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        // ----
                        NavigationLink(
                            destination: MaterialDetailView(material: material!, image: $image)
                                .environmentObject(rootViewModel)
                        ) {
                            content
                        }
                        .buttonStyle(DefaultButtonStyleHelper())
                        // for bugs reason
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                        // ----
                    }
                }
            }
        }
    }
    
    private var content: some View {
        Group {
            HStack(spacing: 16) {
                ZStack {
                    Color("ForegroundLayer2Color")
                        .frame(width: 92, height: 92)
                        .cornerRadius(12)
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 92, height: 92)
                        .cornerRadius(12)
                        .onReceive(imageLoaderProvider.didChange) { data in
                            withAnimation {
                                self.image = UIImage(data: data) ?? UIImage()
                            }
                        }
                        .opacity(image == nil ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: image == nil)
                    Color("OverlayColor")
                        .frame(width: 92, height: 92)
                        .cornerRadius(12)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(name ?? CourseString.loadCourseName)
                        .fontWeight(.bold)
                        .lineLimit(isExercise ? 3 : 2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                    Spacer()
                    if !isExercise {
                        HStack {
                            Image(systemName: "folder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12)
                                .lineLimit(1)
                            Text((chapterCount ?? CourseString.loadChapters) + " " + CourseString.chapters)
                                .font(.system(size: 12))
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.bottom, 8)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .background(Color("BackgroundLayer1Color"))
        .cornerRadius(18)
    }
}
