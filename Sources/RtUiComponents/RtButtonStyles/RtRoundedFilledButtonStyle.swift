//
//  RtRoundedFilledButtonStyle.swift
//
//
//  Created by Андрей Трифонов on 2023-11-14.
//

import SwiftUI


/// The special style for buttons
public struct RtRoundedFilledButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    let isPressable: Bool

    public init(isPressable: Bool) {
        self.isPressable = isPressable
    }

    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .foregroundColor(isEnabled ? Color.RtColors.rtColorsOnPrimary : Color.RtColors.rtLabelTertiary)
            .background(
                Group {
                    if isEnabled {
                        configuration.isPressed && isPressable ?
                        Color.RtColors.rtColorsPrimary80 : Color.RtColors.rtColorsPrimary100
                    } else {
                        Color.RtColors.rtOtherDisabled
                    }
                })
            .animation(.easeOut(duration: configuration.isPressed ? 0.001 : 0.25), value: configuration.isPressed)
            .cornerRadius(12)
    }
}
