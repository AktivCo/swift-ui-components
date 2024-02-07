//
//  RtSheetModel.swift
//
//
//  Created by Никита Девятых on 27.12.2023.
//

import SwiftUI


/// The model for managing the state of the sheet
/// - Parameters:
///   - size: Size of the sheet
///   - isDraggable: Determines whether the sheet can be closed with a swipe gesture
///   - content: Content of the sheet
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
