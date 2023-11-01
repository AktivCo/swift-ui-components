//
//  RtCopyNotification.swift
//
//
//  Created by Vova Badyaev on 01.11.2023.
//

import SwiftUI


public struct RtCopyNotification: View {
    private var text: String
    public init(with text: String) { self.text = text }

    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "square.fill.on.square.fill")
                .foregroundColor(Color.RtColors.rtColorsSecondary)
                .frame(width: 20, height: 20)
            Text(text)
                .padding(.leading, 8)
        }
        .padding(12)
        .frame(height: 44)
        .background(Color.RtColors.rtSurfaceQuaternary)
        .cornerRadius(12)
    }
}

struct RtCopyNotification_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            VStack(spacing: 40) {
                RtCopyNotification(with: "Ссылка скопирована")
                    .shadow(color: .RtColors.rtShadow.opacity(0.25), radius: 12, x: 0, y: -1)
                RtCopyNotification(with: "Commit ID скопирован")
                    .shadow(color: .RtColors.rtShadow.opacity(0.25), radius: 12, x: 0, y: -1)
                RtCopyNotification(with: "Номер телефона скопирован")
                    .shadow(color: .RtColors.rtShadow.opacity(0.25), radius: 12, x: 0, y: -1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.RtColors.rtSurfaceSecondary)
            .preferredColorScheme($0)
            .previewDisplayName("RtCopyNotification\($0 == .dark ? " Dark Mode" : "")")
        }
    }
}
