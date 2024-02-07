//
//  RtAlertButtonData.swift
//  
//
//  Created by Андрей Трифонов on 2023-12-04.
//

import Foundation


/// The model for managing the buttons of the alert
/// - Parameters:
///   - title: Title of the button
///   - action: Callback called in addition to closing the alert
public struct RtAlertButtonData {
    let title: RtAlertButtonTitle
    let action: (() -> Void)?

    public init(_ title: RtAlertButtonTitle, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }
}
