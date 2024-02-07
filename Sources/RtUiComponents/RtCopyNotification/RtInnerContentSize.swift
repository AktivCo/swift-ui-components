//
//  RtInnerContentSize.swift
//
//
//  Created by Vova Badyaev on 03.11.2023.
//

import SwiftUI


/// Helper struct for handling showing of the copy notification above tabbar
public struct RtInnerContentSize: PreferenceKey {
    public typealias Value = [CGRect]
    public static var defaultValue: [CGRect] = []
    public static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}
