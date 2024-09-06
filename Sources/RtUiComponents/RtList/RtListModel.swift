//
//  RtListModel.swift
//
//
//  Created by Vova Badyaev on 26.06.2024.
//

import SwiftUI


/// Protocol describing the minimum required object to be displayed in the RtList
public protocol RtListItem: Identifiable {
    var isDisabled: Bool { get }
}

/// The model for managing the state of the list
/// - Parameters:
///   - items: list of handling items for displaying
///   - idForDelete: Id of the element that is preparing for delete.
///                  This is necessary to toggle the display of the delete button for a single item from the list
///   - contentBuilder: Per-Item content builder
///   - onSelectCallback: Callback for handling press-to-choose action
///   - onDeleteCallback: Callback for handling delete action
public class RtListModel<Item: RtListItem, ItemView: View>: ObservableObject {
    @Published public var items: [Item]
    @Published public var idForDelete: Item.ID?

    let contentBuilder: (Item, Binding<Bool>, Binding<Bool>) -> ItemView
    let listPadding: CGFloat
    public var onSelectCallback: ((Item) -> Void)?
    public var onDeleteCallback: ((Item) -> Void)?

    public init(items: [Item] = [], listPadding: CGFloat = 12, contentBuilder: @escaping (Item, Binding<Bool>, Binding<Bool>) -> ItemView,
                onSelect: @escaping (Item) -> Void, onDelete: @escaping (Item) -> Void) {
        self.items = items
        self.listPadding = listPadding
        self.contentBuilder = contentBuilder
        self.onSelectCallback = onSelect
        self.onDeleteCallback = onDelete
    }
}
