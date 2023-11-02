//
//  RtCopyNotificationModifier.swift
//
//
//  Created by Vova Badyaev on 02.11.2023.
//

import SwiftUI


public struct RtCopyNotificationModifier: ViewModifier {
    @Binding var isPresented: Bool

    private var text: String
    private let animation = Animation.easeInOut(duration: 0.25)

    @State private var tabBarHeight: CGFloat = 0
    @State private var animated = false
    @State private var scale: CGFloat = 0.75
    @State private var opacity: CGFloat = 0

    public init( _ text: String, _ isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.text = text
    }

    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .ignoresSafeArea()
                .onPreferenceChange(RtInnerContentSize.self, perform: { value in
                    guard UIDevice.isPhone else {
                        return
                    }

                    self.tabBarHeight = geometry.size.height - (value.last?.height ?? 0)
                })
                .overlay(
                    VStack {
                        Spacer()
                        RtCopyNotification(with: text)
                            .shadow(color: .RtColors.rtShadow.opacity(0.25), radius: 12, x: 0, y: -1)
                            .scaleEffect(scale)
                            .opacity(opacity)
                            .padding(.bottom, 20 + tabBarHeight)
                    }
                )
        }
        .onChange(of: isPresented) { newValue in
            if newValue {
                withAnimation(animation) {
                    scale = 1.0
                    opacity = 1.0
                }
            } else {
                withAnimation(animation) {
                    scale = 0.75
                    opacity = 0
                }
            }
        }
    }
}

public extension View {
    func rtCopyNotification(
        _ text: String,
        isPresented: Binding<Bool>
    ) -> some View {
        modifier(
            RtCopyNotificationModifier(text, isPresented)
        )
    }
}

private struct ContentView: View {
    enum SomeTab: String, CaseIterable, Identifiable {
        var id: Self { self }

        case dummy
        case anotherDummy
        case withNotification
    }

    enum NotificationType: String, CaseIterable, Identifiable {
        var id: Self { self }

        case phone = "Номер телефона скопирован"
        case link = "Ссылка скопирована"
        case commit = "Commit ID скопирован"
    }

    @State var isPresented: Bool = false
    @State var text = ""

    @State var selectedIphoneTab: SomeTab = .withNotification
    @State var selectedIpadTab: SomeTab?

    var body: some View {
        if UIDevice.isPhone {
            iphoneRootView()
        } else {
            ipadRootView()
        }
    }

    func ipadRootView() -> some View {
        NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
            Text("Рутокен Технологии").font(.largeTitle).fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                .padding(.top, 49)

            List(SomeTab.allCases, id: \.self, selection: $selectedIpadTab) { tab in
                NavigationLink {
                    VStack {
                        Text(tab.rawValue)
                        if tab == .withNotification {
                            ForEach(NotificationType.allCases, id: \.rawValue) { type in
                                Button(type.rawValue) {
                                    showNotification(with: type.rawValue)
                                }
                                .padding()
                            }
                        }
                    }
                } label: {
                    Label( title: { Text(tab.rawValue) }, icon: { Image(systemName: "cat")})
                }
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)

            .toolbar(.hidden, for: .navigationBar)
        } detail: {
            if let selectedIpadTab {
                Text(selectedIpadTab.rawValue)
            }
        }
        .rtCopyNotification(text, isPresented: $isPresented)
        .navigationSplitViewStyle(.balanced)
    }

    func iphoneRootView() -> some View {
        TabView(selection: $selectedIphoneTab) {
            ForEach(SomeTab.allCases, id: \.rawValue) { tab in
                GeometryReader { geometry in
                    VStack {
                        if tab == .withNotification {
                            ForEach(NotificationType.allCases, id: \.rawValue) { type in
                                Button(type.rawValue) {
                                    showNotification(with: type.rawValue)
                                }
                                .padding()
                            }
                        } else {
                            Text(tab.rawValue)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .preference(key: RtInnerContentSize.self, value: [geometry.frame(in: CoordinateSpace.global)])
                }
                .tabItem { Label(tab.rawValue, systemImage: "cat") }
                .tag(tab)
            }
        }
        .rtCopyNotification(text, isPresented: $isPresented)
    }

    func showNotification(with text: String) {
        self.text = text
        isPresented = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            isPresented = false
        }
    }
}

struct RtCopyNotificationModifier_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("RtCopyNotificationModifier")

        ContentView()
            .previewDisplayName("RtCopyNotificationModifier Dark")
            .preferredColorScheme(.dark)
    }
}
