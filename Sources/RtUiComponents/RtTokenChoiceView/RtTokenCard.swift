//
//  RtTokenCard.swift
//
//
//  Created by Ivan Poderegin on 15.11.2023.
//

import SwiftUI


/// Enum of available types of interactions with token
public enum RtTokenType: CaseIterable {
    case nfc
    case usb
}

extension RtTokenType {
    var title: String {
        switch self {
        case .nfc:
            return "Рутокен с NFC"
        case .usb:
            return "Рутокен с USB"
        }
    }

    var description: String {
        switch self {
        case .nfc:
            return "Поддерживаемые устройства:\nРутокен ЭЦП 3.0 NFC"
        case .usb:
            return "Поддерживаемые устройства:\nРутокен ЭЦП 2.0 и 3.0"
        }
    }

    var icon: Image {
        var result: String

        switch self {
        case .nfc:
            result = "token-twonfc-diagonal"
        case .usb:
            result = "token-usbc-diagonal"
        }

        return Image(uiImage: Image.rtImage(name: result))
    }
}
