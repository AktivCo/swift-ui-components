//
//  RtAuthView.swift
//
//
//  Created by Андрей Трифонов on 2023-11-21.
//

import SwiftUI


public struct RtAuthView: View {
    @State private var tokenType: RtTokenType?

    private let defaultPinGetter: () -> String
    private let onSubmit: (RtTokenType, String) -> Void
    private let onCancel: () -> Void

    public init(defaultPinGetter: @escaping () -> String,
                onSubmit: @escaping (RtTokenType, String) -> Void,
                onCancel: @escaping () -> Void) {
        self.defaultPinGetter = defaultPinGetter
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                Button("Отменить") {
                    onCancel()
                }
                .frame(height: 44)
                .foregroundColor(Color.RtColors.rtColorsSecondary)
            }
            .padding(.top, 6)
            .padding(.bottom, 11)

            HStack {
                if let tokenType {
                    RtPinInputView {
                        defaultPinGetter()
                    } onSubmit: { pin in
                        onSubmit(tokenType, pin)
                    }
                    .rtAdaptToKeyboard()
                } else {
                    RtTokenChoiceView { type in
                        tokenType = type
                    }
                }
            }
            .frame(maxWidth: 388)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}


struct RtAuthView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RtAuthView { "12345678" } onSubmit: { _, _ in } onCancel: {}
        }
    }
}
