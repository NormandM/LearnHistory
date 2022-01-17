//
//  TrueOrFalseQuizView.swift
//  FirstQuizTest
//
//  Created by Normand Martin on 2022-01-02.
//

import SwiftUI
import AVFoundation

struct TrueOrFalseQuizView: View {
    @StateObject var questionViewModel = QuestionViewModel()
    @Binding var isCardViewQuiz: Bool
    @Binding var isFlippedLeft: Bool
    @Binding var isFlippedRight: Bool
    var soundPlayer = SoundPlayer.shared
    var soundState: String
    var body: some View {
        VStack{
            Spacer()
            Text(questionViewModel.trueOrFalseQuestion)
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            HStack {
                FlipView(isFlipped: isFlippedRight) {
                    Button{
                        if questionViewModel.trueOrFalseAnswer == "True" {
                            isCardViewQuiz = true
                            soundPlayer.playSound(soundName: "chime_clickbell_octave_up", type: "mp3", soundState: soundState)
                        }else{
                            isFlippedRight = true
                            soundPlayer.playSound(soundName: "etc_error_drum", type: "mp3", soundState: soundState)
                        }
                    }label: {
                        QuizButtonTextModifier(buttonTitle: "True")
                    }
                    .padding()
                    .opacity(isFlippedLeft == true ? 0 : 1)
        
                } back: {
                    ZStack {
                    QuizButtonTextModifier2(title: "")
                            .padding()
                    }
                    
                }
                .animation(.spring(response: 0.7, dampingFraction: 0.7))
                FlipView(isFlipped: isFlippedLeft) {
                    Button{
                        
                        if questionViewModel.trueOrFalseAnswer == "False" {
                            isCardViewQuiz = true
                            soundPlayer.playSound(soundName: "chime_clickbell_octave_up", type: "mp3", soundState: soundState)
                        }else{
                            isFlippedLeft = true
                            soundPlayer.playSound(soundName: "etc_error_drum", type: "mp3", soundState: soundState)
                        }
                        
                    }label: {
                        QuizButtonTextModifier(buttonTitle: "False")
                    }
                    .opacity(isFlippedRight == true ? 0 : 1)
                    .padding()
                } back: {
                    QuizButtonTextModifier2(title: "")
                        .padding()
                }
                .animation(.spring(response: 0.7, dampingFraction: 0.7))
            }
        }
        
    }
}

struct TrueOrFalseQuizView_Previews: PreviewProvider {
    static var previews: some View {
        TrueOrFalseQuizView(isCardViewQuiz: .constant(false), isFlippedLeft: .constant(false), isFlippedRight: .constant(false), soundState: "speaker.slash")
    }
}
