//
//  RtRoundedFilledButtonStyle.swift
//
//
//  Created by Андрей Трифонов on 2023-11-14.
//

import SwiftUI


/// The special style for buttons
public struct RtRoundedFilledButtonStyle: ButtonStyle {
    public init(){}

    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        InnerBody(configuration: configuration)
    }

    struct InnerBody: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .font(.headline)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .foregroundColor(isEnabled ? Color.RtColors.rtColorsOnPrimary : Color.RtColors.rtLabelTertiary)
                .background(isEnabled ? Color.RtColors.rtColorsPrimary100 : Color.RtColors.rtOtherDisabled)
                .cornerRadius(12)
        }
    }
}
