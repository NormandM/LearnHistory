
//
//  Created by Normand Martin on 2021-11-07.
//

import SwiftUI
class QuestionViewModel: ObservableObject {
    var eventViewModel = EventViewModel()
    @Published var buttonTitles = ["", "", "", ""]
    @Published var correctAnswer = String()
    @Published var wikiSearchWord = String()
    @Published var question = String()
    @Published var trueOrFalseQuestion = String()
    @Published var trueOrFalseAnswer = String()
    @Published var indexOfQuestion = UserDefaults.standard.integer(forKey: "indexOfQuestion")

    init() {
        initialize()
    }
    func increment() {
        indexOfQuestion += 1
        initialize()
    }
    func initialize() {
        let allEvents = eventViewModel.events
        var numberOfEvents = allEvents.count
        if indexOfQuestion > numberOfEvents - 1{
            numberOfEvents = 0
            indexOfQuestion = 0
        }
        UserDefaults.standard.set(indexOfQuestion, forKey: "indexOfQuestion")
        var arrayOfTitles = [allEvents[indexOfQuestion].correctTAnswer, allEvents[indexOfQuestion].incorrectAnswer1, allEvents[indexOfQuestion].incorrectAnswer2, allEvents[indexOfQuestion].incorrectAnswer3]
        arrayOfTitles.shuffle()
        correctAnswer = allEvents[indexOfQuestion].correctTAnswer
        buttonTitles[0] = arrayOfTitles[0]
        buttonTitles[1] = arrayOfTitles[1]
        buttonTitles[2] = arrayOfTitles[2]
        buttonTitles[3] = arrayOfTitles[3]
        wikiSearchWord = allEvents[indexOfQuestion].wikiSearchWord
        question = allEvents[indexOfQuestion].question
        trueOrFalseQuestion = allEvents[indexOfQuestion].questionTrueOrFalse
        trueOrFalseAnswer = allEvents[indexOfQuestion].trueOrFalseAnswer
    }
}

