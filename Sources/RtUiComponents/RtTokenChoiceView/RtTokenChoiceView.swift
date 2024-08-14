//
//  RtTokenChoiceView.swift
//
//
//  Created by Ivan Poderegin on 30.10.2023.
//

import SwiftUI


struct RtTokenChoiceView: View {
    private let onSelect: (RtTokenType) -> Void

    init(onSelect: @escaping (RtTokenType) -> Void) {
        self.onSelect = onSelect
    }

    private func choiceCard(for card: RtTokenType) -> some View {
        return HStack {
            VStack(alignment: .leading) {
                Text(card.title)
                    .font(.headline)
                    .foregroundStyle(Color.RtColors.rtLabelPrimary)
                    .bold()
                Spacer()
                Text(card.description)
                    .font(.footnote)
                    .foregroundStyle(Color.RtColors.rtLabelSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .bottom, .top], 12)
            Spacer()
            card.icon
        }
        .frame(height: 128)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Выберите Рутокен")
                .font(.largeTitle)
                .foregroundStyle(Color.RtColors.rtLabelPrimary)
                .bold()
                .padding(.bottom, 24)

            VStack(spacing: 12) {
                ForEach(RtTokenType.allCases, id: \.self) { card in
                    Button {
                        onSelect(card)
                    } label: {
                        choiceCard(for: card)
                    }
                    .buttonStyle(RtBackgroundAnimatedButtonStyle(pressedColor: .RtColors.rtOtherSelected))
                    .background(Color.RtColors.rtSurfaceQuaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Text("При попытке подключения смарт-карты через считыватель для смарт-карт, выберите «Рутокен с USB»")
                    .font(.footnote)
                    .foregroundStyle(Color.RtColors.rtLabelSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background { Color.clear }
    }
}

struct RtTokenChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        RtTokenChoiceView { type in
            print("type: \(type)")
        }
        .background(Color.black.opacity(0.25))
    }
}
