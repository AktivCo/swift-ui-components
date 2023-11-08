//
//  RtAlertButton.swift
//
//
//  Created by Никита Девятых on 14.11.2023.
//

import SwiftUI


public enum RtAlertButton {
    case destructive(String, () -> Void)
    case regular(String, () -> Void)
    case bold(String, () -> Void)

    var content: some View {
        switch self {
        case let .bold(text, callback):
            return Button(action: callback, label: {
                Text(text)
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .foregroundColor(Color.RtColors.rtColorsSecondary)
            })
        case let .destructive(text, callback):
            return Button(action: callback, label: {
                Text(text)
                    .font(.system(size: 17))
                    .foregroundColor(Color.RtColors.rtColorsSystemRed)
            })
        case let .regular(text, callback):
            return Button(action: callback, label: {
                Text(text)
                    .font(.system(size: 17))
                    .foregroundColor(Color.RtColors.rtColorsSecondary)
            })
        }
    }
}
