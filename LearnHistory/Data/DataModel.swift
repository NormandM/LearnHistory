//
//  DataModel.swift
//  FirstQuizTest
//
//  Created by Normand Martin on 2021-11-06.
//

import SwiftUI
struct Event: Codable, Equatable, Identifiable {
    var id: UUID
    var date: String
    var question: String
    var correctTAnswer: String
    var incorrectAnswer1: String
    var incorrectAnswer2: String
    var incorrectAnswer3: String
    var wikiSearchWord: String
    var questionTrueOrFalse: String
    var trueOrFalseAnswer: String
    var timeLine: String
    var theme: String
    var numberOfGoodAnswers: Int
    var numberOfBadAnswers: Int
    var numberOfGoodAnswersQuiz: Int
    var numberOfBadAnswersQuiz: Int
    var order: Int
}

struct EventDetail: Codable, Equatable, Identifiable {
    var id: UUID
    var date: String
    var question: String
    var correctTAnswer: String
    var incorrectAnswer1: String
    var incorrectAnswer2: String
    var incorrectAnswer3: String
    var wikiSearchWord: String
    var questionTrueOrFalse: String
    var trueOrFalseAnswer: String
    var timeLine: String
    var theme: String
    var numberOfGoodAnswers: Int
    var numberOfBadAnswers: Int
    var numberOfGoodAnswersQuiz: Int
    var numberOfBadAnswersQuiz: Int
    var order: Int
}



