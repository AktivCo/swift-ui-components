//
//  RtVcrIndicatorModifier.swift
//
//
//  Created by Ivan Poderegin on 18.07.2024.
//

import SwiftUI


public extension View {
    ///  Presents the VcrIndicator based on vcrName
    /// - Parameters:
    ///   - vcrName: A binding to the connected iPhone’s name, an optional value that determines whether to present the VcrIndicator
    func rtVcrIndicator(_ vcrName: Binding<String?>) -> some View {
        modifier(RtVcrIndicatorModifier(vcrName: vcrName))
    }
}

private struct RtVcrIndicatorModifier: ViewModifier {
    @Binding var vcrName: String?

    public func body(content: Content) -> some View {
        RtVcrIndicator(vcrName: $vcrName, presentationView: content)
    }
}

private struct VcrIndicatorView: View {
    @State var vcrName: String?

    var body: some View {
        Button("Start VCR") {
            vcrName = "Ivan’s iPhone"
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                vcrName = nil
            }
        }
        .rtVcrIndicator($vcrName)
    }
}

struct VcrIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        VcrIndicatorView()
            .previewDisplayName("RtVcrIndicatorModifier")

        VcrIndicatorView()
            .previewDisplayName("RtVcrIndicatorModifier dark")
            .preferredColorScheme(.dark)
    }
}
