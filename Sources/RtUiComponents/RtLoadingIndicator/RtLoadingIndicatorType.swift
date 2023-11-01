//
//  RtLoadingIndicatorType.swift
//
//
//  Created by Никита Девятых on 01.11.2023.
//

import SwiftUI


public enum RtLoadingIndicatorType {
    case big
    case small

    var lineWidth: Double {
        switch self {
        case .big:
            return 3
        case .small:
            return 2
        }
    }

    var innerColor: Color {
        switch self {
        case .big:
            return .RtColors.rtColorsSecondary
        case .small:
            return .white
        }
    }

    var outerColor: Color {
        switch self {
        case .big:
            return .RtColors.rtColorsPrimary100
        case .small:
            return .white
        }
    }

    var animation: Animation {
        return Animation.linear(duration: 1.8).repeatForever(autoreverses: false)
    }

    var trim: Double {
        return 0.85
    }

    var ratio: Double {
        return 2
    }

    var size: Double {
        switch self {
        case .big:
            return 48
        case .small:
            return 20
        }
    }
}
