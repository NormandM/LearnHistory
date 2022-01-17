//
//  ContentView.swift
//  FirstQuizTest
//
//  Created by Normand Martin on 2021-11-03.
//

import SwiftUI
import AVFoundation

struct MultipleChoiceQuizView: View {
    @State private var buttonFlipped = [false, false,false, false]
    @State private var allFlipped = false
    @State private  var buttonIsVisible = [true, true, true, true]
    @StateObject var questionViewModel = QuestionViewModel()
    @State private var coins = UserDefaults.standard.integer(forKey: "coins")
    @State private  var indexOfQuestion = UserDefaults.standard.integer(forKey: "indexOfQuestion")
    @State private  var buttonTitles = ["", "", "", ""]
    @State private  var textForQuestion = ""
    @State private var numberOfTries = 0
    var soundPlayer = SoundPlayer.shared
    @State private var soundState = "speaker.slash"
    @State private var isCardViewQuiz = false
    @State private var questionSection = QuestionSection.multipleChoiceQuestionNotAnswered
    @State private var isFlippedLeft = false
    @State private var isFlippedRight = false

    var body: some View {
        GeometryReader{ geo in
            VStack {
                NavigationLink(destination: CardQuizView(), isActive: $isCardViewQuiz) { EmptyView() }
                Spacer()
                switch questionSection {
                case .multipleChoiceQuestionNotAnswered:
                    Text(textForQuestion)
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .border(.white, width: 2)
                    Spacer()
                    FlipView(isFlipped: allFlipped) {
                        LazyVGrid(columns: [GridItem(), GridItem()]){
                            ForEach((0..<4)){buttonIndex in
                                FlipView(isFlipped: buttonFlipped[buttonIndex]) {
                                    Button{
                                        evaluateAnswer(buttonTitle: questionViewModel.buttonTitles[buttonIndex], buttonIndex: buttonIndex)
                                    }label: {
                                        QuizButtonTextModifier( buttonTitle: buttonTitles[buttonIndex])
                                            .animation(.easeIn(duration: 1.0))
                                    }
                                    .padding(.leading)
                                    .padding(.trailing)
                                } back: {
                                    QuizButtonTextModifier2(title: "")
                                        .padding(.leading)
                                        .padding(.trailing)
                                }
                                .opacity(buttonIsVisible[buttonIndex] ? 1 : 0)
                                .animation(.spring(response: 0.7, dampingFraction: 0.7))
                            }
                        }
                    } back : {
                        AllButtonsView()
                    }
                    .animation(.spring(response: 0.7, dampingFraction: 0.7))
                case .multipleChoiceQuestionAnsweredCorrectly:
                    WiKiView(wikiSearch: questionViewModel.wikiSearchWord, questionSection: questionSection)
                        .frame(width: geo.size.width, height: geo.size.height * 0.8, alignment: .center)
                        .border(.white, width: 2)
                case .trueOrFalseQuestionDisplayed:
                    WiKiView(wikiSearch: questionViewModel.wikiSearchWord, questionSection: questionSection)
                        .frame(width: geo.size.width, height: geo.size.height * 0.4, alignment: .center)
                    TrueOrFalseQuizView(isCardViewQuiz: $isCardViewQuiz, isFlippedLeft: $isFlippedLeft, isFlippedRight: $isFlippedRight, soundState: soundState)
                        .frame(width: geo.size.width, height: geo.size.height * 0.4, alignment: .center)
                        .border(.green, width: 2)
                }
                VStack {
                    Button{
                        determineQuizSection()
                        if isFlippedLeft || isFlippedRight || allFlipped {
                            initialiseForQuestion()
                            
                        }
                    }label: {
                        Text(isFlippedLeft || isFlippedRight || allFlipped ? "Back" : "Next")
                            .font(.title)
                            .opacity(nextButtonIsVisible() ? 1 : 0)
                    }
                    .frame( maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.black)
                    Button{
                        hintManagement()
                    }label:{
                        Text("Hints     Coins available: \(UserDefaults.standard.integer(forKey: "coins"))")
                    }
                    .frame( maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(ColorReference.darkGreen)
                    .cornerRadius(15)
                    .padding()
                    .padding(.bottom)

                }
                .background(Color.black)
            }
            .onAppear{
                initialiseForQuestion()
                if let soundStateTrans = UserDefaults.standard.string(forKey: "soundState"){
                    soundState = soundStateTrans
                }
            }
            .toolbar{
                Button{
                    soundState = SoundOption.soundOnOff()
                }label: {
                    Image(systemName: soundState)
                }
            }
            .navigationTitle("French History")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxHeight: .infinity)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    
    // MARK: FUNCTIONS
    func evaluateAnswer(buttonTitle: String, buttonIndex: Int)  {
        determineQuizSection()
        if buttonTitle == questionViewModel.correctAnswer {
            coins =  coins + Coins.goodAnswer
            UserDefaults.standard.set(coins, forKey: "coins")
            questionSection = .multipleChoiceQuestionAnsweredCorrectly
            soundPlayer.playSound(soundName: "chime_clickbell_octave_up", type: "mp3", soundState: soundState)
            textForQuestion = questionViewModel.wikiSearchWord
            switch buttonIndex {
            case 0:
                buttonIsVisible = [true, false, false, false]
            case 1:
                buttonIsVisible = [false, true, false, false]
            case 2:
                buttonIsVisible = [false, false, true, false]
            case 3:
                buttonIsVisible = [false, false, false, true]
            default:
                buttonIsVisible = [false, false, false, false]
            }
        }else{
            soundPlayer.playSound(soundName: "etc_error_drum", type: "mp3", soundState: soundState)
            coins = coins + Coins.badAnswer
            UserDefaults.standard.set(coins,forKey: "coins")
            buttonFlipped[buttonIndex] = true
            numberOfTries += 1
            testButtonVisible()
        }
    }
    func testButtonVisible(){
        if numberOfTries >= 3 {
            allFlipped = true
            
        }
    }
    func initialiseForQuestion() {
        questionViewModel.increment()
        buttonTitles[0] = questionViewModel.buttonTitles[0]
        buttonTitles[1] = questionViewModel.buttonTitles[1]
        buttonTitles[2] = questionViewModel.buttonTitles[2]
        buttonTitles[3] = questionViewModel.buttonTitles[3]
        textForQuestion = questionViewModel.question
        numberOfTries = 0
        allFlipped = false
        isFlippedLeft = false
        isFlippedRight = false
        questionSection = QuestionSection.multipleChoiceQuestionNotAnswered
        buttonIsVisible = [true, true, true, true]
        buttonFlipped = [false, false, false, false]
    }
    func hintManagement() {
        var removeIndex = Int()
        var buttonIndexArray = [0,1,2,3]
        for n in 0...3 {
            if questionViewModel.correctAnswer == buttonTitles[n]{
                removeIndex = n
            }
        }
        buttonIndexArray.remove(at: removeIndex)
        buttonIndexArray.shuffle()
        buttonIsVisible[buttonIndexArray[0]] = false
        buttonIsVisible[buttonIndexArray[1]] = false
        testButtonVisible()
        coins = coins + Coins.hint1
        UserDefaults.standard.set(coins, forKey: "coins")
    }
    func determineQuizSection(){
        switch questionSection {
        case .multipleChoiceQuestionNotAnswered:
            return
        case .multipleChoiceQuestionAnsweredCorrectly:
            questionSection = .trueOrFalseQuestionDisplayed
        case .trueOrFalseQuestionDisplayed:
            return
        }
    }
    func nextButtonIsVisible() -> Bool{
        if allFlipped {
            return true
        }else if questionSection == .multipleChoiceQuestionAnsweredCorrectly {
            return true
        }else if isFlippedLeft || isFlippedRight {
            return true
        }else{
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleChoiceQuizView()
    }
}
