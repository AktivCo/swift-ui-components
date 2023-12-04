//
//  RtAlertButtonTitle.swift
//
//
//  Created by Никита Девятых on 14.11.2023.
//

import SwiftUI


public enum RtAlertButtonTitle {
    case destructive(String)
    case regular(String)
    case bold(String)

    var text: some View {
        switch self {
        case let .bold(text):
            return Text(text)
                .fontWeight(.semibold)
                .font(.system(size: 17))
                .foregroundColor(Color.RtColors.rtColorsSecondary)
        case let .destructive(text):
            return Text(text)
                    .font(.system(size: 17))
                    .foregroundColor(Color.RtColors.rtColorsSystemRed)
        case let .regular(text):
            return Text(text)
                    .font(.system(size: 17))
                    .foregroundColor(Color.RtColors.rtColorsSecondary)
        }
    }
}
