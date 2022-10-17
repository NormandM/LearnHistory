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
    @FetchRequest(sortDescriptors: []) var historicalEvent: FetchedResults<HistoricalEvent>
    @FetchRequest(sortDescriptors: []) var historicalEventDetail: FetchedResults<HistoricalEventDetail>
    var body: some View {
        VStack{
            NavigationLink(destination: SelectionMultipleChoiceView(), isActive: $isQuizSelectionView){EmptyView()}
            NavigationLink(destination: SelectionView(selection: "TimeLinesDetailView"), isActive: $isTimeLineView) { EmptyView() }
            NavigationLink(destination: SelectionView(selection: "StudyView"), isActive: $isViewStudy) { EmptyView() }
            NavigationLink(destination: CoinManagementView(questionSection: $questionSection, coins: $coins, nextButtonIsVisible: $nextButtonIsVisible, hintButtonIsVisible: $hintButtonIsVisible, fromNocoinsView: $fromNoCoinsView, lastQuizSection: .menuPage), isActive: $isViewManageCredit) { EmptyView() }
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
// Data for List
            let listOfThemes = Bundle.main.decodeJson([HistorySection].self, from: "ListTitle.json".localized)
            for section in listOfThemes {
                for theme in section.themes{
                    let allEvent = Bundle.main.decode([Event].self, from: theme.themeTitle)
                    var idArray = [UUID]()
                    for item in historicalEvent {
                        idArray.append(item.wrappedId)
                    }
                    for event in allEvent {
                        if !idArray.contains(event.id){
                                let historicalEventNew = HistoricalEvent(context: moc)
                                historicalEventNew.id = event.id
                                historicalEventNew.question = event.question
                                historicalEventNew.timeLine = event.timeLine
                                historicalEventNew.trueOrFalseAnswer = event.trueOrFalseAnswer
                                historicalEventNew.questionTrueOrFalse = event.questionTrueOrFalse
                                historicalEventNew.wikiSearchWord = event.wikiSearchWord
                                historicalEventNew.incorrectAnswer3 = event.incorrectAnswer3
                                historicalEventNew.incorrectAnswer2 = event.incorrectAnswer2
                                historicalEventNew.incorrectAnswer1 = event.incorrectAnswer1
                                historicalEventNew.correctTAnswer = event.correctTAnswer
                                historicalEventNew.date = event.date
                                historicalEventNew.numberOfBadAnswers = Int64(event.numberOfBadAnswers)
                                historicalEventNew.numberOfGoodAnswers = Int64(event.numberOfGoodAnswers)
                                historicalEventNew.numberOfGoodAnswersQuiz = Int64(event.numberOfGoodAnswersQuiz)
                                historicalEventNew.numberOfBadAnswersQuiz = Int64(event.numberOfBadAnswersQuiz)
                                historicalEventNew.theme = event.theme
                                historicalEventNew.order = Int64(event.order)
                            }
                        }
                }
                
                try?moc.save()
            }
// Data for Quiz
            let listOfThemesDetail = Bundle.main.decodeJson([HistorySection].self, from:"List.json".localized)
                for section in listOfThemesDetail {
                    for theme in section.themes {
                        let allEvent = Bundle.main.decode([Event].self, from: theme.themeTitle)
                        var idArray = [UUID]()
                        for item in historicalEventDetail {
                            idArray.append(item.wrappedId)
                        }
                        for event in allEvent {
                            if !idArray.contains(event.id){
                                let historicalEventDetailNew = HistoricalEventDetail(context: moc)
                                historicalEventDetailNew.id = event.id
                                historicalEventDetailNew.question = event.question
                                historicalEventDetailNew.timeLine = event.timeLine
                                historicalEventDetailNew.trueOrFalseAnswer = event.trueOrFalseAnswer
                                historicalEventDetailNew.questionTrueOrFalse = event.questionTrueOrFalse
                                historicalEventDetailNew.wikiSearchWord = event.wikiSearchWord
                                historicalEventDetailNew.incorrectAnswer3 = event.incorrectAnswer3
                                historicalEventDetailNew.incorrectAnswer2 = event.incorrectAnswer2
                                historicalEventDetailNew.incorrectAnswer1 = event.incorrectAnswer1
                                historicalEventDetailNew.correctTAnswer = event.correctTAnswer
                                historicalEventDetailNew.date = event.date
                                historicalEventDetailNew.numberOfBadAnswers = Int64(event.numberOfBadAnswers)
                                historicalEventDetailNew.numberOfGoodAnswers = Int64(event.numberOfGoodAnswers)
                                historicalEventDetailNew.numberOfGoodAnswersQuiz = Int64(event.numberOfGoodAnswersQuiz)
                                historicalEventDetailNew.numberOfBadAnswersQuiz = Int64(event.numberOfBadAnswersQuiz)
                                historicalEventDetailNew.theme = event.theme
                                historicalEventDetailNew.order = Int64(event.order)
                            }
                        }
                    }
                }
            try?moc.save()
            
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
