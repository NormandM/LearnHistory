//
//  ButtonModifiers.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-01-28.
//

import SwiftUI

struct ArrowButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(ColorReference.darkGreen)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
            )
    }
}
