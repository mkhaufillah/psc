//
//  ButtonComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 10/07/21.
//

import SwiftUI

struct ButtonComponentView {
    static func primaryButton(title: String, action: @escaping () -> Void, isLoading: Bool = false, isDisabled: Bool = false, leadingImg: String? = nil, traillingImg: String? = nil) -> some View {
        return BaseButtonComponentView.button(title: title, action: action, isLoading: isLoading, leadingImg: leadingImg, traillingImg: traillingImg)
            .buttonStyle(PrimaryButtonStyleHelper(disabled: isDisabled))
            .disabled(isDisabled)
    }
    
    static func primaryFullButton(title: String, action: @escaping () -> Void, isLoading: Bool = false, isDisabled: Bool = false, leadingImg: String? = nil, traillingImg: String? = nil, isCenter: Bool = true) -> some View {
        return BaseButtonComponentView.fullButton(title: title, action: action, isLoading: isLoading, leadingImg: leadingImg, traillingImg: traillingImg, isCenter: isCenter)
            .buttonStyle(PrimaryButtonStyleHelper(disabled: isDisabled))
            .disabled(isDisabled)
    }
    
    static func secondaryButton(title: String, action: @escaping () -> Void, isLoading: Bool = false, isDisabled: Bool = false, leadingImg: String? = nil, traillingImg: String? = nil) -> some View {
        return BaseButtonComponentView.button(title: title, action: action, isLoading: isLoading, leadingImg: leadingImg, traillingImg: traillingImg)
            .buttonStyle(SecondaryButtonStyleHelper(disabled: isDisabled))
            .disabled(isDisabled)
    }
    
    static func secondaryFullButton(title: String, action: @escaping () -> Void, isLoading: Bool = false, isDisabled: Bool = false, leadingImg: String? = nil, traillingImg: String? = nil, isCenter: Bool = true) -> some View {
        return BaseButtonComponentView.fullButton(title: title, action: action, isLoading: isLoading, leadingImg: leadingImg, traillingImg: traillingImg, isCenter: isCenter)
            .buttonStyle(SecondaryButtonStyleHelper(disabled: isDisabled))
            .disabled(isDisabled)
    }
    
    static func textFieldFullButton(title: String, action: @escaping () -> Void, isLoading: Bool = false, leadingImg: String? = nil, traillingImg: String? = nil, isCenter: Bool = true) -> some View {
        return BaseButtonComponentView.fullButton(title: title, action: action, isLoading: isLoading, leadingImg: leadingImg, traillingImg: traillingImg, isCenter: isCenter, colorImg: Color.accentColor)
            .buttonStyle(TextFieldButtonStyleHelper())
    }
    
    static func bigRoundedImageButton(title: String, action: @escaping () -> Void, isLoading: Bool = false, img: UIImage?) -> some View {
        return BaseButtonComponentView.imageButton(title: title, action: action, isLoading: isLoading, img: img)
            .buttonStyle(DefaultButtonStyleHelper())
    }
    
    static func bigSquarePotraitImageButton(title: String, action: @escaping () -> Void, isLoading: Bool = false, img: UIImage?) -> some View {
        return BaseButtonComponentView.squarePotraitImageButton(title: title, action: action, isLoading: isLoading, img: img)
            .buttonStyle(DefaultButtonStyleHelper())
    }
}

private struct BaseButtonComponentView {
    static func button(title: String, action: @escaping () -> Void, isLoading: Bool, leadingImg: String?, traillingImg: String?, colorImg: Color? = nil) -> some View {
        return Button(action: action) {
            if isLoading == true {
                ProgressView().padding(.horizontal)
            } else {
                HStack(alignment: .center, spacing: 8) {
                    if leadingImg != nil {
                        if colorImg != nil {
                            Image(systemName: leadingImg ?? "")
                                .foregroundColor(colorImg ?? Color.black)
                        } else {
                            Image(systemName: leadingImg ?? "")
                        }
                    }
                    Text(title)
                        .lineLimit(1)
                        .padding(.horizontal)
                    if traillingImg != nil {
                        if colorImg != nil {
                            Image(systemName: traillingImg ?? "")
                                .foregroundColor(colorImg ?? Color.black)
                        } else {
                            Image(systemName: traillingImg ?? "")
                        }
                    }
                }
            }
        }
    }
    
    static func fullButton(title: String, action: @escaping () -> Void, isLoading: Bool, leadingImg: String?, traillingImg: String?, isCenter: Bool, colorImg: Color? = nil) -> some View {
        return Button(action: action) {
            if isLoading == true {
                ProgressView().frame(minWidth: 0, maxWidth: .infinity)
            } else {
                HStack(alignment: .center, spacing: 8) {
                    if leadingImg != nil {
                        if colorImg != nil {
                            Image(systemName: leadingImg ?? "")
                                .foregroundColor(colorImg ?? Color.black)
                        } else {
                            Image(systemName: leadingImg ?? "")
                        }
                    }
                    if isCenter {
                        Text(title).frame(minWidth: 0, maxWidth: .infinity)
                            .lineLimit(1)
                    } else {
                        Text(title)
                            .lineLimit(1)
                        Spacer()
                    }
                    if traillingImg != nil {
                        if colorImg != nil {
                            Image(systemName: traillingImg ?? "")
                                .foregroundColor(colorImg ?? Color.black)
                        } else {
                            Image(systemName: traillingImg ?? "")
                        }
                    }
                }
            }
        }
    }
    
    static func imageButton(title: String, action: @escaping () -> Void, isLoading: Bool, img: UIImage?) -> some View {
        return Button(action: action) {
            if isLoading == true {
                ProgressView().frame(minWidth: 0, maxWidth: .infinity)
            } else {
                VStack(alignment: .center, spacing: 16) {
                    if img == nil {
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64, alignment: .center)
                            .padding(32)
                            .foregroundColor(Color("ForegroundLayer2Color"))
                            .background(Color("BackgroundLayer1Color"))
                            .cornerRadius(128)
                    } else {
                        Image(uiImage:
                                (img ?? UIImage(systemName: "camera"))!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 128, height: 128, alignment: .center)
                            .cornerRadius(128)
                    }
                    Text(title)
                        .lineLimit(1)
                }
            }
        }
    }
    
    static func squarePotraitImageButton(title: String, action: @escaping () -> Void, isLoading: Bool, img: UIImage?) -> some View {
        return Button(action: action) {
            if isLoading == true {
                ProgressView().frame(minWidth: 0, maxWidth: .infinity)
            } else {
                VStack(alignment: .center, spacing: 16) {
                    if img == nil {
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64 + 64, height: 64, alignment: .center)
                            .padding(32)
                            .foregroundColor(Color("ForegroundLayer2Color"))
                            .background(Color("BackgroundLayer1Color"))
                            .cornerRadius(12)
                    } else {
                        Image(uiImage:
                                (img ?? UIImage(systemName: "camera"))!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 128 + 64, height: 128, alignment: .center)
                            .cornerRadius(12)
                    }
                    Text(title)
                        .lineLimit(1)
                }
            }
        }
    }
}

struct PrimaryButtonStyleHelper: ButtonStyle {
    let disabled: Bool
    let color: Color?
    
    init(disabled: Bool, color: Color? = nil) {
        self.disabled = disabled
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color("BackgroundColor"))
            .background(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .stroke(
                    !disabled ? LinearGradient(gradient: Gradient(colors: [color ?? Color.accentColor, color ?? Color("Accent2Color")]), startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(gradient: Gradient(colors: [color ?? Color("ForegroundLayer2Color"), color ?? Color("ForegroundLayer2Color")]), startPoint: .leading, endPoint: .trailing),
                    lineWidth: 3
                )
                .background(
                    !disabled ? LinearGradient(gradient: Gradient(colors: [color ?? Color.accentColor, color ?? Color("Accent2Color")]), startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(gradient: Gradient(colors: [color ?? Color("ForegroundLayer2Color"), color ?? Color("ForegroundLayer2Color")]), startPoint: .leading, endPoint: .trailing)
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyleHelper: ButtonStyle {
    let disabled: Bool
    let isTransformToPrimary: Bool
    
    init(disabled: Bool, isTransformToPrimary: Bool = false) {
        self.disabled = disabled
        self.isTransformToPrimary = isTransformToPrimary
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(isTransformToPrimary ? Color("BackgroundColor") : Color.accentColor)
            .background(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
                .stroke(
                    !disabled ? LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color("Accent2Color")]), startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(gradient: Gradient(colors: [Color("ForegroundLayer2Color"), Color("ForegroundLayer2Color")]), startPoint: .leading, endPoint: .trailing),
                    lineWidth: 3
                ).background(
                    isTransformToPrimary ?
                        LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color("Accent2Color")]), startPoint: .leading, endPoint: .trailing)
                        :
                        LinearGradient(gradient: Gradient(colors: [Color("TransparentColor"), Color("TransparentColor")]), startPoint: .leading, endPoint: .trailing)
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct TextFieldButtonStyleHelper: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color("ForegroundColor"))
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color("BackgroundLayer1Color"), lineWidth: 3).background(Color("BackgroundLayer1Color"))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DefaultButtonStyleHelper: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color("ForegroundColor"))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
