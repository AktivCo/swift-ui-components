//
//  RtAlertTitle.swift
//  
//
//  Created by Никита Девятых on 14.11.2023.
//

import SwiftUI


public enum RtAlertTitle {
    case success(String)
    case failure(String)
    case titleOnly(String)

    var content: some View {
        VStack {
            switch self {
            case .success(let title):
                Image("checkmark", bundle: .module)
                    .padding(.bottom, 4)
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
            case .failure(let title):
                Image("xmark", bundle: .module)
                    .padding(.bottom, 4)
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
            case .titleOnly(let title):
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
            }
        }
    }
}
