//
//  RtSheetModifier.swift
//  
//
//  Created by Vova Badyaev on 10.11.2023.
//

import SwiftUI


private struct RtSheetModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    @ObservedObject private var sheetModel: RtSheetModel

    @State private var sheetOffset: CGFloat = UIScreen.main.bounds.height
    @State private var backgroundOpacity: CGFloat = 0
    @State private var parentViewDisabled = false

    @State private var screenHeight: CGFloat = UIScreen.main.bounds.height
    private var showedOffset: CGFloat {
        (screenHeight - sheetModel.size.height) / (UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1)
    }

    private var showedOpacity: CGFloat { colorScheme == .dark ? 0.6 : 0.2 }
    private let delay = 0.5
    private let animation: Animation
    private let coordinateSpaceName = "RtSheetSpace"

    public init(sheetModel: RtSheetModel) {
        self.sheetModel = sheetModel
        self.animation = Animation.easeInOut(duration: delay)
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.RtColors.rtOtherGrabber)
            .frame(width: 36, height: 5)
    }

    private var dragToCloseGesture: some Gesture {
        DragGesture(coordinateSpace: .named(coordinateSpaceName))
            .onChanged {
                if $0.translation.height > 0 {
                    sheetOffset = $0.translation.height + showedOffset
                }
            }
            .onEnded {
                if $0.translation.height > sheetModel.size.height / 2 {
                    sheetModel.isPresented = false
                } else {
                    if sheetModel.isPresented {
                        open()
                    }
                }
            }
    }

    @ViewBuilder
    var sheetOverlay: some View {
        VStack(spacing: 0) {
            if sheetModel.isDraggable {
                self.indicator
                    .padding(.top, 6)
                    .padding(.bottom, 3)
            }
            sheetModel.content
                .frame(maxWidth: .infinity, maxHeight: sheetModel.size.height)
        }
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .allowsHitTesting(!parentViewDisabled)

            Color.black.opacity(backgroundOpacity)
                .onTapGesture {
                    if sheetModel.isDraggable {
                        sheetModel.isPresented = false
                    }
                }

            sheetOverlay
                .frame(maxWidth: sheetModel.size.width,
                       maxHeight: sheetModel.size.height,
                       alignment: .top)
                .background { Color.RtColors.rtSurfaceTertiary }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .gesture(sheetModel.isDraggable ? dragToCloseGesture : nil)
                .offset(y: sheetOffset)
        }
        .ignoresSafeArea()
        .coordinateSpace(name: coordinateSpaceName)
        .onChange(of: sheetOffset) { newValue in
            let percentage = 1 - (newValue - showedOffset) / (screenHeight - showedOffset)
            backgroundOpacity = showedOpacity * percentage
        }
        .onChange(of: sheetModel.isPresented) {
            $0 ? open() : close()
        }
    }

    private func open() {
        parentViewDisabled = true
        Task {
            withAnimation(animation) {
                sheetOffset = showedOffset
                backgroundOpacity = showedOpacity
            }
        }
    }

    private func close() {
        Task {
            withAnimation(animation) {
                sheetOffset = screenHeight
                backgroundOpacity = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            parentViewDisabled = false
            sheetModel.content = nil
        }

        UIApplication.endEditing()
    }
}

public extension View {
    func rtSheet(
        sheetModel: RtSheetModel
    ) -> some View {
        modifier(
            RtSheetModifier(sheetModel: sheetModel)
        )
    }
}

private struct AnotherView: View {
    let onDismiss: () -> Void
    var body: some View {
        VStack {
            Spacer()
            Text("Another view")
            Button {
                onDismiss()
            } label: {
               Text("Close sheet")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .background {
            Color.red
        }
    }
}

private struct PinInputView: View {
    @Binding var errorMessage: String
    @State var text = "some text"
    let onDismiss: (() -> Void)
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.gray
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    NavigationLink(destination: { Text("This is screen number 1") }, label: { Text("Go to screen 1") })
                    Spacer()
                    NavigationLink(destination: { Text("This is screen number 2") }, label: {
                        Text("Go to screen 2") })
                    Spacer()
                    Button("Close sheet") {
                        onDismiss()
                    }
                    Spacer()
                    Button(text) {
                        text = "text has changed"
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background {
                    Color.red
                }
            }
        }
    }
}

private struct RtSheetModifierView: View {
    @State var text = "Some error"
    var size: RtSheetSize
    @State var isDraggable: Bool = false
    @StateObject var sheetModel = RtSheetModel(size: .largePhone, isDraggable: true, content: AnyView(EmptyView()))

    var body: some View {
        VStack {
            Toggle("Toggle isDraggable", isOn: $isDraggable)
                .frame(width: 150)

            Spacer().frame(height: 50)
            Button("show PinInputView") {
                sheetModel.isDraggable = isDraggable
                sheetModel.size = size
                sheetModel.content = AnyView(PinInputView(
                    errorMessage: $text,
                    onDismiss: { sheetModel.isPresented = false }
                ))
                sheetModel.isPresented = true
            }
            Spacer().frame(height: 50)
            Button("show another sheet") {
                sheetModel.isDraggable = isDraggable
                sheetModel.size = size
                sheetModel.content = AnyView(AnotherView(
                    onDismiss: { sheetModel.isPresented = false }))
                sheetModel.isPresented = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.green
        }
        .rtSheet(sheetModel: sheetModel)
        .ignoresSafeArea()
    }
}

struct RtSheetModifier_Previews: PreviewProvider {
    static var previews: some View {
        RtSheetModifierView(size: UIDevice.current.userInterfaceIdiom == .pad ? .ipad(width: 540, height: 720) : .largePhone)
            .previewDisplayName("Large")
        RtSheetModifierView(size: UIDevice.current.userInterfaceIdiom == .pad ? .ipad(width: 540, height: 720) : .smallPhone)
            .previewDisplayName("Small")
        RtSheetModifierView(size: .ipad(width: 540, height: 720))
            .previewDisplayName("Ipad")
            .previewDevice(PreviewDevice(rawValue: "iPad 11-inch"))
    }
}
