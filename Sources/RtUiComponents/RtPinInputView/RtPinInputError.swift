//
//  RtPinInputError.swift
//  
//
//  Created by Андрей Трифонов on 2023-12-05.
//

import Foundation


public class RtPinInputError: ObservableObject {
    @Published public var errorDescription: String

    public init(errorDescription: String = "") {
        self.errorDescription = errorDescription
    }
}
