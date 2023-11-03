//
//  RtLoadingIndicator.swift
//
//
//  Created by Никита Девятых on 19.10.2023.
//

import SwiftUI


public struct RtLoadingIndicator: View {
    private let type: RtLoadingIndicatorType
    @State private var isAnimating: Bool = false

    public init(_ type: RtLoadingIndicatorType) {
        self.type = type
    }

    public var body: some View {
        trimmedIndicator(color: type.outerColor, width: type.lineWidth, size: type.size)
            .overlay(
                trimmedIndicator(color: type.innerColor, width: type.lineWidth, size: type.size / type.ratio, isClockwise: false)
            )
            .onAppear {
                withAnimation(type.animation) {
                    isAnimating.toggle()
                }
            }
    }

    private func trimmedIndicator(trim: Double = 0.85, color: Color, width: Double, size: Double, isClockwise: Bool = true) -> some View {
        Circle()
            .trim(from: 0, to: trim)
            .stroke(color, style: StrokeStyle(lineWidth: width, lineCap: .round))
            .rotationEffect(Angle(degrees: isAnimating ? isClockwise ? 360 : -360 : 0))
            .frame(width: size, height: size, alignment: .center)
    }
}

struct RtLoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RtLoadingIndicator(.big)

            RtLoadingIndicator(.small)
                .padding(10)
                .background(Color.RtColors.rtColorsPrimary100)
        }
    }
}
