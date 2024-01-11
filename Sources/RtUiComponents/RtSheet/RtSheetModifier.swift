//
//  RtSheetModifier.swift
//  
//
//  Created by Vova Badyaev on 10.11.2023.
//

import SwiftUI


private struct RtSheetModifier<V: View>: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    @Binding var isPresented: Bool

    @State private var sheetOffset: CGFloat = UIScreen.main.bounds.height
    @State private var screenHeight: CGFloat = UIScreen.main.bounds.height
    @State private var backgroundOpacity: CGFloat = 0
    @State var sheetContent: V?
    @State var parentViewDisabled = false

    @ViewBuilder private let contentBuilder: () -> V

    var showedOffset: CGFloat {
        (screenHeight - size.height) / (UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1)
    }

    private var showedOpacity: CGFloat { colorScheme == .dark ? 0.6 : 0.2 }
    private let delay = 0.5
    private let animation: Animation
    private let size: RtSheetSize
    private let isDraggable: Bool
    private let coordinateSpaceName = "RtSheetSpace"

    private var onDismiss: () -> Void

    public init(isPresented: Binding<Bool>, size: RtSheetSize, isDraggable: Bool,
                _ onDismiss: @escaping () -> Void = {},
                @ViewBuilder content: @escaping () -> V) {
        self._isPresented = isPresented
        self.size = size
        self.isDraggable = isDraggable

        self.animation = Animation.easeInOut(duration: delay)
        self.onDismiss = onDismiss
        self.contentBuilder = content
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.RtColors.rtOtherGrabber)
            .frame(
                width: 36,
                height: 5
            )
    }

    private var dragToCloseGesture: some Gesture {
        DragGesture(coordinateSpace: .named(coordinateSpaceName))
            .onChanged {
                if $0.translation.height > 0 {
                    sheetOffset = $0.translation.height + showedOffset
                }
            }
            .onEnded {
                if $0.translation.height > size.height / 2 {
                    isPresented = false
                } else {
                    open()
                }
            }
    }

    @ViewBuilder
    var sheetOverlay: some View {
        VStack(spacing: 0) {
            if isDraggable {
                self.indicator
                    .padding(.top, 6)
                    .padding(.bottom, 3)
            }
            VStack(spacing: 0) {
                sheetContent
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .allowsHitTesting(!parentViewDisabled)

            Color.black.opacity(backgroundOpacity)
                .onTapGesture {
                    isPresented = false
                }

            sheetOverlay
                .frame(maxWidth: size.width, maxHeight: size.height)
                .background { Color.RtColors.rtSurfaceTertiary }
                .background(.ultraThinMaterial)
                .opacity(sheetContent == nil ? 0 : 1)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .gesture(isDraggable ? dragToCloseGesture : nil)
                .offset(y: sheetOffset)
        }
        .ignoresSafeArea()
        .coordinateSpace(name: coordinateSpaceName)
        .onRotate { _ in
            Task {
                // Give a moment for the screen boundaries to change after the device is rotated
                try await Task.sleep(for: .seconds(0.1))
                await MainActor.run {
                    withAnimation {
                        if sheetOffset == screenHeight {
                            screenHeight = UIScreen.main.bounds.height
                            sheetOffset = screenHeight
                        } else if sheetOffset == showedOffset {
                            screenHeight = UIScreen.main.bounds.height
                            sheetOffset = showedOffset
                        }
                    }
                }
            }
        }
        .onChange(of: sheetOffset) { newValue in
            let percentage = 1 - (newValue - showedOffset) / (screenHeight - showedOffset)
            backgroundOpacity = showedOpacity * percentage
        }
        .onChange(of: isPresented) {
            $0 ? open() : close()
        }
    }

    private func open() {
        parentViewDisabled = true
        sheetContent = contentBuilder()

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
            sheetContent = nil
            parentViewDisabled = false
            isPresented  = false
        }

        UIApplication.endEditing()
        onDismiss()
    }
}

public extension View {
    func rtSheet<V: View>(
        isPresented: Binding<Bool>,
        size: RtSheetSize,
        isDraggable: Bool = true,
        _ onDismiss: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> V
    ) -> some View {
        modifier(
            RtSheetModifier(isPresented: isPresented, size: size, isDraggable: isDraggable,
                            onDismiss, content: content)
        )
    }
}

private struct AnotherView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Another view")
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
    @State private var isPresented = false
    @State var text = "Some error"
    @State var viewBuilder: any View = EmptyView()
    var size: RtSheetSize
    @State var isDraggable: Bool = false

    var body: some View {
        VStack {
            Toggle("Toggle isDraggable", isOn: $isDraggable)
                .frame(width: 150)

            Spacer().frame(height: 50)
            Button("show PinInputView") {
                viewBuilder = PinInputView(errorMessage: $text)
                isPresented.toggle()
            }
            Spacer().frame(height: 50)
            Button("show another sheet") {
                viewBuilder = AnotherView()
                isPresented.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.green
        }
        .rtSheet(isPresented: $isPresented, size: size, isDraggable: isDraggable) {
            AnyView(viewBuilder)
        }
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
