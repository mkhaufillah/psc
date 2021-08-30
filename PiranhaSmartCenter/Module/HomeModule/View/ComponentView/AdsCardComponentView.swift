//
//  AdsCardComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 28/08/21.
//

import SwiftUI

struct AdsCardComponentView: View {
    private let bounds = UIScreen.main.bounds
    
    @ObservedObject var imageLoaderProvider: ImageLoaderProvider
    @State var image:UIImage? = nil
    
    @State var height: CGFloat = 0.0
    @State var width: CGFloat = 0.0
    let url: String
    let isCard: Bool
    
    init(url: String? = nil, isCard: Bool = false) {
        imageLoaderProvider = ImageLoaderProvider(urlString: url ?? "")
        self.url = url ?? ""
        self.isCard = isCard
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    Color("ForegroundLayer2Color")
                        .frame(
                            width: width == 0.0 ? bounds.size.width / 1.3 - 32 : width,
                            height: height == 0.0 ? bounds.size.width / 1.3 - 32 : height
                        )
                        .cornerRadius(1)
                    ProgressView()
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: width == 0.0 ? bounds.size.width / 1.3 - 32 : width,
                            height: height == 0.0 ? bounds.size.width / 1.3 - 32 : height
                        )
                        .cornerRadius(1)
                        .onReceive(imageLoaderProvider.didChange) { data in
                            let scaleBase = bounds.size.width / 1.3 - 32
                            withAnimation {
                                self.image = UIImage(data: data) ?? UIImage()
                            }
                            if isCard && self.image != nil {
                                let scaleFactor = scaleBase / (self.image?.size.height ?? 1.0)
                                withAnimation {
                                    self.width = (self.image?.size.width ?? 1.0) * scaleFactor
                                }
                            } else if self.image != nil {
                                let scaleFactor = scaleBase / (self.image?.size.width ?? 1.0)
                                withAnimation {
                                    self.height = (self.image?.size.height ?? 1.0) * scaleFactor
                                }
                            }
                        }
                        .opacity(image == nil ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: image == nil)
                }
                .frame(
                    width: width == 0.0 ? bounds.size.width / 1.3 - 32 : width,
                    height: height == 0.0 ? bounds.size.width / 1.3 - 32 : height
                )
                .background(Color("BackgroundLayer1Color"))
                .cornerRadius(1)
            }
            .frame(
                width: width == 0.0 ? bounds.size.width / 1.3 - 32 : width,
                height: height == 0.0 ? bounds.size.width / 1.3 - 32 : height
            )
            .background(Color("BackgroundLayer1Color"))
            .cornerRadius(18)
        }
        .buttonStyle(DefaultButtonStyleHelper())
        .disabled(url == "")
    }
    
    func action() {
        if let urlString = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let url = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
        }
    }
}

