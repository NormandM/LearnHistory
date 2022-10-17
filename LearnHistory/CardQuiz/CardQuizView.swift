//
//  ContentView.swift
//  NewHistoryCards
//
//  Created by Normand Martin on 2021-11-28.
//

import SwiftUI
import AVFoundation


struct CardQuizView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var fetchRequest: FetchedResults<HistoricalEventDetail>
    var initialiseForQuestion: () -> Void
    @State private var cardFlipped = [false,
                            false, false]
    @StateObject var cardSequence: CardSequence
    @State private var cardFrames = [CGRect](repeating: .zero, count: 6)
    @State private var dateTextArray = ["", "", ""]
    @State private var clearColor = false
    @State private var cardIsDropped = false
    @Binding var answerIsGood: Bool
    var soundPlayer = SoundPlayer.shared
    @State private var questionWasAswered = false
    @Binding var questionSection: QuestionSection
    @Binding var hintDemanded: Bool
    @Binding var nextButtonVisible: Bool
    @Binding var hintButtonIsVisible: Bool
    var selectedTheme: String
    @StateObject var questionViewModel: QuestionViewModel
    @Binding var numberOfAnswers: Int
    @Binding var progressionMessage: ProgressionMessage
    @Binding var progressNumber: CGFloat
    @Binding var score: Double
    @Binding var coins: Int
    let numberOfQuestion: Int
    let gradient: Gradient = Gradient(colors: [ColorReference.orange, ColorReference.red])
    @State private var soundState: String
    @Binding var viewOpacity: Double
    init (initialiseForQuestion: @escaping () -> Void, answerIsGood: Binding<Bool>, questionSection: Binding<QuestionSection>, hintDemanded: Binding<Bool>, selectedTheme: String, questionViewModel: QuestionViewModel, numberOfQuestion: Int, nextButtonVisible: Binding<Bool>, hintButtonIsVisible: Binding<Bool>, numberOfAnswers: Binding<Int>, progressionMessage: Binding<ProgressionMessage>, progressNumber: Binding<CGFloat>, score: Binding<Double>, coins: Binding<Int>, soundState: String, viewOpacity: Binding<Double>) {
        self._numberOfAnswers = numberOfAnswers
        self._progressionMessage = progressionMessage
        self._progressNumber = progressNumber
        self.initialiseForQuestion = initialiseForQuestion
        self._answerIsGood = answerIsGood
        self._hintButtonIsVisible = hintButtonIsVisible
        self._questionSection = questionSection
        self._hintDemanded = hintDemanded
        self._nextButtonVisible = nextButtonVisible
        self.selectedTheme = selectedTheme
        self.numberOfQuestion = numberOfQuestion
        self._questionViewModel = StateObject(wrappedValue: questionViewModel)
        self._cardSequence = StateObject(wrappedValue: CardSequence(selectedTheme: selectedTheme, questionViewModel: questionViewModel))
        _fetchRequest = FetchRequest<HistoricalEventDetail>(sortDescriptors: [
            NSSortDescriptor(keyPath: \HistoricalEventDetail.order, ascending: true)
        ],predicate: NSPredicate(format: "theme == %@", selectedTheme))
        self._score = score
        self._coins = coins
        self._soundState = State(wrappedValue: soundState)
        self._viewOpacity = viewOpacity
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            GeometryReader { geo in
                VStack {
                    Spacer()
                    if !questionWasAswered {
                    HStack{
                        ForEach(0..<3){textIndex in
                            switch textIndex {
                            case 0, 2:
                                Text(dateTextArray[textIndex])
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, maxHeight: 100)
                                    .opacity(cardIsDropped ? 1.0 : 0.0)
                            case 1:
                                if hintDemanded {
                                    Text(cardSequence.cardDateUpperCar)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, maxHeight: 100)
                                }else{
                                    Text(dateTextArray[textIndex])
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity, maxHeight: 100)
                                        .opacity(cardIsDropped ? 1.0 : 0.0)
                                }
                            default:
                                Text("")
                            }
                            
                        }
                    }
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]){
                        ForEach((0..<6)){cardIndex in
                            switch cardIndex {
                            case 0, 1 ,2:
                                FlipView(isFlipped: cardFlipped[cardIndex]){
                                    Card(clearColor: cardColor(cardIndex: cardIndex), cardText: upperCardText(cardIndex: cardIndex).0, index: cardIndex, fontColorIsClear: upperCardText(cardIndex: cardIndex).1, gradientSelection: gradient, fontType: Font.footnote)
                                        .frame(height: geo.size.height * 0.30)
                                        .overlay(GeometryReader { geo in
                                            if cardIndex == 0 || cardIndex == 2 {
                                                ZStack{
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.white, lineWidth: 2)
                                                    .opacity(cardIsDropped ? 0 : 1)
                                                    if cardIndex == 0 {
                                                        Text("Before?\n\nDrop Card Here")
                                                            .padding()
                                                            .multilineTextAlignment(.center)
                                                            .foregroundColor(.white)
                                                            .opacity(cardIsDropped ? 0 : 1)
                                                    }else{
                                                        Text("After?\n\nDrop Card Here")
                                                            .padding()
                                                            .multilineTextAlignment(.center)
                                                            .foregroundColor(.white)
                                                            .opacity(cardIsDropped ? 0 : 1)

                                                    }
                                                }
                                            }
                                            Color.clear
                                                .onAppear{
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                                        self.cardFrames[cardIndex] = geo.frame(in: .global)
                                                    }
                                                }

                                        })
                                        .allowsHitTesting(false)

                                } back: {
                                    CardBack(hintDemanded: hintDemanded)
                                        .frame(height: geo.size.height * 0.30)
                                    
                                }
                                .animation(Animation.spring(response: 0.7, dampingFraction: 0.7), value: cardFlipped[cardIndex])
                                .frame(height: geo.size.height * 0.30)
                            case 3, 4, 5 :
                                Card(clearColor: clearColor, cardText: lowerCardText(cardIndex: cardIndex), index: cardIndex, fontColorIsClear: false, onEnded: cardDropped, onChanged: cardMoved, gradientSelection: gradient, fontType: Font.footnote)
                                    .frame(height: geo.size.height * 0.30)
                                    .overlay(GeometryReader { geo in
                                        Color.clear
                                            .onAppear{
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                                    self.cardFrames[cardIndex] = geo.frame(in: .global)
                                                }
                                            }
                                    })
                                    .opacity(bottomIsVisible(cardIndex: cardIndex) ? 0.0 : 1.0)
                                
                            default:
                                Text("")
                            }
                        }
                    }
                    }else{
                        Text("")
                    }
                    Button{
                        score = Progression.calculation(fetchRequest: fetchRequest, numberOfQuestion: numberOfQuestion)
                        progressNumber = Progression.quizProgress(fetchRequest: fetchRequest)
                        progressionMessage = Progression.message(questionViewModel: questionViewModel, progressNumber: progressNumber, score: score, answerIsGood: answerIsGood)
                        numberOfAnswers = Progression.numberOfAnswers(fetchRequest: fetchRequest)
                        coins = UserDefaults.standard.integer(forKey: "coins")
                        if coins < 0 {
                            initialiseForQuestion()
                            questionSection = .showNoCoinsView
                            hintButtonIsVisible = false
                            nextButtonVisible = false
                            withAnimation(Animation.linear(duration: 2.0)) {
                                viewOpacity = 1.0
                            }
                        }else{
                            if questionWasAswered {
                                cardIsDropped = false
                                questionWasAswered = false
                                hintButtonIsVisible = true
                                nextButtonVisible = false
                            }else{
                                cardIsDropped = true
                                nextButtonVisible = true
                                questionWasAswered = true
                                if numberOfAnswers == 10 {
                                    questionSection = .showQuizStatusPage
                                }else{
                                    questionSection = .multipleChoiceQuestionNotAnswered
                                    initialiseForQuestion()
                                }
                                hintButtonIsVisible = true
                            }
                            if progressionMessage == .finished {nextButtonVisible = false}
                            if progressionMessage == .expertAchieved {nextButtonVisible = false}
                        }

                    }label: {
                        if answerIsGood{
                            Image(systemName: "arrow.right")
                                .font(.title)
                        }else{
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }
                    }
                    .buttonStyle(ArrowButton())
                    .opacity(cardIsDropped ? 1 : 0)
                    Spacer()
                }
                .navigationTitle("Before or After")
                .frame(maxHeight: .infinity)
                .onAppear{
                    hintButtonIsVisible = true
                }
            }
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
        case 3:
            return ""
        case 4:
            return cardSequence.bottomCard
        case 5:
            return ""
        default:
            return ""
        }
        
    }
    func cardDropped(location: CGPoint, cardIndex: Int,  event: String){
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)}){
            cardIsDropped = true
            if match == 0 {
                dateTextArray = [cardSequence.cardDateLowerCard, cardSequence.cardDateUpperCar, ""]
                if cardSequence.cardResponseIsLeft{
                    goodAnswerCompilation()
                    dateTextArray = [cardSequence.cardDateLowerCard, cardSequence.cardDateUpperCar, ""]
                }else{
                    badAnswerCompilation()
                    dateTextArray = [cardSequence.cardDateLowerCard, cardSequence.cardDateUpperCar, ""]
                }
            }else if match == 2{
                dateTextArray = ["", cardSequence.cardDateUpperCar, cardSequence.cardDateLowerCard]
                if !cardSequence.cardResponseIsLeft{
                    goodAnswerCompilation()
                    dateTextArray = ["", cardSequence.cardDateUpperCar, cardSequence.cardDateLowerCard]
                }else{
                    badAnswerCompilation()
                    dateTextArray = ["", cardSequence.cardDateUpperCar, cardSequence.cardDateLowerCard]
                }
                
            }else{
                
            }

        }
        
    }
    func cardMoved(location: CGPoint) -> DragState {
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
            
        }) {
            if match == 0 || match == 2 {

                return .good
            }else{

                return .bad
            }
        }
        else {
            return .bad
        }
        
    }
    func bottomIsVisible(cardIndex: Int) -> Bool{
        if cardIndex == 3 || cardIndex == 5{
            return true
        }else if cardIsDropped{
            return true
        }else{
            return false
        }
    }
    func hintManagement(){
        hintDemanded = true
        Hint2.substract()
    }
    func goodAnswerCompilation() {
        answerIsGood = true
        soundPlayer.playSound(soundName: "chime_clickbell_octave_up", type: "mp3", soundState: soundState)
        coins = UserDefaults.standard.integer(forKey: "coins")
        for event in fetchRequest{
            if event.wrappedTimeLine == cardSequence.upperCard {
                event.numberOfGoodAnswersQuiz = event.numberOfGoodAnswersQuiz + 1
                
            }
        }
        try? moc.save()
    }
    func badAnswerCompilation() {
        answerIsGood =  false
        soundPlayer.playSound(soundName: "etc_error_drum", type: "mp3", soundState: soundState)
        if hintDemanded {
            BadAnswer1.substract()
            coins = UserDefaults.standard.integer(forKey: "coins")
        }else{
            BadAnswer2.substract()
            coins = UserDefaults.standard.integer(forKey: "coins")
        }
        for event in fetchRequest{
            if event.wrappedTimeLine == cardSequence.upperCard {
                event.numberOfBadAnswersQuiz = event.numberOfBadAnswersQuiz + 1
            }
        }
        try? moc.save()
        dateTextArray = ["", "", ""]
        if hintDemanded{
            BadAnswer1.substract()
        }else{
            BadAnswer2.substract()
        }
        
    }

}

//struct CardQuizView_Previews: PreviewProvider {
//    static var previews: some View {
//
//            CardQuizView(initialiseForQuestion: <#() -> Void#>, questionSection: .constant(.showCardView), hintDemanded: .constant(false), selectedTheme: "French History".localized, questionViewModel: QuestionViewModel(allEvents: Bundle.main.decode([Event].self, from: "Ancient Rome")), numberOfQuestion: 20)
//
//
//    }
//}
