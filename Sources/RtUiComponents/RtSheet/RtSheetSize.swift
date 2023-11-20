//
//  RtSheetSize.swift
//
//
//  Created by Vova Badyaev on 26.10.2023.
//

import Foundation
import UIKit


public enum RtSheetSize {
    case smallPhone
    case largePhone
    case ipad(width: CGFloat, height: CGFloat)

    var height: CGFloat {
        switch self {
        case .smallPhone:
            return 391
        case .largePhone:
            return 786
        case .ipad(_, let height):
            return height
        }
    }

    var width: CGFloat {
        switch self {
        case .largePhone, .smallPhone:
            return .infinity
        case .ipad(let width, _):
            return width
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
