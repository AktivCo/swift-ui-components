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

    @Binding private var inProgress: Bool

    public init(action: @escaping () -> Void,
                title: String,
                inProgress: Binding<Bool>) {
        self.action = action
        self.title = title
        self._inProgress = inProgress
    }

    @ViewBuilder
    private var buttonLabel: some View {
        if inProgress {
            RtLoadingIndicator(.small)
                .padding(.vertical, 13)
        } else {
            Text(title)
                .padding(.vertical, 15)
        }
    }

    public var body: some View {
        Button {
            if !inProgress {
                action()
            }
        } label: {
            buttonLabel
        }
        .buttonStyle(RtRoundedFilledButtonStyle())
    }
}

struct RtLoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        RtLoadingButton(action: {}, title: "Сгенерировать",
                 inProgress: .constant(false))

        RtLoadingButton(action: {}, title: "Сгенерировать",
                 inProgress: .constant(true))
        .previewDisplayName("In progress")

    }
}
