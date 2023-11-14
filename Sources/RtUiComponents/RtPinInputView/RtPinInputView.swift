//
//  RtPinInputView.swift
//  
//
//  Created by Андрей Трифонов on 2023-11-13.
//

import SwiftUI


public struct RtPinInputView: View {
    @State private var pin: String = ""
    @State private var error: String = ""

    private let onSubmit: (String) -> Void

    init(pin: String = "", error: String = "", onSubmit: @escaping (String) -> Void) {
        self.pin = pin
        self.error = error
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Введите PIN-код")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color.RtColors.rtLabelPrimary)
                .padding(.top, 5)
                .padding(.bottom, 12)
            VStack(alignment: .leading, spacing: 0) {
                Text("PIN-КОД РУТОКЕНА")
                    .font(.footnote)
                    .foregroundStyle(Color.RtColors.rtLabelSecondary)
                    .padding(.leading, 12)
                    .padding(.bottom, 7)

                SecureField("", text: $pin)
                    .frame(height: 44)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 12)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(Color.RtColors.rtColorsOnPrimary))

                Text(error)
                    .padding(.horizontal, 12)
                    .padding(.top, 5)
                    .font(.footnote)
                    .foregroundColor(Color.RtColors.rtColorsSystemRed)
            }
            Spacer()

            Button("Продолжить") {
                onSubmit(pin)
            }
            .buttonStyle(RtRoundedFilledButtonStyle())
            .disabled(pin.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 44)
        .background { Color.RtColors.rtSurfaceTertiary }
        .ignoresSafeArea(.all)
    }
}


struct RtPinInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RtPinInputView(error: "Неверный PIN-код. Осталось попыток: 9", onSubmit: { _ in })
        }
        .background { Color.black }
        .ignoresSafeArea(.all)
    }
}
