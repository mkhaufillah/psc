//
//  PublicationDetailView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 20/07/21.
//

import SwiftUI

struct PublicationDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let bounds = UIScreen.main.bounds
    
    let publication: PublicationModel
    @Binding var image: UIImage?
    
    var desc = Text("")
    var imageData: NSData? = nil
    
    @GestureState private var dragOffset = CGSize.zero
    
    init(publication: PublicationModel, image: Binding<UIImage?>) {
        self.publication = publication
        self._image = image
        
        let descArray = (JSONHelper<PublicationModel>().stringToDictionary(text: publication.desc ?? "") ?? [String:Any]())["ops"] as? Array<Any>
        
        for descItem in descArray ?? [] {
            let descItemConv = descItem as? [String: Any]
            //Use image name from bundle to create NSData
            var insert = descItemConv?["insert"] as? String?
            if insert == nil {
                insert = ""
                let imgStr = ((descItemConv?["insert"] as? [String:Any])?["image"] as? String? ?? "") ?? ""
                //Use image's path to create NSData
                let url = URL(string: imgStr)!
                //Now use image to create into NSData format
                imageData = NSData.init(contentsOf: url)
            }
            let attributes = descItemConv?["attributes"] as? [String: Any]?
            let italic = attributes??["italic"] as? Bool? ?? false
            let bold = attributes??["bold"] as? Bool? ?? false
            
            if italic == true {
                desc = desc + Text((insert ?? "") ?? "").fontWeight(bold == true ? .bold : .regular).italic()
            } else {
                desc = desc + Text((insert ?? "") ?? "").fontWeight(bold == true ? .bold : .regular)
            }
        }
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
                        Text(PublicationString.title)
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(DefaultButtonStyleHelper())
                .padding()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Group {
                            Text((publication.title ?? "") + " - " )
                                .fontWeight(.black)
                                .padding(.bottom, 8)
                                .padding(.top)
                            Divider()
                            Text((PublicationString.pscTeam))
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .padding(.top, 8)
                            Text(PublicationString.publishedAt + " ")
                                .font(.system(size: 14)) +
                                Text(DateHelper.stringToDate(s: publication.date ?? "", format: "yyyy-MM-dd"), style: .date)
                                .font(.system(size: 14))
                        }
                        .padding(.horizontal)
                        Image(uiImage: image ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: bounds.size.width - 32)
                            .background(Color("ForegroundLayer2Color").shadow(radius: 5))
                            .cornerRadius(12)
                            .padding()
                        if imageData != nil {
                            Image(uiImage: UIImage(data: imageData! as Data) ?? UIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: bounds.size.width - 32)
                                .background(Color("ForegroundLayer2Color").shadow(radius: 5))
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                        desc
                            .padding(.horizontal)
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
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                presentationMode.wrappedValue.dismiss()
            }
        }))
    }
}
