//
//  UIDevice+isPhone.swift
//
//
//  Created by Vova Badyaev on 08.11.2023.
//

import UIKit


extension UIDevice {
    class var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
