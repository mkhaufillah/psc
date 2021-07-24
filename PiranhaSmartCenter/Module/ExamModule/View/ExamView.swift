//
//  ExamView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 18/07/21.
//

import SwiftUI

struct ExamView: View {
    private let bounds = UIScreen.main.bounds
    
    @EnvironmentObject var rootViewModel: RootViewModel
    
    init(runScript: @escaping () -> Void = {}) {
        runScript()
    }
    
    var body: some View {
        ScrollView {
            Spacer()
            VStack(alignment: .center, spacing: 16) {
                Spacer(minLength: 24)
                Text(ExamString.title)
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.bottom, -8)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Text(ExamString.subtitle)
                    .padding(.horizontal)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Spacer()
                Image("ExamImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: bounds.size.height / 4)
                    .padding(.horizontal)
                Spacer()
                Text(ExamString.readyQuestion)
                    .padding(.horizontal)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                ButtonComponentView.primaryButton(title: ExamString.ready, action: {})
                    .padding(.horizontal)
                Spacer(minLength: 24)
                
            }
            .frame(minWidth: bounds.size.width, minHeight: bounds.size.height - bounds.size.height / 8 - 32, alignment: .center)
            Spacer()
        }
    }
}

#if DEBUG
struct ExamView_Previews: PreviewProvider {
    static var previews: some View {
        ExamView().previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
#endif
