//
//  RtSizeReader.swift
//
//
//  Created by Vova Badyaev on 14.06.2024.
//

import SwiftUI


public extension View {
    /// Allows to read current size of the view
    /// - Parameter size: Parameter receiving current size
    func rtSizeReader(
        size: Binding<CGSize>
    ) -> some View {
        modifier(
            SizeReaderModifier(size: size)
        )
    }
}

private struct SizeReaderModifier: ViewModifier {
    @Binding var size: CGSize
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { preferences in
                DispatchQueue.main.async {
                    self.size = preferences
                }
            }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: Value = .zero
    static func reduce(value _: inout CGSize, nextValue: () -> CGSize) {}
}
