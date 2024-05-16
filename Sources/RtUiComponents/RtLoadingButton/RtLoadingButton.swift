//
//  RtLoadingButton.swift
//
//
//  Created by Ivan Poderegin on 28.03.2024.
//

import SwiftUI


public struct RtLoadingButton: View {
    private let action: () -> Void
    private let title: String
    private var state: RtContinueButtonState

    public init(action: @escaping () -> Void,
                title: String,
                state: RtContinueButtonState) {
        self.action = action
        self.title = title
        self.state = state
    }

    @ViewBuilder
    private var buttonLabel: some View {
        switch state {
        case .inProgress:
            RtLoadingIndicator(.small)
                .padding(.vertical, 13)
        case .ready, .disabled:
            Text(title)
                .padding(.vertical, 15)
        case .cooldown(let value):
            Text("Подождите \(value)...")
                .padding(.vertical, 15)
        }
    }

    private var isDisabled: Bool {
        switch self.state {
        case .disabled, .cooldown:
            return true
        case .inProgress, .ready:
            return false
        }
    }

    public var body: some View {
        Button {
            if state == .ready {
                action()
            }
        } label: {
            buttonLabel
        }
        .disabled(isDisabled)
        .buttonStyle(RtRoundedFilledButtonStyle())
        .animation(.easeOut(duration: 0.15), value: state)
    }
}

struct RtLoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        RtLoadingButton(action: {}, title: "Сгенерировать", state: .ready)
            .previewDisplayName("Regular")
        RtLoadingButton(action: {}, title: "Сгенерировать", state: .cooldown(3))
            .previewDisplayName("In cooldown")
        RtLoadingButton(action: {}, title: "Сгенерировать", state: .inProgress)
            .previewDisplayName("In progress")
    }
}
