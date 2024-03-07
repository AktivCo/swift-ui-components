//
//  Notification+Keyboard.swift
//
//
//  Created by Vova Badyaev on 07.03.2024.
//

import Foundation
import SwiftUI


extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }

    var keyboardAnimation: Animation? {
        guard let info = self.userInfo,
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
