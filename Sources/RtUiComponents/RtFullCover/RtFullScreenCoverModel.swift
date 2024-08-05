//
//  RtFullCoverModel.swift
//  
//
//  Created by Vova Badyaev on 05.08.2024.
//

import SwiftUI


/// The model for managing the state of the full cover view
/// - Parameters:
///   - direction: Direction the fullcover comes from
///   - isPresented: A binding to a Boolean value that determines whether to present the full cover view
///   - content: Content of the full cover view
public class RtFullScreenCoverModel: ObservableObject {
    @Published public var direction: RtFullScreenCoverDirection = .right
    @Published public var isPresented: Bool = false
    @Published public var content: AnyView?

    public init(direction: RtFullScreenCoverDirection, content: AnyView? = nil) {
        self.direction = direction
        self.content = content
    }
}
