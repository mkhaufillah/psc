//
//  ShimmerComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 19/07/21.
//

import SwiftUI

public struct ShimmerComponentView: View {
    private struct Constants {
        static let duration: Double = 0.9
        static let minOpacity: Double = 0.25
        static let maxOpacity: Double = 1.0
        static let cornerRadius: CGFloat = 2.0
    }
    
    @State private var opacity: Double = Constants.minOpacity
    
    public init() {}
    
    public var body: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(Color.pink)
            .opacity(opacity)
            .transition(.opacity)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: Constants.duration)
                let repeated = baseAnimation.repeatForever(autoreverses: true)
                withAnimation(repeated) {
                    self.opacity = Constants.maxOpacity
                }
            }
    }
}

#if DEBUG
public struct ShimmerComponentView_Previews: PreviewProvider {
    public static var previews: some View {
        VStack {
            ShimmerComponentView()
                .frame(width: 100, height: 100)
            
            ShimmerComponentView()
                .frame(height: 20)
            
            ShimmerComponentView()
                .frame(height: 20)
            
            ShimmerComponentView()
                .frame(height: 100)
            
            ShimmerComponentView()
                .frame(height: 50)
            
            ShimmerComponentView()
                .frame(height: 20)
            
            ShimmerComponentView()
                .frame(height: 100)
            
            ShimmerComponentView()
                .frame(height: 50)
            
            ShimmerComponentView()
                .frame(height: 20)
        }
        .padding()
    }
}
#endif
