//
//  ImageAlphabetComponentView.swift.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct ImageAlphabetComponentView: View {
    let widthHeight: CGFloat
    let alphabet: String
    let background: Color
    let foregroundColor: Color
    
    init(widthHeight: CGFloat, alphabet: String, background: Color, foregroundColor: Color) {
        self.widthHeight = widthHeight
        self.alphabet = alphabet
        self.background = background
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(alphabet)
                .fontWeight(.black)
                .font(.system(size: widthHeight))
        }
        .frame(width: widthHeight, height: widthHeight, alignment: .center)
        .padding(widthHeight/2)
        .foregroundColor(foregroundColor)
        .background(background)
        .cornerRadius(12)
    }
}
