//
//  RtPinInputView.swift
//  
//
//  Created by Андрей Трифонов on 2023-11-13.
//

import SwiftUI


struct RtPinInputView: View {
    @EnvironmentObject private var model: RtPinInputModel
    @FocusState private var isPinFieldFocused: Bool
    @State private var buttonState: RtContinueButtonState = .ready

    private let tokenType: RtTokenType
    private let defaultPinGetter: () -> Void
    private let onSubmit: (String) -> Void

    init(tokenType: RtTokenType,
         defaultPinGetter: @escaping () -> Void,
         onSubmit: @escaping (String) -> Void) {
        self.tokenType = tokenType
        self.defaultPinGetter = defaultPinGetter
        self.onSubmit = onSubmit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Введите PIN-код")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color.RtColors.rtLabelPrimary)
                .padding(.bottom, 18)

            Text("PIN-КОД РУТОКЕНА")
                .font(.footnote)
                .foregroundStyle(Color.RtColors.rtLabelSecondary)
                .padding(.leading, 12)
                .padding(.bottom, 7)
                .onTapGesture {
                    isPinFieldFocused = false
                }

            HStack(spacing: 0) {
                SecureField("", text: .init(
                    get: { model.pin },
                    set: { value in model.pin = value }))
                .textContentType(.oneTimeCode)
                .focused($isPinFieldFocused)
                .frame(height: 44)
                .textFieldStyle(PlainTextFieldStyle())
                .tint(.RtColors.rtColorsSecondary)
                .padding(.horizontal, 12)

                if !model.pin.isEmpty {
                    Button {
                        model.pin = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .frame(width: 16, height: 16)
                            .tint(.RtColors.rtIosElementsInputClearSurface)
                    }
                    .padding(.trailing, 12)
                }
            }
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.RtColors.rtSurfaceQuaternary))

            Text(model.errorDescription)
                .padding(.horizontal, 12)
                .padding(.top, 5)
                .font(.footnote)
                .foregroundColor(Color.RtColors.rtColorsSystemRed)

            Spacer()

            RtLoadingButton(action: { onSubmit(model.pin) },
                            title: "Продолжить",
                            state: buttonState)
        }
        .padding(.bottom, UIDevice.isPhone ? 20 : 48)
        .background { Color.clear }
        .onAppear {
            defaultPinGetter()
            isPinFieldFocused = true
            buttonState = calculateButtonState()
        }
        .onChange(of: model.buttonState) { _ in
            buttonState = calculateButtonState()
        }
        .onChange(of: model.pin) { _ in
            buttonState = calculateButtonState()
        }
        .onDisappear {
            model.errorDescription = ""
        }
    }

    private func calculateButtonState() -> RtContinueButtonState {
        switch (model.buttonState, tokenType) {
        case (.ready, _):
            return model.pin.isEmpty ? .disabled : .ready
        case (.cooldown, .usb):
            return .ready
        default:
            return model.buttonState
        }
    }
}


struct RtPinInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RtPinInputView(tokenType: .usb, defaultPinGetter: { },
                           onSubmit: { _ in })
            .environmentObject(RtPinInputModel(errorDescription: "Неверный PIN-код. Осталось попыток: 9", pin: "12345678"))
        }
        .background(Color.black.opacity(0.25))

        VStack {
            RtPinInputView(tokenType: .usb, defaultPinGetter: { },
                           onSubmit: { _ in })
            .environmentObject(RtPinInputModel(pin: "12345678", buttonState: .inProgress))
        }
        .background(Color.black.opacity(0.25))
        .previewDisplayName("With progress loader")

        VStack {
            RtPinInputView(tokenType: .usb, defaultPinGetter: { },
                           onSubmit: { _ in })
            .environmentObject(RtPinInputModel(pin: "12345678", buttonState: .cooldown(4)))
        }
        .background(Color.black.opacity(0.25))
        .previewDisplayName("With cooldown timer")
    }
}
