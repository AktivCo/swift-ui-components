//
//  RtAlertModel.swift
//
//
//  Created by Никита Девятых on 14.11.2023.
//

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
