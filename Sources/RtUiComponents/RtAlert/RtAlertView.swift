//
//  RtAlertView.swift
//  
//
//  Created by Никита Девятых on 15.11.2023.
//

import SwiftUI


struct RtAlertView<Presenter>: View where Presenter: View {
    @Binding var isShowing: Bool
    let title: RtAlertTitle
    let subTitle: String?
    let buttons: [RtAlertButton]
    let presentationView: Presenter

    var body: some View {
        ZStack {
            presentationView.disabled(isShowing)
            Color.RtColors.rtIosElementsAlertOverlay
                .edgesIgnoringSafeArea(.all)
                .opacity(self.isShowing ? 1 : 0)

            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    title.content
                    if let subTitle {
                        Text(subTitle)
                            .padding(.top, 5)
                            .font(.system(size: 13))
                            .foregroundColor(.primary.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 19)
                .padding(.bottom, 17)
                ForEach(0..<buttons.count, id: \.self) { counter in
                    Divider()
                        .overlay(Color.RtColors.rtIosElementsAlertSeparator)
                    buttons[counter].content
                        .frame(height: 44)
                        .multilineTextAlignment(.center)
                }
            }
            .background(Color.RtColors.rtIosElementsAlertSurface)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .opacity(self.isShowing ? 1 : 0)
            .frame(width: 270)
        }
        .edgesIgnoringSafeArea(.all)
        .zIndex(Double.greatestFiniteMagnitude)
    }
}
