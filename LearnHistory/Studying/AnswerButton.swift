//
//  AnswerButton.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-03-12.
//

import SwiftUI

struct AnswerButton: View {
    @Binding var question: String
    var showAnswer: () -> Void
    var fontWeight: Font.Weight?
    @Binding var answerButtonPressed: Bool
    var body: some View {
        Button{
            showAnswer()
            answerButtonPressed = true
        }label: {
            Text(question)
                .font(answerButtonPressed ? .headline : .body)
                .fontWeight(.bold)
                .foregroundColor(answerButtonPressed ? .black : .white)
        }
        .disabled(answerButtonPressed)
    }
}

//struct AnswerButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AnswerButton(question: <#Binding<String>#>, showAnswer: <#() -> Void#>)
//    }
//}
