//
//  PublicationCardComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct PublicationCardComponentView: View {
    private let bounds = UIScreen.main.bounds
    
    let name: String?
    let time: String?
    let publication: PublicationModel?
    
    @ObservedObject var imageLoaderProvider: ImageLoaderProvider
    @State var image:UIImage? = nil
    
    init(url: String? = nil, name: String? = nil, time: String? = nil, publication: PublicationModel? = nil) {
        imageLoaderProvider = ImageLoaderProvider(urlString: url ?? "")
        self.name = name
        self.time = time
        self.publication = publication
    }
    
    var body: some View {
        if publication == nil {
            Group {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        } else {
            NavigationLink(destination: PublicationDetailView(publication: publication!, image: $image)) {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        }
    }
    
    private var content: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    Color("ForegroundLayer2Color")
                        .frame(width: 192, height: 92)
                        .cornerRadius(1)
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 192, height: 92)
                        .cornerRadius(1)
                        .onReceive(imageLoaderProvider.didChange) { data in
                            withAnimation {
                                self.image = UIImage(data: data) ?? UIImage()
                            }
                        }
                        .opacity(image == nil ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: image == nil)
                    Color("OverlayColor")
                        .frame(width: 192, height: 92)
                        .cornerRadius(1)
                }
                .frame(width: 192)
                .background(Color("BackgroundLayer1Color"))
                .cornerRadius(1)
                Text(name ?? HomeString.loadPublicationName)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding(.horizontal)
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 12)
                    Text(time ?? HomeString.loadPublicationTime)
                        .font(.system(size: 12))
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .frame(width: 192)
        .background(Color("BackgroundLayer1Color"))
        .cornerRadius(18)
    }
}
