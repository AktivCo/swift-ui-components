//
//  RtIsPressedButtonStyle.swift
//
//
//  Created by Никита Девятых on 19.07.2024.
//

import SwiftUI


struct RtIsPressedButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) {
                isPressed = $0
            }
    }
}
