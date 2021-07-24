//
//  MaterialView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 21/07/21.
//

import SwiftUI

struct MaterialDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let bounds = UIScreen.main.bounds
    
    let material: MaterialModel
    @Binding var image: UIImage?
    
    @State var selectedChapter = ""
    
    init(material: MaterialModel, image: Binding<UIImage?>) {
        self.material = material
        self._image = image
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("BackgroundAccentColor"), Color("BackgroundAccent2Color")]), startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Color("TransparentColor")
                    .frame(
                        width: bounds.size.width,
                        height: 1,
                        alignment: .center
                    )
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text(ActivityString.title)
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(DefaultButtonStyleHelper())
                .padding()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text((material.name ?? ""))
                            .fontWeight(.black)
                            .padding(.top)
                            .padding(.horizontal)
                        Image(uiImage: image ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: bounds.size.width - 32)
                            .background(Color("ForegroundLayer2Color").shadow(radius: 5))
                            .cornerRadius(12)
                            .padding()
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(
                                material.chapterShorts,
                                id: \.id
                            ) { chapterShort in
                                if selectedChapter == chapterShort.name {
                                    // foreach from list videos show loader if detail chapter still loading
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(chapterShort.name ?? "")
                                            .lineLimit(3)
                                            .fixedSize(horizontal: false, vertical: true)
                                        .padding()
                                        Button(action: {
                                            // Goto video
                                        }) {
                                            Group {
                                                HStack {
                                                    Text(chapterShort.name ?? "")
                                                        .lineLimit(1)
                                                    Spacer()
                                                    Image(systemName: "chevron.forward")
                                                }
                                                .padding()
                                            }
                                            .background(Color("BackgroundLayer1Color"))
                                            .foregroundColor(Color("ForegroundColor"))
                                            .cornerRadius(12)
                                        }
                                        .padding()
                                        .buttonStyle(DefaultButtonStyleHelper())
                                    }
                                    .background(selectedChapter == chapterShort.name ? Color.accentColor : Color("BackgroundLayer1Color"))
                                    .foregroundColor(selectedChapter == chapterShort.name ? Color("BackgroundLayer1Color") : Color("ForegroundColor"))
                                    .cornerRadius(12)
                                } else {
                                    Button(action: {
                                        withAnimation {
                                            selectedChapter = chapterShort.name ?? ""
                                            // init chapter detail
                                        }
                                    }) {
                                        Group {
                                            HStack {
                                                Text(chapterShort.name ?? "")
                                                    .lineLimit(1)
                                                Spacer()
                                                Image(systemName: selectedChapter == chapterShort.name ? "chevron.up" : "chevron.down")
                                            }
                                            .padding()
                                        }
                                        .background(selectedChapter == chapterShort.name ? Color.accentColor : Color("BackgroundLayer1Color"))
                                        .foregroundColor(selectedChapter == chapterShort.name ? Color("BackgroundLayer1Color") : Color("ForegroundColor"))
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(DefaultButtonStyleHelper())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .padding(.bottom, bounds.size.height)
                }
                .background(Color("BackgroundColor"))
                .cornerRadius(24)
                .padding(.bottom, -bounds.size.height)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
