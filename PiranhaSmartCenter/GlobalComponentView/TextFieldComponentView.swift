//
//  TextFieldComponentView.swift
//  PiranhaSmartCenter
//
//  Created by mohammad.khaufillah on 10/07/21.
//

import SwiftUI

enum Position {
    case left
    case right
}

struct TextFieldComponentView {
    let commit: () -> Void
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    
    init(commit: @escaping () -> Void = {}, text: Binding<String>) {
        self.commit = commit
        self._text = text
    }
    
    func primary(title: String, icon: String? = nil, position: Position? = nil, type: UITextContentType? = nil, keyboardType: UIKeyboardType) -> some View {
        return HStack {
            if icon != nil && position == Position.left {
                Image(systemName: icon ?? "")
                    .foregroundColor(Color.accentColor)
                    .padding(.leading, 12)
            }
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(title)
                        .foregroundColor(Color("ForegroundLayer2Color"))
                }
                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                    .textContentType(type)
                    .keyboardType(keyboardType)
                    .padding(.bottom)
                    .padding(.top)
            }
            .padding(.horizontal, 12)
            if icon != nil && position == Position.right {
                Image(systemName: icon ?? "")
                    .foregroundColor(Color.accentColor)
                    .padding(.trailing, 12)
            }
        }
        .background(Color("BackgroundLayer1Color"))
        .foregroundColor(Color("ForegroundColor"))
        .cornerRadius(12)
    }
    
    func primarySecure(title: String, icon: String? = nil, position: Position? = nil) -> some View {
        return HStack {
            if icon != nil && position == Position.left {
                Image(systemName: icon ?? "")
                    .foregroundColor(Color.accentColor)
                    .padding(.leading, 12)
            }
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(title)
                        .foregroundColor(Color("ForegroundLayer2Color"))
                }
                SecureField("", text: $text, onCommit: commit)
                    .textContentType(.password)
                    .padding(.bottom)
                    .padding(.top)
            }
            .padding(.horizontal, 12)
            if icon != nil && position == Position.right {
                Image(systemName: icon ?? "")
                    .foregroundColor(Color.accentColor)
                    .padding(.trailing, 12)
            }
        }
        .background(Color("BackgroundLayer1Color"))
        .foregroundColor(Color("ForegroundLayer1Color"))
        .cornerRadius(12)
    }
}

