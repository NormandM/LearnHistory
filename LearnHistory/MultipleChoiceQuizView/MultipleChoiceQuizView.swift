//
//  ContentView.swift
//  FirstQuizTestw
//
//  Created by Normand Martin on 2021-11-03.
//

import SwiftUI
import AVFoundation
import ActivityIndicatorView


struct MultipleChoiceQuizView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    @FetchRequest var fetchRequest: FetchedResults<HistoricalEventDetail>
    @State private var buttonFlipped = [false, false,false, false]
    @State private  var buttonIsVisible = [true, true, true, true]
    @State private var coins = UserDefaults.standard.integer(forKey: "coins")
    @State private  var buttonTitles = ["", "", "", ""]
    @State private  var textForQuestion = ""
    var soundPlayer = SoundPlayer.shared
    @State private var soundState = "speaker.slash"
    @State private var questionSection = QuestionSection.multipleChoiceQuestionNotAnswered
    @State private var isFlippedLeft = false
    @State private var isFlippedRight = false
    var selectedTheme: String
    @StateObject var questionViewModel: QuestionViewModel
    @ObservedObject var monitor = NetworkMonitor()
    @State private var imageIsLoading = false
    @State private var hintDemanded = false
    @State private var identifyButtonRightAnswer = false
    @State private var nextButtonIsVisible = false
    @State private var progressNumber = CGFloat()
    @State private var numberOfAnswers = 0
    @State private var progressionMessage = ProgressionMessage.inProgress
    @State private var showAlertQuizExit = false
    @State private var hintButtonIsVisible = true
    @State private var score = 0.0
    @State private var answerIsGood = true
    @State private var startOver = false
    @State private var viewOpacity = 0.0
    @State private var message = String()
    @State private var fromNoCoinsView = false
    @State private var small = true
    @State private var lastQuizSection = QuestionSection.multipleChoiceQuestionNotAnswered
    @State private var overlayIsHidden = UserDefaults.standard.bool(forKey: "overlayIsHidden")
    let sectionName: String
    let numberOfQuestion: Int
    init (selectedTheme: String, sectionName: String) {
        self.selectedTheme = selectedTheme
        self.sectionName = sectionName
        let allEvents = Bundle.main.decode([Event].self, from: selectedTheme)
        self._questionViewModel = StateObject(wrappedValue: QuestionViewModel(allEvents: allEvents))
        _fetchRequest = FetchRequest<HistoricalEventDetail>(sortDescriptors: [
            NSSortDescriptor(keyPath: \HistoricalEventDetail.order, ascending: true)
        ],predicate: NSPredicate(format: "theme == %@", selectedTheme))
        self.numberOfQuestion = allEvents.count
    }
    
    var body: some View {
        if UserDefaults.standard.double(forKey: selectedTheme) == 1.0 && !startOver {
            AlreadyAnExpertView(theme: selectedTheme, startOver: $startOver)
                .transition(.asymmetric(insertion: .slide, removal: .scale))
                .background(Color.black)
        }else{
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Text("Round ".localized + "\(numberOfAnswers + 1) " + "of ".localized + "\(numberOfQuestion)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(ColorReference.orange)
                        .frame(width: 350, alignment: .center)
                        .scaleEffect(small ? 1.0 : 1.5, anchor: .center)
                        .onChange(of: numberOfAnswers, perform: {_ in
                            withAnimation(.easeInOut(duration: 1)){
                                small = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(.easeInOut(duration: 1)){
                                        small = true
                                    }
                                }
                            }
                        })
                        .padding(.top)
                        switch questionSection {
                        case .multipleChoiceQuestionNotAnswered:
                            Spacer()
                            Text(textForQuestion)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Spacer()
                            LazyVGrid(columns: [GridItem(), GridItem()]){
                                ForEach((0..<4)){buttonIndex in
                                    FlipView(isFlipped: buttonFlipped[buttonIndex]) {
                                        Button{
                                            evaluateAnswer(buttonTitle: questionViewModel.buttonTitles[buttonIndex], buttonIndex: buttonIndex)
                                        }label: {
                                            QuizButtonTextModifier( buttonTitle: buttonTitles[buttonIndex], identifyButtonRightAnswer: identifyButtonRightAnswer)
                                                .animation(Animation.easeIn(duration: 1.0), value: buttonFlipped[buttonIndex])
                                        }
                                        .disabled(identifyButtonRightAnswer)
                                        .padding(.leading)
                                        .padding(.trailing)
                                    } back: {
                                        QuizButtonTextModifier2(title: buttonTitles[buttonIndex], hintDemanded: hintDemanded)
                                            .padding(.leading)
                                            .padding(.trailing)
                                    }
                                    .opacity(buttonIsVisible[buttonIndex] ? 1 : 0)
                                    .animation(.spring(response: 0.7, dampingFraction: 0.7), value: buttonFlipped[buttonIndex])
                                }
                            }
                            
                        case .multipleChoiceQuestionAnsweredIncorrectly:
                            CustomProgressViewUser(progress: progressNumber, theme: selectedTheme, progressionMessage: progressionMessage, numberOfAnswers: numberOfAnswers, numberOfQuestions: numberOfQuestion, score: score, answerIsGood: false, sectionName: sectionName)
                                .frame(height: progressNumber >= 1.0 ? deviceHeight : deviceHeight * 0.80)
                            
                            
                        case .multipleChoiceQuestionAnsweredCorrectly:
                            WiKiView(imageIsLoading: $imageIsLoading, wikiSearch: questionViewModel.wikiSearchWord, questionSection: questionSection)
                                .frame(width: deviceWidth, height: deviceHeight * 0.6, alignment: .center)
                                .onAppear{
                                    hintDemanded = false
                                }
                            
                            
                        case .trueOrFalseQuestionDisplayed:
                            if monitor.isConnected {
                                WiKiView( imageIsLoading: $imageIsLoading, wikiSearch: questionViewModel.wikiSearchWord, questionSection: questionSection)
                                    .frame(width: deviceWidth, height: deviceHeight * 0.35, alignment: .center)
                            }
                            
                            TrueOrFalseQuizView(isFlippedLeft: $isFlippedLeft, isFlippedRight: $isFlippedRight, nextButtonIsVisible: $nextButtonIsVisible, questionSection: $questionSection, hintButtonIsVisible: $hintButtonIsVisible, soundPlayer: soundPlayer,  soundState: soundState, selectedTheme: selectedTheme, questionViewModel: questionViewModel, hintDemanded: $hintDemanded, fetchRequest: _fetchRequest)
                            
                        case .trueOrFalseHint:
                            WiKiView(imageIsLoading: $imageIsLoading, wikiSearch: questionViewModel.wikiSearchWord, questionSection: questionSection)
                                .frame(width: deviceWidth, height: deviceHeight * 0.60, alignment: .center)
                            
                        case .trueOrFalseAnsweredIncorrectly:
                            CustomProgressViewUser(progress: progressNumber, theme: selectedTheme, progressionMessage: progressionMessage, numberOfAnswers: numberOfAnswers, numberOfQuestions: numberOfQuestion, score: score, answerIsGood: false, sectionName: sectionName)
                                .frame(height: progressNumber >= 1.0 ? deviceHeight : deviceHeight * 0.80)
                        case .showQuizStatusPage:
                            CustomProgressViewUser(progress: progressNumber, theme: selectedTheme, progressionMessage: progressionMessage, numberOfAnswers: numberOfAnswers, numberOfQuestions: numberOfQuestion, score: score, answerIsGood: answerIsGood, sectionName: sectionName)
                                .frame(height: progressNumber >= 1.0 ? deviceHeight : deviceHeight * 0.75)
                            
                        case .showCardView:
                            CardQuizView(initialiseForQuestion: initialiseForQuestion, answerIsGood: $answerIsGood ,questionSection: $questionSection, hintDemanded: $hintDemanded, selectedTheme: selectedTheme, questionViewModel: questionViewModel, numberOfQuestion: numberOfQuestion, nextButtonVisible: $nextButtonIsVisible, hintButtonIsVisible: $hintButtonIsVisible, numberOfAnswers: $numberOfAnswers, progressionMessage: $progressionMessage, progressNumber: $progressNumber, score: $score, coins: $coins, soundState: soundState, viewOpacity: $viewOpacity)
                        case .showNoCoinsView:
                            NoCoinsView(selectedTheme: selectedTheme, questionSection: $questionSection, hintButtonIsVisible: $hintButtonIsVisible, fromNoCoinsView: $fromNoCoinsView)
                                .frame(width: deviceHeight > deviceWidth ?  deviceHeight * 0.4 : deviceHeight * 0.6, height: deviceHeight > deviceWidth ? deviceHeight * 0.5 : deviceHeight * 0.6, alignment: .center)
                                .cornerRadius(20)
                                .opacity(viewOpacity)
                        case .showCoinsAtZero:
                            CoinsAtZero(selectedTheme: selectedTheme, questionSection: $questionSection, lastQuizSection: $lastQuizSection, hintButtonIsVisible: $hintButtonIsVisible, fromNoCoinsView: $fromNoCoinsView)
                                .frame(width: deviceHeight > deviceWidth ?  deviceHeight * 0.4 : deviceHeight * 0.6, height: deviceHeight > deviceWidth ? deviceHeight * 0.5 : deviceHeight * 0.6, alignment: .center)
                                .cornerRadius(20)
                                .opacity(viewOpacity)
                        case .showCoinMangementView:
                            CoinManagementView(questionSection: $questionSection, coins: $coins, nextButtonIsVisible: $nextButtonIsVisible, hintButtonIsVisible: $hintButtonIsVisible, fromNocoinsView: $fromNoCoinsView, lastQuizSection: lastQuizSection)
                            
                        case .menuPage:
                            EmptyView()
                        case .noInternetConnection:
                            NoInternetConnectionView(questionSection: $questionSection, selectedTheme: selectedTheme)
                        }
                    
                    VStack {
                        if nextButtonIsVisible {
                            Button{
                                determineQuizSection()
                                coins =  UserDefaults.standard.integer(forKey: "coins")
                                if coins < 0 {
                                    questionSection = .showNoCoinsView
                                    hintButtonIsVisible = false
                                    nextButtonIsVisible = false
                                    withAnimation(Animation.linear(duration: 2.0)) {
                                        viewOpacity = 1.0
                                    }
                                }
                                
                            }label: {
                                if isFlippedLeft || isFlippedRight || identifyButtonRightAnswer || !answerIsGood {
                                    Image(systemName: "arrow.left")
                                        .font(.title)
                                }else{
                                    Image(systemName: "arrow.right")
                                        .font(.title)
                                }
                            }
                            .buttonStyle(ArrowButton())
                            .zIndex(1.0)
                            .padding()
                        }


                        Button{
                            
                            if coins < 1 {
                                lastQuizSection = questionSection
                                questionSection = .showCoinsAtZero
                                hintButtonIsVisible = false
                                withAnimation(Animation.linear(duration: 2.0)) {
                                    viewOpacity = 1.0
                                }
                                
                            }else{
                                hintManagement()
                            }
                            coins = UserDefaults.standard.integer(forKey: "coins")
                        }label:{
                            HStack {
                                if !hintDemanded && !identifyButtonRightAnswer {Text("Hints")}
                                Text("Coins available: \(coins)")
                                    .padding(.leading)
                                    .foregroundColor(hintDemanded || identifyButtonRightAnswer ? .black : .white)
                            }
                        }
                        .disabled(hintDemanded || identifyButtonRightAnswer)
                        .padding(10)
                        .frame( maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(hintDemanded || identifyButtonRightAnswer ? ColorReference.lightGreen : ColorReference.darkGreen)
                        .cornerRadius(15)
                        .padding()
                        .padding(.bottom)
                        .opacity(hintButtonIsVisible  ? 1 : 0)
                        .zIndex(0.5)
                        .overlay(alignment: .bottomTrailing){
                            if !overlayIsHidden {
                                Image("Hint Buble2Eng".localized)
                                    .resizable()
                                    .frame(width: 175, height: 175)
                                    
                            }
                        }
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                overlayIsHidden = true
                            }
                        }

                    }
                    
                }
                .toolbar{

                    ToolbarItem(placement: .principal) {
                        HStack{
                            Spacer()
                            VStack{
                                Text(selectedTheme.separateFirstword)
                                Text(selectedTheme.separateOtherWords)
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.trailing)
                            .padding(.trailing)
                            Spacer()
                            Button{
                                soundState = SoundOption.soundOnOff()
                            }label: {
                                Image(systemName: soundState)
                                    .foregroundColor(.white)
                            }
                            
                        }

                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxHeight: .infinity)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action : {
                    showAlertQuizExit = true
                    
                }){
                    if fromNoCoinsView {
                        Text("")
                    }else{
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                    }

                })

                
                .onAppear{
                    overlayIsHidden = UserDefaults.standard.bool(forKey: "overlayIsHidden")
                    numberOfAnswers = 0
                    EraseQuizResult.erase(fetchRequest: fetchRequest, theme: selectedTheme)
                    hintDemanded = false
                    nextButtonIsVisible = false
                    identifyButtonRightAnswer = false
                    initialiseForQuestion()
                    if let soundStateTrans = UserDefaults.standard.string(forKey: "soundState"){
                        soundState = soundStateTrans
                    }
                    if !monitor.isConnected {
                        imageIsLoading = false
                    }else{
                        imageIsLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            imageIsLoading = false
                        }
                    }
                }
                .alert(isPresented: $showAlertQuizExit) {
                    Alert(
                        title: Text("Are you sure you want to exit without finishing the Quiz?"),
                        message: Text("It will reset the quiz"),
                        primaryButton: .destructive(Text("Exit")) {
                            EraseQuizResult.erase(fetchRequest: fetchRequest, theme: selectedTheme)
                            if UserDefaults.standard.double(forKey: selectedTheme) < score {
                                UserDefaults.standard.set(score, forKey: selectedTheme)
                            }
                            
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    // MARK: FUNCTIONS
    func evaluateAnswer(buttonTitle: String, buttonIndex: Int)  {
        nextButtonIsVisible = true
        determineQuizSection()
        if buttonTitle == questionViewModel.correctAnswer {
            questionSection = .multipleChoiceQuestionAnsweredCorrectly
            soundPlayer.playSound(soundName: "chime_clickbell_octave_up", type: "mp3", soundState: soundState)
                textForQuestion = questionViewModel.wikiSearchWord
        
            if !monitor.isConnected {
                imageIsLoading = false
                questionSection = .noInternetConnection
                nextButtonIsVisible = false
            }else{
                imageIsLoading = true
            }
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
            for event in fetchRequest{
                if event.wrappedId == questionViewModel.id {
                    event.numberOfBadAnswersQuiz = event.numberOfBadAnswersQuiz + 1
                }
            }
            try? moc.save()
            soundPlayer.playSound(soundName: "etc_error_drum", type: "mp3", soundState: soundState)
            identifyButtonRightAnswer = true
            if hintDemanded {
                BadAnswer1.substract()
            }else{
                BadAnswer2.substract()
            }
            buttonFlipped[buttonIndex] = true
            var indexForButton = [0, 1, 2 ,3]
            indexForButton.remove(at: buttonIndex)
            for index in indexForButton  {
                if buttonTitles[index] == questionViewModel.correctAnswer {
                    buttonIsVisible[index] = true
                    identifyButtonRightAnswer = true
                }else{
                    buttonIsVisible[index] = false
                }
            }
        }
    }
    
    func initialiseForQuestion() {
        questionViewModel.increment()
        hintDemanded = false
        identifyButtonRightAnswer = false
        buttonTitles[0] = questionViewModel.buttonTitles[0]
        buttonTitles[1] = questionViewModel.buttonTitles[1]
        buttonTitles[2] = questionViewModel.buttonTitles[2]
        buttonTitles[3] = questionViewModel.buttonTitles[3]
        textForQuestion = questionViewModel.question
        isFlippedLeft = false
        isFlippedRight = false
        answerIsGood = true
        questionSection = QuestionSection.multipleChoiceQuestionNotAnswered
        nextButtonIsVisible = false
        buttonIsVisible = [true, true, true, true]
        buttonFlipped = [false, false, false, false]
        
    }
    func hintManagement() {
        UserDefaults.standard.set(true, forKey: "overlayIsHidden")
        hintDemanded = true
        Hint1.substract()
        switch questionSection {
        case .multipleChoiceQuestionNotAnswered:
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
        case .trueOrFalseQuestionDisplayed:
            questionSection = .trueOrFalseHint
            nextButtonIsVisible = true
            hintButtonIsVisible = false
        default:
            return
        }
        
    }
    func determineQuizSection(){
        score = Progression.calculation(fetchRequest: fetchRequest, numberOfQuestion: numberOfQuestion)
        progressNumber = Progression.quizProgress(fetchRequest: fetchRequest)
        progressionMessage = Progression.message(questionViewModel: questionViewModel, progressNumber: progressNumber, score: score, answerIsGood: answerIsGood)
        
        switch questionSection {
        case .multipleChoiceQuestionNotAnswered:
            nextButtonIsVisible = true
            if identifyButtonRightAnswer {
                hintButtonIsVisible = false
                numberOfAnswers = Progression.numberOfAnswers(fetchRequest: fetchRequest)
                progressionMessage = Progression.message(questionViewModel: questionViewModel, progressNumber: progressNumber, score: score, answerIsGood: false)
                hintButtonIsVisible = true
                nextButtonIsVisible = false
                if progressionMessage == .finished {
                    questionSection = .showQuizStatusPage
                }else{
                    questionSection = .multipleChoiceQuestionNotAnswered
                    initialiseForQuestion()
                }
                
                
            }else{
                hintButtonIsVisible = false
            }

            
        case .multipleChoiceQuestionAnsweredIncorrectly:
            return

        case .trueOrFalseHint:
            questionSection = .trueOrFalseQuestionDisplayed
            hintDemanded = true
            nextButtonIsVisible = false
            hintButtonIsVisible = true

        case .multipleChoiceQuestionAnsweredCorrectly:
            hintDemanded = false
            identifyButtonRightAnswer = false
            nextButtonIsVisible = false
            hintButtonIsVisible = true
            questionSection = .trueOrFalseQuestionDisplayed
        case .trueOrFalseQuestionDisplayed:
            if hintDemanded {
                questionSection = .trueOrFalseHint
            }
            if isFlippedLeft || isFlippedRight {
                score = Progression.calculation(fetchRequest: fetchRequest, numberOfQuestion: numberOfQuestion)
                numberOfAnswers = Progression.numberOfAnswers(fetchRequest: fetchRequest)
                progressNumber = Progression.quizProgress(fetchRequest: fetchRequest)
                progressionMessage = Progression.message(questionViewModel: questionViewModel, progressNumber: progressNumber, score: score, answerIsGood: false)
                if progressionMessage == .finished {
                    questionSection = .showQuizStatusPage
                    nextButtonIsVisible = false
                }else{
                    initialiseForQuestion()
                    questionSection = .multipleChoiceQuestionNotAnswered
                    hintButtonIsVisible = true
                    nextButtonIsVisible = false
                }
            }
        case .trueOrFalseAnsweredIncorrectly:
            return
        case .showQuizStatusPage:
            nextButtonIsVisible = false
            hintButtonIsVisible = true
            answerIsGood = true
            initialiseForQuestion()
            questionSection = .multipleChoiceQuestionNotAnswered
        case .showCardView:
            nextButtonIsVisible = false
            hintButtonIsVisible = false
        default:
            return
        }
    }


    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleChoiceQuizView(selectedTheme: "", sectionName: "")
    }
}
