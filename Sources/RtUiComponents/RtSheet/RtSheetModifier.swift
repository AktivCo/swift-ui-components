//
//  RtSheetModifier.swift
//  
//
//  Created by Vova Badyaev on 10.11.2023.
//

import SwiftUI


public struct RtSheetModifier<V: View>: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    @Binding var isPresented: Bool
    @State private var sheetOffset: CGFloat
    @State private var backgroundOpacity: CGFloat = 0
    @State var content: AnyView? = nil
    let viewBuilder: () -> V

    private let screenHeight: CGFloat = UIApplication.shared.screenSize.height
    private let showedOffset: CGFloat
    private var showedOpacity: CGFloat { colorScheme == .dark ? 0.6 : 0.2 }
    private let size: RtSheetSize
    private let coordinateSpaceName = "RtSheetSpace"

    private var closeCallback: () -> Void

    public init(isPresented: Binding<Bool>, size: RtSheetSize,
                @ViewBuilder viewBuilder: @escaping () -> V,
                _ closeCallback: @escaping () -> Void) {
        self._isPresented = isPresented
        self.size = size
        self._sheetOffset = State(initialValue: screenHeight)
        self.showedOffset = (screenHeight - size.height) / (UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1)
        self.viewBuilder = viewBuilder
        self.closeCallback = closeCallback
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
                if $0.translation.height > size.height / 3 {
                    isPresented = false
                } else {
                    open()
                }
            }
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            Color.black.opacity(backgroundOpacity)
                .onTapGesture {
                    close()
                }
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.RtColors.rtSurfaceTertiary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack(alignment: .center, spacing: 0) {
                    self.indicator
                        .padding(.top, 6)
                        .padding(.bottom, 3)
                    self.content
                }
            }
            .frame(maxWidth: size.width, maxHeight: size.height)
            .gesture(dragToCloseGesture)
            .offset(y: sheetOffset)
            .coordinateSpace(name: coordinateSpaceName)
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
        content = AnyView(viewBuilder())
        withAnimation(.interpolatingSpring(stiffness: 222, damping: 28)) {
            sheetOffset = showedOffset
            backgroundOpacity = showedOpacity
        }
    }
    
    private func close() {
        withAnimation(.interpolatingSpring(stiffness: 222, damping: 28)) {
            sheetOffset = screenHeight
            backgroundOpacity = 0
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
            // This is needed to reset content after sheet is closed
            content = nil
            isPresented = false
        }
        closeCallback()
    }
}

public extension View {
    func rtSheet<V: View>(
        isPresented: Binding<Bool>,
        size: RtSheetSize,
        @ViewBuilder viewBuilder: @escaping () -> V,
        _ closeCallback: @escaping () -> Void = {}
    ) -> some View {
        modifier(
            RtSheetModifier(isPresented: isPresented,
                            size: size,
                            viewBuilder: viewBuilder, closeCallback)
        )
    }
}

fileprivate struct AnotherView: View {
    public var body: some View {
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

fileprivate struct PinInputView: View {
    @Binding var errorMessage: String

    public var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                NavigationLink(destination: {
                    Text("This is screen number 1")
                }) {
                    Text("Go to screen 1")
                }
                Spacer().frame(height: 50)
                NavigationLink(destination: {
                    Text("This is screen number 2")
                }) {
                    Text("Go to screen 2")
                }
                Spacer().frame(height: 30)
                TextField("pin", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.red
            }
        }
        .frame(maxHeight: 400)
    }
}

fileprivate struct RtSheetModifierView: View {
    @State private var customIsPresented = false
    @State private var systemIsPresented = false
    @State var text = "Some error"
    var size: RtSheetSize
    @State var viewBuilder: any View = EmptyView()

    var body: some View {
        VStack {
            Button("show PinInputView") {
                viewBuilder = PinInputView(errorMessage: $text)
                customIsPresented.toggle()
            }
            Spacer().frame(height: 50)
            Button("show another sheet") {
                viewBuilder = AnotherView()
                customIsPresented.toggle()
            }
            Spacer().frame(height: 50)
            Button("show system sheet") {
                viewBuilder = AnotherView()
                systemIsPresented.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.green
        }
        .rtSheet(isPresented: $customIsPresented, size: size) {
            AnyView(viewBuilder)
        }
        .sheet(isPresented: $systemIsPresented, content: {
            AnotherView()
        })
        .ignoresSafeArea()
    }
}

struct RtSheetModifier_Previews: PreviewProvider {
    static var previews: some View {
        RtSheetModifierView(size: .large)
            .previewDisplayName("Large")
        RtSheetModifierView(size: .medium)
            .previewDisplayName("Medium")
        RtSheetModifierView(size: .small)
            .previewDisplayName("Small")
    }
}
