//
//  CommentComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 29/07/21.
//

import SwiftUI

struct CommentComponentView: View {
    let comment: CommentModel
    let video: ShortVideoModel?
    
    @EnvironmentObject var videoViewModel: VideoViewModel
    
    @ObservedObject var imageLoaderProvider: ImageLoaderProvider
    @State var image:UIImage? = nil
    
    init(video: ShortVideoModel? = nil, comment: CommentModel) {
        imageLoaderProvider = ImageLoaderProvider(urlString: comment.picture ?? "")
        self.comment = comment
        self.video = video
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
                    Text(comment.userName ?? "")
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .padding(.top)
                        .foregroundColor(Color.accentColor)
                    EmptyView().frame(minWidth: 0, maxWidth: .infinity)
                    Text(comment.comment ?? "")
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
                if video != nil {
                    HStack(spacing: 8) {
                        Text(DateHelper.stringToRelativeDate(s: comment.createdAt ?? "", format: "yyyy-MM-dd HH:mm:ss"))
                            .font(.system(size: 12))
                            .padding(.leading, 4)
                            .foregroundColor(Color("ForegroundLayer1Color"))
                            .lineLimit(1)
                        if "\(videoViewModel.dataUser?.id ?? 0)" == comment.userId {
                            Button(action: {
                                videoViewModel.parentComment = comment.parentId ?? ""
                                videoViewModel.idEditedComment = comment.id
                                videoViewModel.selectedComment = nil
                                videoViewModel.comment = comment.comment ?? ""
                                videoViewModel.isEdit = true
                            }) {
                                Text(VideoString.edit)
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                            }
                            Button(action: {
                                videoViewModel.selectedComment = comment
                                videoViewModel.deleteMyComment(idComment: comment.id, callback: {
                                    videoViewModel.initDataComments(typeVideo: video!.videoType ?? "free", idVideo: video!.id)
                                })
                            }) {
                                Text(VideoString.delete)
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .padding(.trailing, 4)
                                    .foregroundColor(Color("ErrorColor"))
                            }
                        }
                        Button(action: {
                            videoViewModel.parentComment = "\(comment.id)"
                            videoViewModel.idEditedComment = 0
                            videoViewModel.selectedComment = comment
                            videoViewModel.isReply = true
                        }) {
                            Text(VideoString.reply)
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .padding(.trailing, 4)
                        }
                    }
                    // Children comments
                    ForEach(
                        videoViewModel.dataChildrenComments[comment.id] ?? [],
                        id: \.id
                    ) { childrenComment in
                        ChildrenCommentComponentView(
                            video: video!,
                            childrenComment: childrenComment,
                            comment: comment,
                            userId: "\(videoViewModel.dataUser?.id ?? 0)"
                        )
                            .environmentObject(videoViewModel)
                    }
                    // End off children comments
                }
            }
            Spacer()
        }
    }
}
