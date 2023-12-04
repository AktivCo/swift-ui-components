//
//  RtAlertButtonData.swift
//  
//
//  Created by Андрей Трифонов on 2023-12-04.
//

import Foundation


public struct RtAlertButtonData {
    let title: RtAlertButtonTitle
    let action: (() -> Void)?

    public init(_ title: RtAlertButtonTitle, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }
}
