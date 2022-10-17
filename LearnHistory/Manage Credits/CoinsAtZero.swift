//
//  CoinsAtZero.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-09-17.
//

import SwiftUI

struct CoinsAtZero: View {
    @Environment(\.presentationMode) var presentationMode
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var selectedTheme: String
    @Binding var questionSection: QuestionSection
    @Binding var lastQuizSection: QuestionSection
    @Binding var hintButtonIsVisible: Bool
    @Binding var fromNoCoinsView: Bool
    init (selectedTheme: String, questionSection: Binding<QuestionSection>, lastQuizSection: Binding<QuestionSection>, hintButtonIsVisible: Binding<Bool>, fromNoCoinsView: Binding<Bool>){
        self.selectedTheme = selectedTheme
        _questionSection = questionSection
        _lastQuizSection = lastQuizSection
        _hintButtonIsVisible = hintButtonIsVisible
        _fromNoCoinsView = fromNoCoinsView
        
    }
    var body: some View {
        ZStack {
            ColorReference.darkGreen
            VStack {
                Image("H5")
                    .resizable()
                    .frame(width: deviceHeight * 0.1, height: deviceHeight * 0.1, alignment: .center)
                    .padding(.top)
                Text("Learn History")
                    .fontWeight(.bold)
                    .font(.caption)
                    .textCase(.uppercase)
                    .foregroundColor(ColorReference.lightGreen)
                    .multilineTextAlignment(.center)
                Text("There are no coins for hints!")
                    .foregroundColor(ColorReference.lightGreen)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
               
                VStack {
                    Spacer()
                    Button(action:
                            {
                        questionSection = .showCoinMangementView
                        hintButtonIsVisible = false
                        fromNoCoinsView = false
                    
                    },
                           label: {
                        Text("Buy some coins")
                            .fontWeight(.bold)
                            .italic()
                            .textCase(.uppercase)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                    })
                    Spacer()
                    Button(action:
                            {
                        questionSection = lastQuizSection
                        hintButtonIsVisible = true
                        
                    },
                           label: {
                        
                        Text("Back to Quiz")
                            .fontWeight(.bold)
                            .italic()
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.headline)
                    })
                    Spacer()
                }
                .padding()
            }
            
        }
        .navigationBarHidden(true)

        
    }
}


struct CoinsAtZero_Previews: PreviewProvider {

    static var previews: some View {
        CoinsAtZero(selectedTheme: "Rome", questionSection: .constant(.showCoinMangementView), lastQuizSection: .constant(.showCoinMangementView), hintButtonIsVisible: .constant(false), fromNoCoinsView: .constant(true))
    }
}
