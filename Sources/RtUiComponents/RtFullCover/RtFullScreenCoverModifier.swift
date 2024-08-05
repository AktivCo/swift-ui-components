//
//  RtFullScreenCoverModifier.swift
//
//
//  Created by Vova Badyaev on 05.08.2024.
//

import SwiftUI


public extension View {
    /// Presents a full cover view based on RtFullScreenCoverModel
    /// - Parameter model: Model that determines parameters of the full cover view
    func rtFullScreenCover(_ model: RtFullScreenCoverModel) -> some View {
        modifier(RtFullScreenCoverModifier(model: model))
    }
}

private struct RtFullScreenCoverModifier: ViewModifier {
    @ObservedObject private var model: RtFullScreenCoverModel

    @State private var coverOffset: CGFloat = 0
    @State private var contentOffset: CGFloat = 0

    @State private var contentShiftOffset: CGFloat = 0
    @State private var coverHideOffset: CGFloat = 0

    @State private var parentViewDisabled = false
    @State private var contentSize: CGSize = .zero

    private let duration = 0.24
    private let animation: Animation

    public init(model: RtFullScreenCoverModel) {
        self.model = model
        self.animation = Animation.easeOut(duration: duration)
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .rtSizeReader(size: $contentSize)
                .offset(x: contentOffset)
                .allowsHitTesting(!parentViewDisabled)

            model.content
                .frame(maxWidth: contentSize.width,
                       maxHeight: contentSize.height)
                .background { Color.RtColors.rtSurfaceTertiary }
                .background(.ultraThinMaterial)
                .offset(x: coverOffset)
        }
        .ignoresSafeArea()
        .onChange(of: model.isPresented) {
            switch model.direction {
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
            parentViewDisabled = false
            model.content = nil
        }

        UIApplication.endEditing()
    }
}

private struct AnotherView: View {
    @StateObject var model = RtFullScreenCoverModel(direction: .left,
                                                    content: AnyView(EmptyView()))
    @State var isRight: Bool = false
    static private var innerViewCounter = 1

    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Another view \(AnotherView.innerViewCounter)")
            Toggle(isOn: $isRight, label: {
                Text("Inner cover direction is from \(isRight ? "right" : "left")")
                    .foregroundColor(Color.RtColors.rtSurfaceTertiary)
            })
            Button("show inner cover sheet") {
                model.direction = isRight ? .right : .left
                model.content = AnyView(AnotherView(onDismiss: {
                    model.isPresented = false
                    AnotherView.innerViewCounter -= 1
                }))
                AnotherView.innerViewCounter += 1
                model.isPresented = true
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
        .rtFullScreenCover(model)
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

private struct RtFullScreenCoverModifierView: View {
    @State var text = "Some error"
    @State var isRight: Bool = false
    @StateObject var model = RtFullScreenCoverModel(direction: .left,
                                                    content: AnyView(EmptyView()))

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
                    model.direction = isRight ? .right : .left
                    model.content = AnyView(TestView(
                        errorMessage: $text,
                        onDismiss: { model.isPresented = false }
                    ))
                    model.isPresented = true
                }
                .padding()
                .background(Color.RtColors.rtColorsSystemBlue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                Spacer().frame(height: 50)
                Button("show another sheet") {
                    model.direction = isRight ? .right : .left
                    model.content = AnyView(AnotherView(onDismiss: { model.isPresented = false }))
                    model.isPresented = true
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
        .rtFullScreenCover(model)
    }
}

struct RtFullScreenCoverModifier_Previews: PreviewProvider {
    static var previews: some View {
        RtFullScreenCoverModifierView()
    }
}
