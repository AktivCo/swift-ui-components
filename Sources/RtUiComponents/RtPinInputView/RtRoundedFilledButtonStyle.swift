//
//  RtRoundedFilledButtonStyle.swift
//
//
//  Created by Андрей Трифонов on 2023-11-14.
//

import SwiftUI


public struct RtRoundedFilledButtonStyle: ButtonStyle {
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        InnerBody(configuration: configuration)
    }

    public struct InnerBody: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        public var body: some View {
            configuration.label
                .font(.headline)
                .frame(height: 50)
                .frame(width: UIDevice.isPhone ? 350 : 388)
                .foregroundColor(isEnabled ? Color.RtColors.rtColorsOnPrimary : Color.RtColors.rtLabelTertiary)
                .background(isEnabled ? Color.RtColors.rtColorsPrimary100 : Color.RtColors.rtOtherDisabled)
                .cornerRadius(12)
        }
    }
}
