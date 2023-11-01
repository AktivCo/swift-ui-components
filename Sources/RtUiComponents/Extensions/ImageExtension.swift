//
//  ImageExtension.swift
//
//
//  Created by Ivan Poderegin on 01.11.2023.
//

import SwiftUI


public extension Image {
    static func rtImage(name: String) -> UIImage {
        UIImage(named: name, in: .module, compatibleWith: nil) ?? UIImage()
    }
}
