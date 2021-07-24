//
//  CourseCardComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct CourseCardComponentView: View {
    private let bounds = UIScreen.main.bounds
    
    let name: String?
    let materialCount: String?
    let chapterCount: String?
    let videoCount: String?
    let alphabet: String?
    let action: () -> Void
    
    init(name: String? = nil, materialCount: String? = nil, chapterCount: String? = nil, videoCount: String? = nil, alphabet: String? = nil, action: @escaping () -> Void = {}) {
        self.name = name
        self.materialCount = materialCount
        self.chapterCount = chapterCount
        self.videoCount = videoCount
        self.alphabet = alphabet
        self.action = action
    }
    
    var body: some View {
        if name == nil {
            Group {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        } else {
            Button(action: {
                action()
            }) {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        }
    }
    
    var content: some View {
        Group {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(name ?? HomeString.loadCourseName)
                        .fontWeight(.bold)
                    Text((materialCount ?? HomeString.loadMaterials) + " " + HomeString.materials)
                    HStack {
                        Image(systemName: "folder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                            .lineLimit(1)
                        Text((chapterCount ?? HomeString.loadChapters) + " " + HomeString.chapters)
                            .font(.system(size: 12))
                            .lineLimit(1)
                        Text("|")
                            .font(.system(size: 12))
                            .lineLimit(1)
                        Text((videoCount ?? HomeString.loadVideos) + " " + HomeString.videos)
                            .font(.system(size: 12))
                            .lineLimit(1)
                        Spacer()
                    }
                }
                Spacer()
                ImageAlphabetComponentView(
                    widthHeight: bounds.size.width/8,
                    alphabet: alphabet ?? "-",
                    background: Color("BackgroundAccentColor"),
                    foregroundColor: Color("ForegroundLayer1Color")
                )
            }
            .padding()
        }
        .background(Color("BackgroundLayer1Color"))
        .cornerRadius(18)
    }
}
