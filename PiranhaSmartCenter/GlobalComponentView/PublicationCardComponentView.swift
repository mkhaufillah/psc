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
    
    let isForGrid: Bool
    
    @ObservedObject var imageLoaderProvider: ImageLoaderProvider
    @State var image:UIImage? = nil
    
    init(url: String? = nil, name: String? = nil, time: String? = nil, publication: PublicationModel? = nil, isForGrid: Bool = false) {
        imageLoaderProvider = ImageLoaderProvider(urlString: url ?? "")
        self.name = name
        self.time = time
        self.publication = publication
        self.isForGrid = isForGrid
    }
    
    var body: some View {
        if publication == nil {
            Group {
                content
            }
            .buttonStyle(DefaultButtonStyleHelper())
        } else {
            ZStack {
                // for bugs reason
                NavigationLink(destination: EmptyView()) {
                    EmptyView()
                }
                // ----
                NavigationLink(destination: PublicationDetailView(publication: publication!, image: $image)) {
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
    
    private var content: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    Color("ForegroundLayer2Color")
                        .frame(width: isForGrid ? bounds.size.width / 2 - 16 * 2 : 192, height: 92)
                        .cornerRadius(1)
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: isForGrid ? bounds.size.width / 2 - 16 * 2 : 192, height: 92)
                        .cornerRadius(1)
                        .onReceive(imageLoaderProvider.didChange) { data in
                            withAnimation {
                                self.image = UIImage(data: data) ?? UIImage()
                            }
                        }
                        .opacity(image == nil ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: image == nil)
                    Color("OverlayColor")
                        .frame(width: isForGrid ? bounds.size.width / 2 - 16 * 2 : 192, height: 92)
                        .cornerRadius(1)
                }
                .frame(width: isForGrid ? bounds.size.width / 2 - 16 * 2 : 192)
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
        .frame(width: isForGrid ? bounds.size.width / 2 - 16 * 2 : 192)
        .background(Color("BackgroundLayer1Color"))
        .cornerRadius(18)
    }
}
