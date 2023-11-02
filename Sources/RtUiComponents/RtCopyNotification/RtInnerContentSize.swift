//
//  RtInnerContentSize.swift
//
//
//  Created by Vova Badyaev on 03.11.2023.
//

import SwiftUI


public struct RtInnerContentSize: PreferenceKey {
    public typealias Value = [CGRect]
    public static var defaultValue: [CGRect] = []
    public static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}
