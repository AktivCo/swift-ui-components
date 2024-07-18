//
//  RtVcrIndicator.swift
//
//
//  Created by Никита Девятых on 10.11.2023.
//

import SwiftUI


/// View for notifying the user to begin interacting with the VCR
struct RtVcrIndicator<Presenter>: View where Presenter: View {
    @Binding var vcrName: String?

    let presentationView: Presenter

    var body: some View {
        ZStack {
            presentationView
                .disabled(vcrName != nil)
            Color.RtColors.rtIosElementsAlertOverlay
                .edgesIgnoringSafeArea(.all)
                .opacity(vcrName == nil ? 0 : 1)
                .animation(.easeOut(duration: 0.24), value: vcrName == nil)
            if vcrName != nil {
                VStack(spacing: 0) {
                    RtLoadingIndicator(.big)
                        .padding(.bottom, 16)
                    Text("Продолжите работу на \(vcrName ?? "")")
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxWidth: 146)
                        .foregroundStyle(Color.RtColors.rtAlertLabelSecondary)
                }
                .padding(.top, 24)
                .padding(.bottom, 20)
                .frame(width: 238, height: 148)
                .background { Color.RtColors.rtSurfaceTertiary }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.scale(scale: 0.75).combined(with: .opacity).animation(.easeOut(duration: 0.24)))
                .zIndex(.greatestFiniteMagnitude)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
