//
//  RtListModel.swift
//
//
//  Created by Vova Badyaev on 26.06.2024.
//

import SwiftUI


/// The model for managing the state of the list
/// - Parameters:
///   - items: list of handling items for displaying
///   - contentBuilder: Per-Item content builder
///   - onSelectCallback: Callback for handling press-to-choose action
///   - onDeleteCallback: Callback for handling delete action
public class RtListModel<Item: Identifiable, ItemView: View>: ObservableObject {
    @Published public var items: [Item]

    let contentBuilder: (Item, Binding<Bool>) -> ItemView
    public var onSelectCallback: ((Item) -> Void)?
    public var onDeleteCallback: ((Item) -> Void)?

    public init(items: [Item] = [], contentBuilder: @escaping (Item, Binding<Bool>) -> ItemView,
                onSelect: @escaping (Item) -> Void, onDelete: @escaping (Item) -> Void) {
        self.items = items
        self.contentBuilder = contentBuilder
        self.onSelectCallback = onSelect
        self.onDeleteCallback = onDelete
    }
}
