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
    
    init(url: String? = nil, name: String? = nil, chapterCount: String? = nil, material: MaterialModel? = nil) {
        imageLoaderProvider = ImageLoaderProvider(urlString: url ?? "")
        self.name = name
        self.chapterCount = chapterCount
        self.material = material
    }
    
    var body: some View {
        if material == nil {
            Group {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        } else {
            NavigationLink(
                destination: MaterialDetailView(material: material!, image: $image)
            ) {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
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
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                    Spacer()
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
                Spacer()
            }
            .padding()
        }
        .background(Color("BackgroundLayer1Color"))
        .cornerRadius(18)
    }
}

