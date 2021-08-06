//
//  ChildrenCommentComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 29/07/21.
//

import SwiftUI

struct ChildrenCommentComponentView: View {
    let childrenComment: ChildrenCommentModel
    let comment: CommentModel
    let userId: String
    let video: ShortVideoModel
    
    @EnvironmentObject var videoViewModel: VideoViewModel
    
    @ObservedObject var imageLoaderProvider: ImageLoaderProvider
    @State var image:UIImage? = nil
    
    init(video: ShortVideoModel, childrenComment: ChildrenCommentModel, comment: CommentModel, userId: String) {
        imageLoaderProvider = ImageLoaderProvider(urlString: childrenComment.picture ?? "")
        self.childrenComment = childrenComment
        self.userId = userId
        self.video = video
        self.comment = comment
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: image ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 32, height: 32)
                .background(Color("OverlayColor"))
                .cornerRadius(32)
                .onReceive(imageLoaderProvider.didChange) { data in
                    withAnimation {
                        self.image = UIImage(data: data) ?? UIImage()
                    }
                }
                .animation(.easeOut(duration: 0.2), value: image == nil)
                .padding(.vertical, 8)
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(childrenComment.userName ?? "")
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.top)
                        .foregroundColor(Color.accentColor)
                    EmptyView().frame(minWidth: 0, maxWidth: .infinity)
                    Text(childrenComment.comment ?? "")
                        .lineLimit(12)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                .background(
                    RoundedRectangle(
                        cornerRadius: 14,
                        style: .continuous
                    )
                    .stroke(
                        Color.accentColor,
                        lineWidth: 3
                    ).background(
                        Color("BackgroundLayer1Color")
                    )
                )
                .cornerRadius(14)
                HStack(spacing: 8) {
                    Text(DateHelper.stringToRelativeDate(s: childrenComment.createdAt ?? "", format: "yyyy-MM-dd HH:mm:ss"))
                        .font(.system(size: 12))
                        .padding(.leading, 4)
                        .foregroundColor(Color("ForegroundLayer1Color"))
                        .lineLimit(1)
                    if userId == childrenComment.userId {
                        Button(action: {
                            videoViewModel.parentComment = childrenComment.parentId ?? ""
                            videoViewModel.idEditedComment = childrenComment.id
                            videoViewModel.idParentEditedComment = comment.id
                            videoViewModel.comment = childrenComment.comment ?? ""
                            videoViewModel.selectedComment = nil
                            videoViewModel.isEdit = true
                        }) {
                            Text(VideoString.edit)
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                        }
                        Button(action: {
                            videoViewModel.selectedComment = comment
                            videoViewModel.deleteMyComment(idComment: childrenComment.id, callback: {
                                videoViewModel.initDataComments(typeVideo: video.videoType ?? "free", idVideo: video.id)
                            })
                        }) {
                            Text(VideoString.delete)
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .padding(.trailing, 4)
                                .foregroundColor(Color("ErrorColor"))
                        }
                    }
                }
            }
            Spacer()
        }
    }
}
