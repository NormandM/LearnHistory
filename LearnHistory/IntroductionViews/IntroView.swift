//
//  IntroView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-01-29.
//

import SwiftUI
struct IntroView: View {
    @Environment(\.managedObjectContext) var moc
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    @State private var questionSection = QuestionSection.multipleChoiceQuestionNotAnswered
    @State private var isViewTimeLines = false
    @State private var isViewStudy = false
    @State private var isQuizSelectionView = false
    @State private var isTimeLineView = false
    @State private var isViewManageCredit = false
    @State private var radius: CGFloat = 0
    @State private var opacity = 0.0
    @State private var nextButtonIsVisible = false
    @State private var hintButtonIsVisible = false
    @State private var coins = UserDefaults.standard.integer(forKey: "coins")
    @State private var fromNoCoinsView = false
    @FetchRequest(sortDescriptors: []) var historicaEvent: FetchedResults<HistoricalEvent>
    
    var body: some View {
        VStack{
            NavigationLink(destination: SelectionView(selection: "MultipleChoiceQuizView"), isActive: $isQuizSelectionView) { EmptyView()}
            NavigationLink(destination: SelectionView(selection: "TimeLinesDetailView"), isActive: $isTimeLineView) { EmptyView() }
            NavigationLink(destination: SelectionView(selection: "StudyView"), isActive: $isViewStudy) { EmptyView() }
            NavigationLink(destination: CoinManagementView(questionSection: $questionSection, coins: $coins, nextButtonIsVisible: $nextButtonIsVisible, hintButtonIsVisible: $hintButtonIsVisible, fromNocoinsView: $fromNoCoinsView), isActive: $isViewManageCredit) { EmptyView() }
            ZStack{
                ColorReference.orange
                VStack{
                    Image("H5")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .blur(radius: radius)
                        .animation(.linear(duration: 2), value: radius)
                Image("H5")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .blur(radius: radius)
                    .animation(.linear(duration: 2), value: radius)
                }
                IntroductionTitlesView(isQuizSelectionView: $isQuizSelectionView, isTimeLineView: $isTimeLineView, isViewStudy: $isViewStudy, isViewManageCredit: $isViewManageCredit)
                    .frame(width: deviceWidth * 0.85, height: deviceHeight * 0.7, alignment: .center)
                    .opacity(opacity)
                    .cornerRadius(20)
                    .animation(.linear(duration: 2), value: opacity)
            }
            .ignoresSafeArea()
        }
        .onAppear{
                IAPManager.shared.getProductsV5()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    radius = 40
                    opacity = 0.9
                }
                let listOfThemes = Bundle.main.decodeJson([HistorySection].self, from: "List.json".localized)
                if historicaEvent.count == 0 {
                    for section in listOfThemes {
                        for theme in section.themes{
                            let allEvent = Bundle.main.decode([Event].self, from: theme.themeTitle)

                            for event in allEvent {
                                let historicalEvent = HistoricalEvent(context: moc)
                                historicalEvent.id = event.id
                                historicalEvent.question = event.question
                                historicalEvent.timeLine = event.timeLine
                                historicalEvent.trueOrFalseAnswer = event.trueOrFalseAnswer
                                historicalEvent.questionTrueOrFalse = event.questionTrueOrFalse
                                historicalEvent.wikiSearchWord = event.wikiSearchWord
                                historicalEvent.incorrectAnswer3 = event.incorrectAnswer3
                                historicalEvent.incorrectAnswer2 = event.incorrectAnswer2
                                historicalEvent.incorrectAnswer1 = event.incorrectAnswer1
                                historicalEvent.correctTAnswer = event.correctTAnswer
                                historicalEvent.date = event.date
                                historicalEvent.numberOfBadAnswers = Int64(event.numberOfBadAnswers)
                                historicalEvent.numberOfGoodAnswers = Int64(event.numberOfGoodAnswers)
                                historicalEvent.numberOfGoodAnswersQuiz = Int64(event.numberOfGoodAnswersQuiz)
                                historicalEvent.numberOfBadAnswersQuiz = Int64(event.numberOfBadAnswersQuiz)
                                historicalEvent.theme = event.theme
                                historicalEvent.order = Int64(event.order)
                            }

                            try?moc.save()


                        }
                    }
                }
            
        }
        .onDisappear{
            
        }
        
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
//        if #available(iOS 15.0, *) {
//            IntroView()
//                .previewInterfaceOrientation(.portraitUpsideDown)
//        } else {
//            // Fallback on earlier versions
//        }
        IntroView()
    }
}
