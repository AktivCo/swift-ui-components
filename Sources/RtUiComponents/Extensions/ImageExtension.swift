//
//  ImageExtension.swift
//
//
//  Created by Ivan Poderegin on 01.11.2023.
//

import SwiftUI


public extension Image {
    /// Returns image from resources by name
    /// - Parameter name: name of the image from resources
    /// - Returns: UIImage related to the name
    static func rtImage(name: String) -> UIImage {
        UIImage(named: name, in: .module, compatibleWith: nil) ?? UIImage()
    }
}
