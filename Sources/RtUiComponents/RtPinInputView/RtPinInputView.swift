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
    @State private var inProgress: Bool = false

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

            Button {
                if !inProgress {
                    onSubmit(model.pin)
                }
            } label: {
                buttonLabel
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(RtRoundedFilledButtonStyle())
            .disabled(model.pin.isEmpty || model.isContinueButtonDisabled)
        }
        .padding(.bottom, UIDevice.isPhone ? 20 : 48)
        .background { Color.clear }
        .onAppear {
            defaultPinGetter()
            isPinFieldFocused = true
        }
        .onChange(of: model.inProgress) { newValue in
            inProgress = newValue
        }
        .onDisappear {
            model.errorDescription = ""
        }
    }

    @ViewBuilder
    private var buttonLabel: some View {
        if inProgress {
            RtLoadingIndicator(.small)
                .padding(.vertical, 13)
        } else {
            Text("Продолжить")
                .font(.headline)
                .padding(.vertical, 15)
        }
    }
}


struct RtPinInputView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RtPinInputView(defaultPinGetter: { },
                           onSubmit: { _ in })
            .environmentObject(RtPinInputModel(errorDescription: "Неверный PIN-код. Осталось попыток: 9"))
        }
        .background(Color.black.opacity(0.25))

        VStack {
            RtPinInputView(defaultPinGetter: { },
                           onSubmit: { _ in })
            .environmentObject(RtPinInputModel(isContinueButtonDisabled: true))
        }
        .background(Color.black.opacity(0.25))
        .previewDisplayName("With disabled continue button")
    }
}
