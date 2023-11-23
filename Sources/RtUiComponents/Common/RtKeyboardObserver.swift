//
//  RtKeyboardObserver.swift
//
//
//  Created by Vova Badyaev on 23.11.2023.
//

import Combine
import UIKit


// This add ability to hide keybaord on demand
extension UIApplication {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class RtKeyboardObserver: ObservableObject {
    @Published var height: CGFloat = 0

    private var cancellable = Set<AnyCancellable>()
    private var keyboardWillShowNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    private var keyboardWillHideNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

    init() {
        keyboardWillShowNotification.map { notification in
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0.0
        }
        .assign(to: \.height, on: self)
        .store(in: &cancellable)

        keyboardWillHideNotification.map { _ in
            0
        }
        .assign(to: \.height, on: self)
        .store(in: &cancellable)
    }
}
