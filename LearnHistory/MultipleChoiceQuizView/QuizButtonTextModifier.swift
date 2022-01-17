//
//  ButtonViewModifier.swift
//  FirstQuizTest
//
//  Created by Normand Martin on 2021-11-24.
//

import SwiftUI

struct QuizButtonTextModifier: View {
    var  buttonTitle: String
    var body: some View {
        Text(buttonTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(ColorReference.red)
            .cornerRadius(15)
    }
}
struct QuizButtonTextModifier2: View {
    var title: String
    var body: some View {
        ZStack {
        Text(title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .background(ColorReference.lightGreen)
            .cornerRadius(15)
            Text("X")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
}
struct QuizButtonTextModifier4: View {
    var body: some View {
        Text("")
            .fontWeight(.bold)
            .foregroundColor(ColorReference.lightGreen)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorReference.lightGreen)
            .cornerRadius(15)
    
    }
}
