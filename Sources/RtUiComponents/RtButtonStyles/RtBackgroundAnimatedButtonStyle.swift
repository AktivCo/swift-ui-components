//
//  RtBackgroundAnimatedButtonStyle.swift
//
//
//  Created by Никита Девятых on 20.06.2024.
//

import SwiftUI


/// The style for button that animates only background when button is tapped
public struct RtBackgroundAnimatedButtonStyle: ButtonStyle {
    let pressedColor: Color
    let unpressedColor: Color

    public init(pressedColor: Color, unpressedColor: Color = .clear) {
        self.pressedColor = pressedColor
        self.unpressedColor = unpressedColor
    }

    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .background(configuration.isPressed ? pressedColor : unpressedColor)
            .animation(.easeOut(duration: configuration.isPressed ? 0.001 : 0.2), value: configuration.isPressed)
    }
}
