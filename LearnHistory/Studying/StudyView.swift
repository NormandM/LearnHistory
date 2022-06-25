//
//  StudyView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-02-03.
//

import SwiftUI
import ActivityIndicatorView
import AVFoundation
var audioPlayer:AVAudioPlayer!
struct StudyView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var monitor = NetworkMonitor()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var fetchRequest: FetchedResults<HistoricalEvent>
    @State private var cardFrames = [CGRect](repeating: .zero, count: 3)
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    @State private var selectedTheme: String
    var soundPlayer = SoundPlayer.shared
    @State private var cardIsDropped = false
    @State private var cardDisplaced = CardDisplaced.cardNotDisplaced
    @State private var answer = "See answer".localized
    let red: Gradient = Gradient(colors: [ColorReference.red, ColorReference.red])
    let green: Gradient = Gradient(colors: [ColorReference.lightGreen, ColorReference.darkGreen])
    let gradient: Gradient = Gradient(colors: [ColorReference.orange, ColorReference.red])
    @State private var imageIsLoading = false
    @State private var seeMoreInfo = false
    @State private var fontColorIsClear = false
    @State private var questionCardIsInvisible = false
    @State private var xOffset2: CGFloat = 400
    @State private var screenWidth = CGFloat()
    @State private var numberIsClear = false
    @State private var seeStats = false
    @State private var optionViewIsVisible = false
    @State private var optionChooseWrongAnswers = false
    @State private var optionUseAllcards = false
    @State private var answerButtonPressed = false
    @State private var  arrayOfIndex = [Int]()
    @State private var  correctAnswer = String()
    @State private var  wikiSearchWord = String()
    @State private var  question = String()
    @State private var  upperCardQuestion = "Stack correctly answered cards here.".localized
    @State private var  loweCardQuestion = "Stack incorrectly answered cards here".localized
    @State private var  index = Int()
    @State private var  indexOfQuestion = Int()
    @State private var  upperStack = [Event]()
    @State private var  upperCardCount = Int()
    @State private var  lowerStack = [Event]()
    @State private var  lowerCardCount = Int()
    @State private var  questionCardCount = Int()
    @State private var  id = UUID()
    @State private var  indexLowerStack = Int()
    @State private var  indexUpperStack = Int()
    @State private var  allEvents = [Event]()
    init (selectedTheme: String) {
        self._selectedTheme = State(wrappedValue: selectedTheme)
        _fetchRequest = FetchRequest<HistoricalEvent>(sortDescriptors: [
            NSSortDescriptor(keyPath: \HistoricalEvent.order, ascending: true)
        ],predicate: NSPredicate(format: "theme == %@", selectedTheme))
    }
    var questionSection = QuestionSection.multipleChoiceQuestionAnsweredCorrectly
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            GeometryReader { geo in
                NavigationLink(destination: StatisticsView(selectedTheme: selectedTheme), isActive: $seeStats) { EmptyView() }
                if !seeMoreInfo {
                    
                    VStack {
                        HStack {
                            NMRoundButton(buttonText: "Start\nOver".localized, buttonAction: buttonAction)
                                .padding(.bottom)
                                .opacity(questionCardCount == 0 ? 1.0 : 0.0)
                            if optionViewIsVisible  {OptionView(optionButtonActionAllCards: optionButtonActionAllCards, optionBurronActionWrongCards: optionButtonActionWrongCards)}
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            LazyVGrid(columns: [GridItem()]){
                                ForEach((0..<3)){cardIndex in
                                    switch cardIndex{
                                    case 0:
                                        ZStack {
                                            Card(clearColor: cardColor(cardIndex: cardIndex), cardText: upperCardQuestion, index: cardIndex, fontColorIsClear: false, onEnded: cardDropped, gradientSelection: green, fontWeight: .light, fontType: .subheadline.italic())
                                                .frame(height: geo.size.height * 0.18)
                                                .allowsHitTesting(false)
                                                .overlay(GeometryReader { geo in
                                                    Color.clear
                                                        .onAppear{
                                                            screenWidth = geo.size.width + 50
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                                                self.cardFrames[cardIndex] = geo.frame(in: .global)
                                                            }
                                                        }
                                                })
                                                .padding(.leading)
                                                .padding(.trailing)
                                            Text(String(upperCardCount))
                                                .foregroundColor(ColorReference.lightGreen)
                                                .font(.custom("Custom", size: 120, relativeTo: .largeTitle))
                                                .opacity(0.4)
                                        }
                                    case 1:
                                        ZStack {
                                            Card(clearColor: cardColor(cardIndex: cardIndex), cardText: loweCardQuestion, index: cardIndex, fontColorIsClear: false, onEnded: cardDropped, gradientSelection: red,  fontWeight: .light, fontType: .subheadline.italic())
                                                .frame(height: geo.size.height * 0.18)
                                                .allowsHitTesting(false)
                                                .overlay(GeometryReader { geo in
                                                    Color.clear
                                                        .onAppear{
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                                                self.cardFrames[cardIndex] = geo.frame(in: .global)
                                                            }
                                                        }
                                                })
                                                .padding()
                                            Text(String(lowerCardCount))
                                                .foregroundColor(ColorReference.lightGreen)
                                                .font(.custom("Custom", size: 120, relativeTo: .largeTitle))
                                                .opacity(0.4)
                                        }
                                    case 2:
                                        ZStack {
                                            Card(clearColor: cardColor(cardIndex: cardIndex), cardText: question, responseButton: AnswerButton(question: $answer, showAnswer: showAnswer, answerButtonPressed: $answerButtonPressed),  index: cardIndex, fontColorIsClear: fontColorIsClear, onEnded: cardDropped, onChanged: cardMoved, gradientSelection: gradient,fontWeight: .semibold, fontType: Font.subheadline)
                                            
                                                .allowsHitTesting(questionCardCount == 0 ? false : true)
                                                .frame(height: geo.size.height * 0.18)
                                                .padding(.leading)
                                                .padding(.trailing)
                                            Text(String(questionCardCount))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(ColorReference.lightGreen)
                                                .font(.custom("Custom", size: 120, relativeTo: .largeTitle))
                                                .opacity(numberIsClear ? 0.0 : 0.4)
                                                .onChange(of: questionCardCount) { count in
                                                    if count == 0 {fontColorIsClear = true}
                                                }
                                            
                                        }
                                        .opacity(questionCardIsInvisible ? 0.0 : 1.0)
                                        .offset(x: cardIsDropped ? xOffset2 : 0)
                                    default:
                                        Text("")
                                    }
                                }
                            }
                            .frame(width: screenWidth > 600 ?  700 : nil)
                            .frame(height: deviceHeight * 0.4)
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            NMRoundButton(buttonText: "Read\nMore".localized, buttonAction: buttonActionReadMore)
                                .padding(.trailing)
                            NMRoundButton(buttonText: "See\nStats".localized, buttonAction: seeStatistics)
                                .padding(.leading)
                            
                        }
                        .padding(.top)
                        
                    }
                    .navigationTitle("MEMO CARDS: ".localized + selectedTheme)
                    .navigationBarTitleDisplayMode(.inline)
                    .foregroundColor(.white)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: Button(action : {
                        self.mode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                    })
                    
                    Spacer()
                }else{
                    VStack {
                        WiKiView(imageIsLoading: $imageIsLoading, wikiSearch: wikiSearchWord, questionSection: questionSection)
                            .frame(width: geo.size.width, height: geo.size.height * 0.8, alignment: .center)
                        
                        Button{
                            seeMoreInfo = false
                        }label:{
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }
                        .buttonStyle(ArrowButton())
                        
                    }
                }
            }
            .onAppear{
                allEvents = Bundle.main.decode([Event].self, from: selectedTheme)
                initialize()
            }
        }
    }
    func cardDropped(location: CGPoint, cardIndex: Int,  event: String){
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)}){
            answerButtonPressed = false
            cardIsDropped = true
            numberIsClear = false
            soundPlayer.playSound(soundName: "404015__paul-sinnett__card", type: "wav", soundState: "speaker.slash")
            switch match {
            case 0:
                actionAfterDrop()
                increment(cardPosition: CardDisplaced.upperCard)
            case 1:
                actionAfterDrop()
                increment(cardPosition: CardDisplaced.lowerCard)
            default:
                cardDisplaced = .cardNotDisplaced
            }
            
        }
    }
    func actionAfterDrop() {
        if questionCardCount == 1{
            answer = ""
        } else{
            answer = "See answer".localized
            questionCardIsInvisible = false
            self.xOffset2 = -screenWidth
            withAnimation(Animation.easeInOut(duration: 2.0)) {
                self.xOffset2 = 0
            }
        }
        cardDisplaced = .lowerCard
    }
    func cardMoved(location: CGPoint) -> DragState {
        numberIsClear = true
        if let match = cardFrames.firstIndex(where: {
            $0.contains(location)
            
        }) {
            if match == 0 || match == 1 {
                print(DragState.good)
                return .good
            }else{
                print(DragState.bad)
                return .bad
            }
        }
        else {
            return .bad
        }
        
    }
    func cardColor(cardIndex: Int) -> Bool{
        switch cardIndex{
        case 0:
            if cardIsDropped && cardDisplaced == .upperCard {
                return false
            }else if upperCardCount == 0{
                return false
            }else{
                return false
            }
            
        case 2:
            return false
        case 1:
            if cardIsDropped && cardDisplaced == .lowerCard{
                return false
            }else if lowerCardCount == 0{
                return false
            }else{
                return false
            }
            
        default:
            return false
        }
    }
    func showAnswer() {
        answer = correctAnswer
    }
    func buttonAction() {
        if lowerCardCount == 0 {
            optionUseAllcards = true
        }else{
            optionViewIsVisible = true
        }
        
    }
    func buttonActionReadMore() {
        seeMoreInfo = true
        imageIsLoading = true
    }
    func seeStatistics() {
        seeStats = true
    }
    func optionButtonActionAllCards() {
        optionUseAllcards = true
        optionViewIsVisible = false
        initialize()
    }
    func optionButtonActionWrongCards() {
        optionViewIsVisible = false
        optionChooseWrongAnswers = true
        initialize()
    }
    
    
    
    // Model for card management
    func increment(cardPosition: CardDisplaced) {
        switch cardPosition {
        case .upperCard:
            indexUpperStack = arrayOfIndex[indexOfQuestion]
            upperStack.append(allEvents[indexUpperStack])
            upperCardCount += 1
            UserDefaults.standard.set(true, forKey: "isGoodAnswer")
        case .lowerCard:
            indexLowerStack = arrayOfIndex[indexOfQuestion]
            lowerStack.append(allEvents[indexLowerStack])
            lowerCardCount += 1
            UserDefaults.standard.set(false, forKey: "isGoodAnswer")
        case .cardNotDisplaced:
            return
        }
        indexOfQuestion += 1
        if questionCardCount == 0 {UserDefaults.standard.set(nil, forKey: "indexOfQuestion")}
        initialize()
    }
    func initialize() {
        var numberOfEvents = allEvents.count
        if arrayOfIndex.count == 0 {initialiseArray()}
        if optionChooseWrongAnswers{
            answer = "See answer".localized
            allEvents = lowerStack
            numberOfEvents = lowerStack.count
            arrayOfIndex = []
            upperCardCount = 0
            lowerCardCount = 0
            questionCardCount = 0
            fontColorIsClear = false
            indexOfQuestion = 0
            optionChooseWrongAnswers = false
            lowerStack = []
            upperStack = []
            initialiseArray()
            
        }else if optionUseAllcards{
            answer = "See answer".localized
            upperCardCount = 0
            lowerCardCount = 0
            questionCardCount = 0
            fontColorIsClear = false
            optionUseAllcards = false
            lowerStack = []
            upperStack = []
            allEvents = Bundle.main.decode([Event].self, from: selectedTheme)
            numberOfEvents = allEvents.count
            initialiseArray()
        }
        if (indexOfQuestion == numberOfEvents) && numberOfEvents > 1{
            numberOfEvents = 0
            indexOfQuestion = 0
        }
        if indexOfQuestion == 1 && numberOfEvents == 1{
            indexOfQuestion = 0
        }else{
            index = arrayOfIndex[indexOfQuestion]
        }
        
        correctAnswer = allEvents[index].correctTAnswer
        wikiSearchWord = allEvents[index].wikiSearchWord
        question = allEvents[index].question
        questionCardCount = allEvents.count - upperCardCount - lowerCardCount
        if UserDefaults.standard.bool(forKey: "isGoodAnswer") && cardIsDropped{
            id = allEvents[indexUpperStack].id
            for event in fetchRequest{
                if event.wrappedId == id {
                    event.numberOfGoodAnswers = event.numberOfGoodAnswers + 1
                    try? moc.save()
                }
            }
        }else if cardIsDropped && !UserDefaults.standard.bool(forKey: "isGoodAnswer"){
            id = allEvents[indexLowerStack].id
            for event in fetchRequest {
                if event.wrappedId == id {
                    event.numberOfBadAnswers = event.numberOfBadAnswers + 1
                    try? moc.save()
                }
            }
        }
        func initialiseArray() {
            for n in 0..<numberOfEvents {
                arrayOfIndex.append(n)
            }
            arrayOfIndex.shuffle()
        }
        cardIsDropped = false
    }
    
}

struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        
        if #available(iOS 15.0, *) {
            StudyView(selectedTheme: "French History".localized)
                .previewInterfaceOrientation(.portrait)
        } else {
            // Fallback on earlier versions
        }
        
    }
}

