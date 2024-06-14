//
//  RtList.swift
//
//
//  Created by Vova Badyaev on 07.06.2024.
//

import SwiftUI


private struct ListItem<Item: Identifiable, ItemView: View>: View {
    @EnvironmentObject private var model: RtListModel<Item, ItemView>

    let item: Item
    let contentBuilder: (Item, Binding<Bool>) -> ItemView

    private let maxTranslation = -80.0
    private let delay = 0.240

    @State private var offset = 0.0
    @State private var contentSize: CGSize = .zero
    @State private var startToClose: Bool = false

    private var buttonWidth: CGFloat {
        startToClose ? contentSize.width : 72
    }

    private var itemHeight: CGFloat {
        startToClose ? 0 : contentSize.height
    }

    private var opacity: CGFloat {
        startToClose ? 0.3 : 1
    }

    private var listSpacing: CGFloat {
        startToClose ? 0 : 12
    }

    var deleteButton: some View {
        Button {
            withAnimation(.easeInOut(duration: delay)) {
                startToClose.toggle()
                offset = -contentSize.width
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                model.onDeleteCallback?(item)
            }
        } label: {
            VStack {
                Image(systemName: "trash.fill")
                    .foregroundStyle(Color.RtColors.rtColorsOnPrimary)
                    .frame(maxWidth: buttonWidth, maxHeight: itemHeight)
            }
            .background(Color.RtColors.rtColorsSystemRed)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            deleteButton
                .frame(maxHeight: itemHeight)
            contentBuilder(item, $startToClose)
                .rtSizeReader(size: $contentSize)
                .onTapGesture {
                    if offset == 0.0 {
                        model.onSelectCallback?(item)
                    } else {
                        withAnimation(.easeInOut(duration: delay)) {
                            offset = 0.0
                        }
                    }
                }
                .offset(x: offset)
                .gesture(
                    DragGesture(minimumDistance: 8, coordinateSpace: .local)
                        .onChanged {
                            let translation = $0.translation.width
                            withAnimation {
                                if translation < 0 {
                                    offset = max(translation, maxTranslation)
                                } else {
                                    offset = 0
                                }
                            }
                        }
                        .onEnded {
                            let translation = $0.translation.width
                            withAnimation {
                                if translation < maxTranslation / 2 {
                                    offset = maxTranslation
                                } else {
                                    offset = 0
                                }
                            }
                        }
                )
        }
        .frame(maxHeight: itemHeight)
        .opacity(opacity)
        .padding(.bottom, model.items.last?.id == item.id ? 0 : listSpacing)
    }
}

/// Presents the list based on RtListModel
/// - Parameter model: Model that determines parameters of the list
public struct RtList<Item: Identifiable, ItemView: View>: View {
    @ObservedObject var model: RtListModel<Item, ItemView>

    public init(listModel: RtListModel<Item, ItemView>) {
        self.model = listModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(model.items, id: \.id) { item in
                ListItem(item: item, contentBuilder: model.contentBuilder)
            }
        }
        .environmentObject(model)
    }
}

struct RtList_Previews: PreviewProvider {
    private struct BankUserInfo: Identifiable {
        let id = UUID().uuidString
        let fullname: String
        let title: String
    }

    private struct UserListItem: View {
        let user: BankUserInfo
        @Binding var startToClose: Bool

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
            .frame(maxHeight: startToClose ? 0 : 152)
            .background(Color.RtColors.rtColorsSecondary)
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
        items: [.init(fullname: "Иванов Михаил Романович", title: "Дизайнер"),
                .init(fullname: "Иванов Михаил Романович", title: "Дизайнер"),
                .init(fullname: "Иванов Михаил Романович", title: "Дизайнер")],
        contentBuilder: { user, startToClose in UserListItem(user: user, startToClose: startToClose) },
        onSelect: {_ in},
        onDelete: {_ in})

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
