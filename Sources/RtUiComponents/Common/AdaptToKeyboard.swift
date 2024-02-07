//
//  AdaptToKeyboard.swift
//
//
//  Created by Vova Badyaev on 11.01.2024.
//

import SwiftUI


// This add ability to hide keybaord on demand
extension UIApplication {
    static func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public extension View {
    /// The modifier that allows the view to change its state in accordance with the keyboard
    func rtAdaptToKeyboard() -> some View {
        self.modifier(AdaptToKeyboard())
    }
}


private struct AdaptToKeyboard: ViewModifier {
    @State var offset: CGFloat = 0

    private var keyboardWillShowNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    private var keyboardWillHideNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .padding(.bottom, offset)
                .onReceive(keyboardWillShowNotification) {
                    guard let keyboardheight = ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height,
                          let animation = getAnimation(from: $0) else {
                        return
                    }

                    let screenHeight = UIScreen.main.bounds.height
                    let heightAboveKeyboard = screenHeight - keyboardheight
                    let rect = geo.frame(in: .global)

                    if rect.maxY > heightAboveKeyboard {
                        withAnimation(animation) {
                            offset = rect.maxY - heightAboveKeyboard
                        }
                    }
                }
                .onReceive(keyboardWillHideNotification) {
                    guard let animation = getAnimation(from: $0) else {
                        return
                    }
                    withAnimation(animation) {
                        offset = 0
                    }
                }
        }
    }

    func getAnimation(from notification: Notification) -> Animation? {
        guard let info = notification.userInfo,
              let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
              let uiKitCurve = UIView.AnimationCurve(rawValue: curveValue) else {
            return nil
        }

        let timing = UICubicTimingParameters(animationCurve: uiKitCurve)
        return Animation.timingCurve(
            Double(timing.controlPoint1.x),
            Double(timing.controlPoint1.y),
            Double(timing.controlPoint2.x),
            Double(timing.controlPoint2.y),
            duration: duration
        )
    }
}
