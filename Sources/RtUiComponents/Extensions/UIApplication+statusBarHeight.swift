//
//  UIApplication+statusBarHeight.swift
//  
//
//  Created by Никита Девятых on 05.09.2024.
//

import UIKit


extension UIApplication {
    static var statusBarHeight: CGFloat? {
        let scene = shared.connectedScenes.first as? UIWindowScene
        let window = scene?.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height
    }
}
