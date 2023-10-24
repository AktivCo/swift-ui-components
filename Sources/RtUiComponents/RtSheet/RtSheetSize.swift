//
//  RtSheetSize.swift
//
//
//  Created by Vova Badyaev on 26.10.2023.
//

import Foundation
import UIKit


public enum RtSheetSize {
    case small
    case medium
    case large

    var height: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let screenHeight = UIApplication.shared.screenSize.height
            switch self {
            case .small:
                return screenHeight * 0.5
            case .medium:
                return screenHeight * 0.75
            case .large:
                return screenHeight * 0.9
            }
        } else {
            return 720.0
        }
    }

    var width: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .infinity
        } else {
            return 540.0
        }
    }
}

extension UIApplication {
    public var screenSize: CGRect {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.screen.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
    }
}
