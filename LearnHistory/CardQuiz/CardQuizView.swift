//
//  ContentView.swift
//  NewHistoryCards
//
//  Created by Normand Martin on 2021-11-28.
//

import SwiftUI
import AVFoundation

struct CardQuizView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var cardFlipped = [false,
                            false, false]
    @StateObject var questionViewModel = QuestionViewModel()
    @StateObject var cardSequence = CardSequence()
    @State private var cardFramesTop = [CGRect](repeating: .zero, count: 3)
    @State private var cardFramesBottom = [CGRect](repeating: .zero, count: 3)
    @State private var dateTextArray = ["test1\nTest1", "test\ntest2", "test3\ntest3"]
    @State private var clearColor = false
    @State private var cardIsDropped = false
    @State private var answerIsGood = false
    @State private var questionSection = QuestionSection.trueOrFalseQuestionDisplayed
    var soundPlayer = SoundPlayer.shared
    @State private var soundState = "speaker.slash"
    
    var body: some View {
        GeometryReader { geo in
        VStack {
            WiKiView(wikiSearch: questionViewModel.wikiSearchWord, questionSection: questionSection)
                .frame(width: geo.size.width, height: geo.size.height * 0.3, alignment: .center)
                .border(.red, width: 2)
            HStack{
                ForEach(0..<3){cardIndex in
                    VStack{
                        FlipView(isFlipped: cardFlipped[cardIndex]){
                        Card(clearColor: cardColor(cardIndex: cardIndex), cardText: upperCardText(cardIndex: cardIndex).0, index: cardIndex, fontColorIsClear: upperCardText(cardIndex: cardIndex).1)
                            .aspectRatio(2/3, contentMode: .fit)
                            .overlay(GeometryReader { geo in
                                if cardIndex == 0 || cardIndex == 2 {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 2)
                                        .opacity(cardIsDropped ? 0 : 1)

                                }
                                Color.clear
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                            self.cardFramesTop[cardIndex] = geo.frame(in: .global)
                                        }
                                    }
                            })
                            .allowsHitTesting(false)
                    } back: {
                        CardBack()
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                    .animation(answerIsGood ? nil : .spring(response: 0.7, dampingFraction: 0.7))
                            Text(dateTextArray[cardIndex])
                                .foregroundColor(.white)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .opacity(cardIsDropped ? 1.0 : 0.0)
                                .border(.white, width: 2)
                    }
                }
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
            .border(.blue, width: 2)
            HStack{
                ForEach(0..<3){cardIndex in
                    Card(clearColor: clearColor, cardText: lowerCardText(cardIndex: cardIndex), index: cardIndex, fontColorIsClear: false, onEnded: cardDropped)
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay(GeometryReader { geo in
                            Color.clear
                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                        self.cardFramesBottom[cardIndex] = geo.frame(in: .global)
                                    }
                                }
                        })
                        .opacity(cardIndex == 0 || cardIndex == 2 ? 0.0 : 1.0)
                        .opacity(cardIsDropped ? 0.0 : 1.0)
                }
            }
            .padding(.leading, 5)
            .padding(.trailing, 5)
            .border(.white, width: 2)
            
            Button{
                cardIsDropped = false
                self.presentationMode.wrappedValue.dismiss()
            }label: {
                Text("Next")
            }
            .padding()
        }
        .navigationTitle("Before or After")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    }
    
    // MARK: FUNCTIONS
    func cardColor(cardIndex: Int) -> Bool{
        switch cardIndex{
        case 0:
            if cardIsDropped && cardSequence.cardResponseIsLeft && answerIsGood{
                return false
            }else if cardIsDropped && !cardSequence.cardResponseIsLeft && !answerIsGood{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    cardFlipped[cardIndex] = true
                }
                return false
            }else{
               return true
            }
        case 1:
            return false
        case 2:
            if cardIsDropped && !cardSequence.cardResponseIsLeft && answerIsGood{
                return false
            }else if cardIsDropped && cardSequence.cardResponseIsLeft  && !answerIsGood{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                cardFlipped[cardIndex] = true
                }
                return false
                
            }else{
               return true
            }
        default:
            return false
        }
    }
    func upperCardText(cardIndex: Int) -> (String, Bool) {
        switch cardIndex {
        case 0:
            if cardIsDropped {
                if cardSequence.cardResponseIsLeft && answerIsGood{
                    return (cardSequence.bottomCard, false)
                }else{
                    return ("", true)
                }
            }else{
                return ("", true)
            }
        case 1:
            return (cardSequence.upperCard, false)
        case 2:
            if cardIsDropped {
                if !cardSequence.cardResponseIsLeft && answerIsGood{
                    return (cardSequence.bottomCard, false)
                }else{
                    return ("", true)
                }
            }else{
                return ("", true)
            }
        default:
            return ("", true)
        }
    }
    func lowerCardText(cardIndex: Int) -> String{
        switch cardIndex {
        case 0:
            return ""
        case 1:
            return cardSequence.bottomCard
        case 2:
            return ""
        default:
            return ""
        }
        
    }
    func cardDropped(location: CGPoint, cardIndex: Int,  event: String){
        if let match = cardFramesTop.firstIndex(where: {
            $0.contains(location)}){
            cardIsDropped = true
            if match == 0 {
                if cardSequence.cardResponseIsLeft{
                    answerIsGood = true
                    dateTextArray = [cardSequence.cardDateLowerCard, cardSequence.cardDateUpperCar, ""]
                    soundPlayer.playSound(soundName: "chime_clickbell_octave_up", type: "mp3", soundState: soundState)

                }else{
                    dateTextArray = ["", "", ""]
                    answerIsGood = false
                    soundPlayer.playSound(soundName: "etc_error_drum", type: "mp3", soundState: soundState)
                }
            }else if match == 2{
                if !cardSequence.cardResponseIsLeft{
                    answerIsGood = true
                    dateTextArray = ["", cardSequence.cardDateUpperCar, cardSequence.cardDateLowerCard]
                    soundPlayer.playSound(soundName: "chime_clickbell_octave_up", type: "mp3", soundState: soundState)

                }else{
                    answerIsGood =  false
                    dateTextArray = ["", "", ""]
                    soundPlayer.playSound(soundName: "etc_error_drum", type: "mp3", soundState: soundState)
                }
                
            }
        }
        
    }
    func dateText(){
        
    }
}

struct CardQuizView_Previews: PreviewProvider {
    static var previews: some View {
        CardQuizView()
    }
}
