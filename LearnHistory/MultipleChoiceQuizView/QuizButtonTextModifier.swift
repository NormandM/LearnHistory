//
//  ButtonViewModifier.swift
//  FirstQuizTest
//
//  Created by Normand Martin on 2021-11-24.
//

import SwiftUI

struct QuizButtonTextModifier: View {
    var  buttonTitle: String
    var identifyButtonRightAnswer: Bool
    var body: some View {
        Text(buttonTitle)
            .font(.subheadline)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .foregroundColor(identifyButtonRightAnswer ? .black : .white)
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.bottom)
            .padding(.top)
            .background(identifyButtonRightAnswer ? ColorReference.lightGreen : ColorReference.red)
            .cornerRadius(15)
    }
}
struct QuizButtonTextModifier2: View {
    var title: String
    var hintDemanded: Bool
    var body: some View {
        ZStack {
            Text(title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(ColorReference.lightGreen)
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.bottom)
                .padding(.top)
                .background(ColorReference.lightGreen)
                .cornerRadius(15)
            VStack {
                Text("X")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                if hintDemanded {
                    Text("\(Coins.badAnswer1) coins")
                }else{
                    Text("\(Coins.badAnswer2) coins")
                }
                
            }
            .foregroundColor(.black)
                    
            
        }
    }
}
struct QuizButtonTextModifier3: View {
    var title: String
    var body: some View {
        ZStack {
        Text(title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .foregroundColor(ColorReference.lightGreen)
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.bottom)
            .padding(.top)
            .background(ColorReference.lightGreen)
            .cornerRadius(15)
            VStack {
                Text("X")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("\(Coins.badAnswer2) coins")
            }

        }
    }
}
struct QuizButtonTextModifier4: View {
    var buttonTitles: String
    var body: some View {
        Text(buttonTitles)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .foregroundColor(ColorReference.lightGreen)
            .frame(maxWidth: .infinity)
            .padding()
            .padding(.bottom)
            .padding(.top)
            .background(ColorReference.lightGreen)
            .cornerRadius(15)
    
    }
}
