//
//  RtPinInputModel.swift
//  
//
//  Created by Андрей Трифонов on 2023-12-05.
//

import Foundation


/// Object that handles possible states of RtPinInputView
public class RtPinInputModel: ObservableObject {
    @Published public var errorDescription: String
    @Published public var pin: String
    @Published public var buttonState: RtContinueButtonState

    public init(errorDescription: String = "",
                inProgress: Bool = false,
                pin: String,
                buttonState: RtContinueButtonState = .ready) {
        self.errorDescription = errorDescription
        self.pin = pin
        self.buttonState = buttonState
    }
}
