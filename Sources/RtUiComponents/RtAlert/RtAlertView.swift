//
//  RtAlertView.swift
//  
//
//  Created by Никита Девятых on 15.11.2023.
//

import SwiftUI


struct RtAlertView<Presenter>: View where Presenter: View {
    @Binding var alertModel: RtAlertModel?
    let presentationView: Presenter

    var body: some View {
        ZStack {
            presentationView.disabled(alertModel != nil)
            Color.RtColors.rtIosElementsAlertOverlay
                .edgesIgnoringSafeArea(.all)
                .opacity(alertModel == nil ? 0 : 1)

            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    alertModel?.title.content
                    if let subTitle = alertModel?.subTitle {
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
                if let buttons = alertModel?.buttons {
                    ForEach(0..<buttons.count, id: \.self) { counter in
                        Divider()
                            .overlay(Color.RtColors.rtIosElementsAlertSeparator)
                        Button {
                            buttons[counter].action?()
                            alertModel = nil
                        } label: {
                            buttons[counter].title.text
                                .frame(width: 270, height: 44)
                        }
                        .multilineTextAlignment(.center)
                    }
                }
            }
            .background(Color.RtColors.rtIosElementsAlertSurface)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .opacity(alertModel == nil ? 0 : 1)
            .frame(width: 270)
        }
        .edgesIgnoringSafeArea(.all)
        .zIndex(Double.greatestFiniteMagnitude)
    }
}
