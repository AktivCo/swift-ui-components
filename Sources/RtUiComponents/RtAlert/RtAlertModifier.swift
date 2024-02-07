//
//  RtAlertModifier.swift
//
//
//  Created by Никита Девятых on 08.11.2023.
//

import SwiftUI


public extension View {
    /// Presents an alert based on RtAlertModel
    /// - Parameter alertModel: A binding to a RtAlertModel optional that determines whether to present the alert
    /// that is described in the model
    func rtAlert(alertModel: Binding<RtAlertModel?>) -> some View {
        return self.modifier(RtAlertModifier(alertModel: alertModel))
    }
}

private struct RtAlertModifier: ViewModifier {
    @Binding var alertModel: RtAlertModel?

    public func body(content: Content) -> some View {
        RtAlertView(alertModel: $alertModel, presentationView: content)
    }
}

private struct AlertContentView: View {
    @State var alertInfo: RtAlertModel?
    var body: some View {
        VStack(spacing: 10) {
            Button("Toggle success alert") {
                alertInfo = RtAlertModel(
                    title: .success("Подпись верна"),
                    buttons: [.init(.regular("ОК"))])
            }
            Button("Toggle failure alert") {
                alertInfo = RtAlertModel(
                    title: .failure("Подпись неверна"),
                    subTitle: "И не удалось построить цепочку доверия для сертификата",
                    buttons: [.init(.regular("ОК"))])
            }
            Button("Toggle info alert") {
                alertInfo = RtAlertModel(
                    title: .titleOnly("Потеряно соединение с Рутокеном"),
                    subTitle: "Повторите подключение и не убирайте Рутокен до завершения обмена данными",
                    buttons: [.init(.bold("ОК"))])
            }
            Button("Toggle many buttons alert") {
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
        .rtAlert(alertModel: $alertInfo)
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
