//
//  RtPinInputView.swift
//  
//
//  Created by Андрей Трифонов on 2023-11-13.
//

import SwiftUI


struct RtPinInputView: View {
    @State private var pin: String = ""
    @EnvironmentObject private var error: RtPinInputError
    @FocusState private var isPinFieldFocused: Bool

    private let defaultPinGetter: () -> String
    private let onSubmit: (String) -> Void

    init(defaultPinGetter: @escaping () -> String,
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

            HStack(spacing: 0) {
                SecureField("", text: $pin)
                    .textContentType(.oneTimeCode)
                    .focused($isPinFieldFocused)
                    .frame(height: 44)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 12)

                if !pin.isEmpty {
                    Button {
                        pin = ""
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

            Text(error.errorDescription)
                .padding(.horizontal, 12)
                .padding(.top, 5)
                .font(.footnote)
                .foregroundColor(Color.RtColors.rtColorsSystemRed)

            Spacer()

            Button("Продолжить") {
                onSubmit(pin)
            }
            .buttonStyle(RtRoundedFilledButtonStyle())
            .disabled(pin.isEmpty)
        }
        .padding(.bottom, UIDevice.isPhone ? 20 : 48)
        .background { Color.clear }
        .onAppear {
            pin = defaultPinGetter()
            isPinFieldFocused = true
        }
    }
}


struct RtPinInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RtPinInputView(defaultPinGetter: { "12345678" },
                           onSubmit: { _ in })
            .environmentObject(RtPinInputError(errorDescription: "Неверный PIN-код. Осталось попыток: 9"))
        }
        .background(Color.black.opacity(0.25))
    }
}
