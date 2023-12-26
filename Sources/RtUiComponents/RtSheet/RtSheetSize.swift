//
//  RtSheetSize.swift
//
//
//  Created by Vova Badyaev on 26.10.2023.
//

import Foundation


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
