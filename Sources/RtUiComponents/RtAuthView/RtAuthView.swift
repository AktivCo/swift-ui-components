//
//  RtAuthView.swift
//
//
//  Created by Андрей Трифонов on 2023-11-21.
//

import SwiftUI


/// View that combines the transition from selecting a type of interaction with token to PIN code input
/// - Parameters:
///   - defaultPinGetter: Produces default PIN code value if it's available
///   - onSubmit: Callback for PinInputView
///   - onCancel: Callback for "Cancel" button
public struct RtAuthView: View {
    @State private var tokenType: RtTokenType?

    private let defaultPinGetter: () -> Void
    private let onSubmit: (RtTokenType, String) -> Void
    private let onCancel: () -> Void

    public init(defaultPinGetter: @escaping () -> Void,
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
                    RtPinInputView(tokenType: tokenType) {
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
            RtAuthView {} onSubmit: { _, _ in } onCancel: {}
                .environmentObject(RtPinInputModel(pin: "12345678"))
        }
    }
}
