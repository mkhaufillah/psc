//
//  ImageProfileComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import SwiftUI

struct ImageProfileComponentView: View {
    @ObservedObject var imageLoaderProvider: ImageLoaderProvider
    @State var image:UIImage? = nil
    
    init(url:String) {
        imageLoaderProvider = ImageLoaderProvider(urlString: url)
    }
    
    var body: some View {
        ZStack {
            Color("OverlayColor")
                .frame(width:128, height:128)
                .cornerRadius(128)
            Image(uiImage: image ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:image == nil ? 0 : 128, height:image == nil ? 0 : 128)
                .background(Color("OverlayColor"))
                .cornerRadius(128)
                .onReceive(imageLoaderProvider.didChange) { data in
                    withAnimation {
                        self.image = UIImage(data: data) ?? UIImage()
                    }
                }
                .animation(.easeOut(duration: 0.2), value: image == nil)
        }
    }
}

