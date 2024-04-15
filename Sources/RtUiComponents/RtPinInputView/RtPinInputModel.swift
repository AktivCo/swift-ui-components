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
    @Published public var inProgress: Bool
    @Published public var pin: String
    @Published public var isContinueButtonDisabled: Bool

    public init(errorDescription: String = "",
                inProgress: Bool = false,
                pin: String,
                isContinueButtonDisabled: Bool = false) {
        self.errorDescription = errorDescription
        self.inProgress = inProgress
        self.pin = pin
        self.isContinueButtonDisabled = isContinueButtonDisabled
    }
}
