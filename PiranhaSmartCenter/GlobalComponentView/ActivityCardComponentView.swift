//
//  ActivityCardComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct ActivityCardComponentView: View {
    let name: String?
    let time: String?
    let activity: ActivityModel?
    
    @ObservedObject var imageLoaderProvider: ImageLoaderProvider
    @State var image:UIImage? = nil
    
    init(url: String? = nil, name: String? = nil, time: String? = nil, activity: ActivityModel? = nil) {
        imageLoaderProvider = ImageLoaderProvider(urlString: url ?? "")
        self.name = name
        self.time = time
        self.activity = activity
    }
    
    var body: some View {
        if activity == nil {
            Group {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        } else {
            NavigationLink(destination: ActivityDetailView(activity: activity!, image: $image)) {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        }
    }
    
    private var content: some View {
        Group {
            ZStack {
                Color("ForegroundLayer2Color")
                    .frame(width: 256, height: 132)
                    .cornerRadius(1)
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 256, height: 132)
                    .background(Color("ForegroundLayer2Color"))
                    .cornerRadius(1)
                    .onReceive(imageLoaderProvider.didChange) { data in
                        withAnimation {
                            self.image = UIImage(data: data) ?? UIImage()
                        }
                    }
                    .opacity(image == nil ? 0 : 1)
                    .animation(.easeOut(duration: 0.2), value: image == nil)
                LinearGradient(
                    gradient: Gradient(colors: [Color("OverlayColor"), Color("BackgroundLayer1Color")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 256, height: 132)
                .cornerRadius(1)
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    Text(name ?? HomeString.loadActivityName)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 12)
                        Text(time ?? HomeString.loadActivityTime)
                            .font(.system(size: 12))
                            .lineLimit(1)
                        Spacer()
                    }
                }
                .padding()
            }
        }
        .frame(width: 256)
        .background(Color("BackgroundLayer1Color"))
        .cornerRadius(18)
    }
}
