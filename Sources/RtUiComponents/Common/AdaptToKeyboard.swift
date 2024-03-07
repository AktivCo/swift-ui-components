//
//  AdaptToKeyboard.swift
//
//
//  Created by Vova Badyaev on 11.01.2024.
//

import Combine
import Foundation
import SwiftUI


// This add ability to hide keybaord on demand
extension UIApplication {
    static func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public extension View {
    /// The modifier that allows the view to change its state in accordance with the keyboard
    /// - Parameters:
    ///   - onAppear: Callback called when the keyboard appears with a same animation
    ///   - onDisappear: Callback called when the keyboard disappears with a same animation
    func rtAdaptToKeyboard(onAppear: @escaping () -> Void = {}, onDisappear: @escaping () -> Void = {}) -> some View {
        self.modifier(AdaptToKeyboard(onAppear, onDisappear))
    }
}


private struct AdaptToKeyboard: ViewModifier {
    @State private var bottomPadding: CGFloat = 0

    private var keyboardHeightPublisher: AnyPublisher<(CGFloat, Animation?), Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { ($0.keyboardHeight, $0.keyboardAnimation) }

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { (CGFloat(0), $0.keyboardAnimation) }

        return Publishers.MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }

    private let onAppear: () -> Void
    private let onDisappear: () -> Void

    init(_ onAppear: @escaping () -> Void, _ onDisappear: @escaping () -> Void) {
        self.onAppear = onAppear
        self.onDisappear = onDisappear
    }

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .padding(.bottom, bottomPadding)
                .onReceive(keyboardHeightPublisher) { keyboardHeight, animation in
                    let screenHeight = UIScreen.main.bounds.height
                    let heightAboveKeyboard = screenHeight - keyboardHeight
                    let rect = proxy.frame(in: .global)

                    withAnimation(animation) {
                        if rect.maxY > heightAboveKeyboard {
                            bottomPadding = rect.maxY - heightAboveKeyboard
                            onAppear()
                        } else {
                            bottomPadding = 0
                            onDisappear()
                        }
                    }
            }
        }
    }
}
