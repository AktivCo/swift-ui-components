//
//  RtSheetModel.swift
//
//
//  Created by Никита Девятых on 27.12.2023.
//

import SwiftUI


public class RtSheetModel: ObservableObject {
    @Published public var isPresented: Bool = false
    @Published public var size: RtSheetSize
    @Published public var isDraggable: Bool
    @Published public var content: AnyView?

    public init(size: RtSheetSize, isDraggable: Bool, content: AnyView? = nil) {
        self.size = size
        self.isDraggable = isDraggable
        self.content = content
    }
}
