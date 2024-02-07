//
//  RtAlertModel.swift
//
//
//  Created by Никита Девятых on 14.11.2023.
//

/// The model for managing the state of the alert
/// - Parameters:
///   - title: Title of the alert
///   - subTitle: Subtitle of the alert
///   - buttons: Array of button's data
public struct RtAlertModel {
    let title: RtAlertTitle
    let subTitle: String?
    let buttons: [RtAlertButtonData]

    public init(title: RtAlertTitle, subTitle: String? = nil, buttons: [RtAlertButtonData]) {
        self.title = title
        self.subTitle = subTitle
        self.buttons = buttons
    }
}
