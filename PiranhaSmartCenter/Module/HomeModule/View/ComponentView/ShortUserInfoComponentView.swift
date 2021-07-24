//
//  ShortUserInfoComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct ShortUserInfoComponentView: View {
    let name: String
    let action: () -> Void
    
    @ObservedObject var imageLoaderProvider: ImageLoaderProvider
    @State var image:UIImage? = nil
    
    init(url:String, name: String, action: @escaping () -> Void) {
        imageLoaderProvider = ImageLoaderProvider(urlString: url)
        self.name = name
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(alignment: .center, spacing: 12) {
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:image == nil ? 0 : 42, height:image == nil ? 0 : 42)
                    .background(Color("OverlayColor"))
                    .cornerRadius(42)
                    .onReceive(imageLoaderProvider.didChange) { data in
                        withAnimation {
                            self.image = UIImage(data: data) ?? UIImage()
                        }
                    }
                    .animation(.easeOut(duration: 0.2), value: image == nil)
                VStack(alignment: .leading, spacing: 3) {
                    Text(HomeString.welcome + ",")
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .font(.system(size: 12))
                    Text(name)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .font(.system(size: 18))
                }
            }
        }
        .buttonStyle(DefaultButtonStyleHelper())
    }
}
