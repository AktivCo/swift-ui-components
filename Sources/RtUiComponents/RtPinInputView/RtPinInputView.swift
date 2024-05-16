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

    private let defaultPinGetter: () -> Void
    private let onSubmit: (String) -> Void

    init(defaultPinGetter: @escaping () -> Void,
         onSubmit: @escaping (String) -> Void) {
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
        }
        .onAppear {
            if model.buttonState == .ready {
                buttonState = model.pin.isEmpty ? .disabled : .ready
            } else {
                buttonState = model.buttonState
            }
        }
        .onChange(of: model.buttonState) { state in
            if state == .ready {
                buttonState = model.pin.isEmpty ? .disabled : .ready
            } else {
                buttonState = state
            }
        }
        .onChange(of: model.pin) {
            if [.ready, .disabled].contains(buttonState) {
                buttonState = $0.isEmpty ? .disabled : .ready
            }
        }
        .onDisappear {
            model.errorDescription = ""
        }
    }
}


struct RtPinInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RtPinInputView(defaultPinGetter: { },
                           onSubmit: { _ in })
            .environmentObject(RtPinInputModel(errorDescription: "Неверный PIN-код. Осталось попыток: 9", pin: "12345678"))
        }
        .background(Color.black.opacity(0.25))

        VStack {
            RtPinInputView(defaultPinGetter: { },
                           onSubmit: { _ in })
            .environmentObject(RtPinInputModel(pin: "12345678", buttonState: .inProgress))
        }
        .background(Color.black.opacity(0.25))
        .previewDisplayName("With progress loader")

        VStack {
            RtPinInputView(defaultPinGetter: { },
                           onSubmit: { _ in })
            .environmentObject(RtPinInputModel(pin: "12345678", buttonState: .cooldown(4)))
        }
        .background(Color.black.opacity(0.25))
        .previewDisplayName("With cooldown timer")
    }
}
