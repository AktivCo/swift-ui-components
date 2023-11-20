//
//  RtTokenChoiceView.swift
//
//
//  Created by Ivan Poderegin on 30.10.2023.
//

import SwiftUI


struct RtTokenChoiceView: View {
    let cards = RtTokenCard.allCases

    private func choiceCard(for card: RtTokenCard) -> some View {
        let cornerRadius = 12.0

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
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .frame(height: 128)
        .frame(minWidth: 350, maxWidth: 388)
        .background(Color.RtColors.rtSurfaceQuaternary)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Text("Выберите Рутокен")
                    .font(.largeTitle)
                    .foregroundStyle(Color.RtColors.rtLabelPrimary)
                    .bold()
                Spacer()
            }
            .frame(minWidth: 350, maxWidth: 388)
            VStack(spacing: 12) {
                ForEach(cards, id: \.self) { card in
                    choiceCard(for: card)
                }
            }
            .padding(.top, 24)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: 540, maxHeight: .infinity, alignment: .top)
        .background { Color.clear }
    }
}

struct RtTokenChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        RtTokenChoiceView()
            .background(Color.black.opacity(0.25))
    }
}
