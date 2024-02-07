//
//  RtAlertTitle.swift
//  
//
//  Created by Никита Девятых on 14.11.2023.
//

import SwiftUI


/// Enum of available alert titles
public enum RtAlertTitle {
    case success(String)
    case failure(String)
    case titleOnly(String)

    var content: some View {
        VStack(spacing: 0) {
            switch self {
            case .success(let title):
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.RtColors.rtColorsSystemGreen)
                    .frame(width: 40, height: 40)
                    .padding(.bottom, 8)
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
            case .failure(let title):
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.RtColors.rtColorsSystemRed)
                    .frame(width: 40, height: 40)
                    .padding(.bottom, 8)
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
