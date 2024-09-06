//
//  RtList.swift
//
//
//  Created by Vova Badyaev on 07.06.2024.
//

import SwiftUI


private struct ListItem<Item: RtListItem, ItemView: View>: View {
    @EnvironmentObject private var model: RtListModel<Item, ItemView>

    let item: Item
    let contentBuilder: (Item, Binding<Bool>, Binding<Bool>) -> ItemView
    let listPadding: CGFloat

    private let maxTranslation = -80.0
    private let delay = 0.24
    private let animation: Animation

    @State private var offset = 0.0
    @State private var contentSize: CGSize = .zero
    @State private var startToDelete: Bool = false
    @State private var isPressed: Bool = false
    @State private var isDisabled: Bool

    init(item: Item, listPadding: CGFloat = 12, contentBuilder: @escaping (Item, Binding<Bool>, Binding<Bool>) -> ItemView) {
        self.item = item
        self.contentBuilder = contentBuilder
        self.animation = .easeInOut(duration: delay)
        self.listPadding = listPadding
        self._isDisabled = State(initialValue: item.isDisabled)
    }

    private var buttonWidth: CGFloat {
        startToDelete ? contentSize.width : 72
    }

    private var buttonOffset: CGFloat {
        8 + buttonWidth + offset
    }

    private var itemHeight: CGFloat {
        startToDelete ? 0 : contentSize.height
    }

    private var opacity: CGFloat {
        startToDelete ? 0.3 : 1
    }

    private var listSpacing: CGFloat {
        startToDelete ? 0 : listPadding
    }

    var deleteButton: some View {
        Button {
            withAnimation(animation) {
                startToDelete.toggle()
                offset = -contentSize.width
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                model.onDeleteCallback?(item)
            }
        } label: {
            Image(systemName: "trash.fill")
                .frame(maxWidth: 20, maxHeight: 72)
                .foregroundStyle(Color.RtColors.rtColorsOnPrimary)
                .frame(maxWidth: buttonWidth, maxHeight: itemHeight)
                .background(Color.RtColors.rtColorsSystemRed)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            deleteButton
                .frame(maxHeight: itemHeight)
                .offset(x: buttonOffset)
            Button {
                if offset == 0.0 {
                    model.idForDelete = nil
                    model.onSelectCallback?(item)
                } else {
                    withAnimation(animation) {
                        offset = 0.0
                    }
                }
            } label: {
                contentBuilder(item, $startToDelete, $isPressed)
                    .rtSizeReader(size: $contentSize)
            }
            .buttonStyle(RtIsPressedButtonStyle(isPressed: $isPressed))
            .disabled(isDisabled)
            .offset(x: offset)
        }
        .frame(maxHeight: itemHeight)
        .opacity(opacity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.bottom, model.items.last?.id == item.id ? 0 : listSpacing)
        .highPriorityGesture(
            DragGesture(minimumDistance: 8, coordinateSpace: .local)
                .onChanged { pos in
                    model.idForDelete = item.id
                    let translation = pos.translation.width
                    withAnimation(animation) {
                        if translation < 0 {
                            offset = max(translation, maxTranslation)
                        }
                    }
                }
                .onEnded {
                    let translation = $0.translation.width
                    withAnimation(animation) {
                        if translation < maxTranslation / 2 {
                            offset = maxTranslation
                        } else {
                            offset = 0
                        }
                    }
                }
        )
        .onDisappear {
            model.idForDelete = nil
            offset = 0
        }
        .onChange(of: item.isDisabled) {
            isDisabled = $0
        }
        .onChange(of: model.idForDelete) {
            guard $0 != item.id else {
                return
            }

            withAnimation(animation) {
                offset = 0
            }
        }
    }
}

/// Presents the list based on RtListModel
/// - Parameter model: Model that determines parameters of the list
public struct RtList<Item: RtListItem, ItemView: View>: View {
    @ObservedObject var model: RtListModel<Item, ItemView>

    public init(listModel: RtListModel<Item, ItemView>) {
        self.model = listModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(model.items, id: \.id) { item in
                ListItem(item: item, listPadding: model.listPadding, contentBuilder: model.contentBuilder)
            }
        }
        .environmentObject(model)
    }
}

struct RtList_Previews: PreviewProvider {
    private struct BankUserInfo: RtListItem {
        let id = UUID().uuidString
        let fullname: String
        let title: String
        let disabled: Bool
        var isDisabled: Bool {
            disabled
        }
    }

    private struct UserListItem: View {
        let user: BankUserInfo
        @Binding var startToDelete: Bool
        @Binding var isPressed: Bool

        var body: some View {
                HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text(user.fullname)
                        .font(.headline)
                        .foregroundStyle(Color.RtColors.rtLabelPrimary)
                    VStack(alignment: .leading, spacing: 8) {
                        infoField(for: "Должность", with: user.title)
                        infoField(for: "Сертификат истекает", with: "01.12.2013")
                    }
                }
                .padding(.all, 12)
                Spacer()
            }
            .frame(maxHeight: startToDelete ? 0 : 152)
            .background(isPressed ? Color.RtColors.rtOtherSelected : Color.RtColors.rtSurfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }

        private func infoField(for title: String, with value: String) -> some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(Color.RtColors.rtLabelSecondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(Color.RtColors.rtLabelPrimary)
            }
        }
    }

    static private let model = RtListModel<BankUserInfo, UserListItem>(
        items: [.init(fullname: "Иванов Никита Романович", title: "Дизайнер", disabled: false),
                .init(fullname: "Иванов Валера Романович", title: "Дизайнер", disabled: false),
                .init(fullname: "Иванов Михаил Романович", title: "Дизайнер", disabled: true)],
        contentBuilder: { user, startToDelete, isPressed in UserListItem(user: user, startToDelete: startToDelete, isPressed: isPressed) },
        onSelect: { _ in },
        onDelete: { _ in })

    static var previews: some View {
        VStack {
            RtList(listModel: model)
            Spacer()
        }
        .padding()
        .background {
            Color.RtColors.rtColorsOnPrimary.ignoresSafeArea()
        }
    }
}
