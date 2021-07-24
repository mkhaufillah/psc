//
//  ActivityDetailView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 21/07/21.
//

import SwiftUI

struct ActivityDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let bounds = UIScreen.main.bounds
    
    let activity: ActivityModel
    @Binding var image: UIImage?
    
    var desc = Text("")
    
    init(activity: ActivityModel, image: Binding<UIImage?>) {
        self.activity = activity
        self._image = image
        
        let descArray = (JSONHelper<ActivityModel>().stringToDictionary(text: activity.desc ?? "") ?? [String:Any]())["ops"] as! Array<Any>
        
        for descItem in descArray {
            let descItemConv = descItem as! [String: Any]
            let insert = descItemConv["insert"] as! String?
            let attributes = descItemConv["attributes"] as! [String: Any]?
            let italic = attributes?["italic"] as! Bool? ?? false
            let bold = attributes?["bold"] as! Bool? ?? false
            
            if italic == true {
                desc = desc + Text(insert ?? "").fontWeight(bold == true ? .bold : .regular).italic()
            } else {
                desc = desc + Text(insert ?? "").fontWeight(bold == true ? .bold : .regular)
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
                        Text(ActivityString.title)
                            .fontWeight(.bold)
                    }
                }
                .buttonStyle(DefaultButtonStyleHelper())
                .padding()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Group {
                            Text((activity.name ?? "") + " - " )
                                .fontWeight(.black)
                                .padding(.bottom, 8)
                                .padding(.top)
                            Divider()
                            Text((ActivityString.pscTeam))
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .padding(.top, 8)
                            Text(ActivityString.eventDate + " ")
                                .font(.system(size: 14)) +
                                Text(DateHelper.stringToDate(s: activity.dateEvent ?? "", format: "yyyy-MM-dd"), style: .date)
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
                        desc
                            .padding(.horizontal)
                    }
                    .padding(.bottom, bounds.size.height)
                }
                .background(Color("BackgroundColor"))
                .cornerRadius(24)
                .padding(.bottom, -bounds.size.height)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
