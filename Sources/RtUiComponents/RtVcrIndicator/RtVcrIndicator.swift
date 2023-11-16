//
//  RtVcrIndicator.swift
//
//
//  Created by Никита Девятых on 10.11.2023.
//

import SwiftUI


public struct RtVcrIndicator: View {
    let vcrName: String

    public var body: some View {
        VStack(spacing: 0) {
            RtLoadingIndicator(.big)
                .padding(.bottom, 16)
            Text("Продолжите работу на \(vcrName)")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: 146)
                .foregroundStyle(Color.RtColors.rtAlertLabelSecondary)
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
        .frame(width: 238, height: 148)
        .background { Color.RtColors.rtSurfaceTertiary }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct RtVcrIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.secondary.edgesIgnoringSafeArea(.all)
            RtVcrIndicator(vcrName: "Михаил’s iPhone")
        }
        .previewDisplayName("RtVcrIndicator")

        ZStack {
            Color.secondary.edgesIgnoringSafeArea(.all)
            RtVcrIndicator(vcrName: "Михаил’s iPhone")
        }
        .previewDisplayName("RtVcrIndicator Dark")
        .preferredColorScheme(.dark)
    }
}

