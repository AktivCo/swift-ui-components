//
//  RtContinueButtonState.swift
//
//
//  Created by Vova Badyaev on 20.05.2024.
//

/// Enum of available states of the button
public enum RtContinueButtonState: Equatable {
    case ready
    case inProgress
    case cooldown(UInt)
    case disabled
}
