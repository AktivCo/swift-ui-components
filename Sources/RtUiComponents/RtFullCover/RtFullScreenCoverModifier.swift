//
//  RtFullScreenCoverModifier.swift
//
//
//  Created by Vova Badyaev on 05.08.2024.
//

import SwiftUI


public extension View {
    /// Presents a full cover view based on RtFullScreenCoverModel
    /// - Parameters:
    ///   - isPresented: Binding that determines if the full cover view is presented
    ///   - direction: The direction from which the full cover view will appear
    ///   - content: The content closure that provides the view to be displayed in full screen
    func rtFullScreenCover(
        direction: RtFullScreenCoverDirection = .right,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        content: @escaping () -> AnyView
    ) -> some View {
        modifier(
            RtFullScreenCoverModifier(
                isPresented: isPresented,
                direction: direction,
                onDismiss: onDismiss,
                content: content
            )
        )
    }
}

private struct RtFullScreenCoverModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let direction: RtFullScreenCoverDirection
    private let onDismiss: (() -> Void)?

    private let contentBuilder: () -> AnyView
    @State private var content: AnyView

    @State private var coverOffset: CGFloat
    @State private var contentOffset: CGFloat = 0

    @State private var contentShiftOffset: CGFloat = 0
    @State private var coverHideOffset: CGFloat = 0

    @State private var parentViewDisabled = false
    @State private var contentSize: CGSize = .zero

    private let duration = 0.24
    private let animation: Animation

    public init(
        isPresented: Binding<Bool>,
        direction: RtFullScreenCoverDirection,
        onDismiss: (() -> Void)?,
        content: @escaping () -> AnyView) {
            _isPresented = isPresented
            self.direction = direction
            self.onDismiss = onDismiss

            self.contentBuilder = content
            self.content = AnyView(content())

            self.animation = Animation.easeOut(duration: duration)
            self.coverOffset = isPresented.wrappedValue ? 0 : UIScreen.main.bounds.width
        }

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .rtSizeReader(size: $contentSize)
                .offset(x: contentOffset)
                .allowsHitTesting(!parentViewDisabled)

            self.content
                .frame(maxWidth: contentSize.width,
                       maxHeight: contentSize.height)
                .background { Color.RtColors.rtSurfaceTertiary }
                .background(.ultraThinMaterial)
                .offset(x: coverOffset)
        }
        .ignoresSafeArea()
        .onChange(of: isPresented) {
            switch direction {
            case .right:
                coverHideOffset = contentSize.width
                contentShiftOffset = -contentSize.width / 4
            case .left:
                coverHideOffset = -contentSize.width
                contentShiftOffset = contentSize.width / 4
            }
            if $0 { open() } else { close() }
        }
    }

    private func open() {
        content = AnyView(contentBuilder())
        parentViewDisabled = true
        coverOffset = coverHideOffset

        withAnimation(animation) {
            contentOffset = contentShiftOffset
            coverOffset = 0
        }
    }

    private func close() {
        contentOffset = contentShiftOffset

        withAnimation(animation) {
            contentOffset = 0
            coverOffset = coverHideOffset
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            content = AnyView(EmptyView())
            parentViewDisabled = false
            onDismiss?()
        }

        UIApplication.endEditing()
    }
}

private struct AnotherTestView: View {
    @State private var content = AnyView(EmptyView())
    @State var isPresented: Bool = false

    @State var isRight: Bool = false
    static private var innerViewCounter = 1

    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Another view \(AnotherTestView.innerViewCounter)")
            Toggle(isOn: $isRight, label: {
                Text("Inner cover direction is from \(isRight ? "right" : "left")")
                    .foregroundColor(Color.RtColors.rtSurfaceTertiary)
            })
            Button("show inner cover sheet") {
                content = AnyView(AnotherTestView(onDismiss: {
                    isPresented = false
                    AnotherTestView.innerViewCounter -= 1
                }))
                AnotherTestView.innerViewCounter += 1
                isPresented = true
            }
            .padding()
            .foregroundColor(Color.RtColors.rtSurfaceTertiary)
            .background(Color.RtColors.rtColorsSystemBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Button {
                onDismiss()
            } label: {
               Text("Close sheet")
                    .foregroundColor(Color.RtColors.rtSurfaceTertiary)
            }
            .padding()
            .background(Color.RtColors.rtColorsSystemBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 200)
        .rtFullScreenCover(direction: isRight ? .right : .left, isPresented: $isPresented) {
            content
        }
        .background {
            Color.gray
        }
    }
}

private struct TestView: View {
    @Binding var errorMessage: String
    @State var text = "some text"
    let onDismiss: (() -> Void)
    var body: some View {
        VStack {
            Spacer()
            Button("Close sheet") {
                onDismiss()
            }
            .foregroundColor(Color.RtColors.rtLabelPrimary)
            .padding()
            .background(Color.RtColors.rtColorsSystemBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
                .frame(height: 100)
            Button(text) {
                text = "text has changed"
            }
            .foregroundColor(Color.RtColors.rtLabelPrimary)
            .padding()
            .background(Color.RtColors.rtColorsSystemBlue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.RtColors.rtSurfaceSecondary
        }
    }
}

private struct MainTestView: View {
    @State var text = "Some error"
    @State var isRight: Bool = false

    @State var isPresented: Bool = false
    @State private var content: AnyView = AnyView(EmptyView())

    var body: some View {
        TabView {
            VStack {
                Toggle(isOn: $isRight, label: {
                    Text("Full cover direction is from \(isRight ? "right" : "left")")
                        .foregroundColor(Color.RtColors.rtSurfaceTertiary)
                })
                .frame(width: 150)

                Spacer().frame(height: 50)
                Button("show PinInputView") {
                    content = AnyView(TestView(
                        errorMessage: $text,
                        onDismiss: { isPresented = false }
                    ))
                    isPresented = true
                }
                .padding()
                .background(Color.RtColors.rtColorsSystemBlue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                Spacer().frame(height: 50)
                Button("show another sheet") {
                    content = AnyView(AnotherTestView(onDismiss: { isPresented = false }))
                    isPresented = true
                }
                .padding()
                .background(Color.RtColors.rtColorsSystemBlue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.RtColors.rtLabelPrimary
            }
            .ignoresSafeArea()
            .tabItem {
                Label("Menu", systemImage: "list.dash")
            }
        }
        .accentColor(Color.RtColors.rtSurfaceTertiary)
        .rtFullScreenCover(direction: isRight ? .right : .left, isPresented: $isPresented) {
            content
        }
    }
}

struct RtFullScreenCoverModifier_Previews: PreviewProvider {
    static var previews: some View {
        MainTestView()
    }
}
