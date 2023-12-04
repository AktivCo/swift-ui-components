//
//  RtAlertModifier.swift
//
//
//  Created by Никита Девятых on 08.11.2023.
//

import SwiftUI


public extension View {
    func rtAlert(isPresented: Binding<Bool>, alertData: RtAlertModel) -> some View {
        return self.modifier(RtAlertModifier(isPresented: isPresented, title: alertData.title,
                                             subtitle: alertData.subTitle, buttons: alertData.buttons))
    }
}

private struct RtAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    var title: RtAlertTitle
    var subtitle: String?
    var buttons: [RtAlertButtonData]

    public func body(content: Content) -> some View {
        RtAlertView(isShowing: $isPresented, title: title, subTitle: subtitle,
                    buttons: buttons, presentationView: content)
    }
}

private struct AlertContentView: View {
    @State var isAlertShown = false
    @State var alertInfo = RtAlertModel(title: .titleOnly(""), buttons: [])
    var body: some View {
        VStack(spacing: 10) {
            Button("Toggle success alert") {
                alertInfo = RtAlertModel(
                    title: .success("Подпись верна"),
                    buttons: [.init(.regular("ОК"))])
                isAlertShown.toggle()
            }
            Button("Toggle failure alert") {
                alertInfo = RtAlertModel(
                    title: .failure("Подпись неверна"),
                    subTitle: "И не удалось построить цепочку доверия для сертификата",
                    buttons: [.init(.regular("ОК"))])
                isAlertShown.toggle()
            }
            Button("Toggle info alert") {
                isAlertShown.toggle()
                alertInfo = RtAlertModel(
                    title: .titleOnly("Потеряно соединение с Рутокеном"),
                    subTitle: "Повторите подключение и не убирайте Рутокен до завершения обмена данными",
                    buttons: [.init(.bold("ОК"))])
            }
            Button("Toggle many buttons alert") {
                isAlertShown.toggle()
                alertInfo = RtAlertModel(
                    title: .titleOnly("Потеряно соединение с Рутокеном"),
                    subTitle: "Повторите подключение и не убирайте Рутокен до завершения обмена данными",
                    buttons: [.init(.bold("Повторить")),
                              .init(.destructive("Уничтожить")),
                              .init(.regular("Закрыть"))
                    ])
            }
            .padding(.bottom, 300)
        }
        .rtAlert(
            isPresented: $isAlertShown,
            alertData: alertInfo
        )
    }
}

struct RtAlertContentView_Previews: PreviewProvider {
    static var previews: some View {
        AlertContentView()
            .previewDisplayName("RtAlertModifier")

        AlertContentView()
            .previewDisplayName("RtAlertModifier dark")
            .preferredColorScheme(.dark)
    }
}
