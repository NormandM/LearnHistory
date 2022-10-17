//
//  HistoricalEvent+CoreDataProperties.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-03-07.
//
//

import Foundation
import CoreData


extension HistoricalEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoricalEvent> {
        return NSFetchRequest<HistoricalEvent>(entityName: "HistoricalEvent")
    }

    @NSManaged public var correctTAnswer: String?
    @NSManaged public var date: String?
    @NSManaged public var id: UUID?
    @NSManaged public var incorrectAnswer1: String?
    @NSManaged public var incorrectAnswer2: String?
    @NSManaged public var incorrectAnswer3: String?
    @NSManaged public var numberOfBadAnswers: Int64
    @NSManaged public var numberOfGoodAnswers: Int64
    @NSManaged public var numberOfBadAnswersQuiz: Int64
    @NSManaged public var numberOfGoodAnswersQuiz: Int64
    @NSManaged public var question: String?
    @NSManaged public var questionTrueOrFalse: String?
    @NSManaged public var theme: String?
    @NSManaged public var timeLine: String?
    @NSManaged public var trueOrFalseAnswer: String?
    @NSManaged public var wikiSearchWord: String?
    @NSManaged public var order: Int64
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    var wrappedDate: String {
        date ?? ""
    }
    var wrappedQuestion: String {
        question ?? ""
    }
    var wrappedCorrectTAnswer: String {
        correctTAnswer ?? ""
    }
    var wrappedIncorrectAnswer1: String {
        incorrectAnswer1 ?? ""
    }
    var wrappedIncorrectAnswer2: String {
        incorrectAnswer2 ?? ""
    }
    var wrappedIncorrectAnswer3: String {
        incorrectAnswer3 ?? ""
    }
    var wrappedWikiSearchWord: String {
        wikiSearchWord ?? ""
    }
    var wrappedQuestionTrueOrFalse: String {
        questionTrueOrFalse ?? ""
    }
    var wrappedTrueOrFalseAnswer: String {
        trueOrFalseAnswer ?? ""
    }
    var wrappedTimeLine: String {
        timeLine ?? ""
    }
    var wrappedTheme: String {
        theme ?? ""
    }
    var wrappedNumberOfGoodAnswers: Int{
        Int(numberOfGoodAnswers)
    }
    var wrappedNumberOfBadAnswers: Int{
        Int(numberOfBadAnswers)
    }
    var wrappedNumberOfGoodAnswersQuiz: Int{
        Int(numberOfGoodAnswersQuiz)
    }
    var wrappedNumberOfBadAnswersQuiz: Int{
        Int(numberOfBadAnswersQuiz)
    }
    var wrappedOrder: Int{
        Int(order)
    }


}

extension HistoricalEvent : Identifiable {

}

extension HistoricalEventDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoricalEventDetail> {
        return NSFetchRequest<HistoricalEventDetail>(entityName: "HistoricalEventDetail")
    }

    @NSManaged public var correctTAnswer: String?
    @NSManaged public var date: String?
    @NSManaged public var id: UUID?
    @NSManaged public var incorrectAnswer1: String?
    @NSManaged public var incorrectAnswer2: String?
    @NSManaged public var incorrectAnswer3: String?
    @NSManaged public var numberOfBadAnswers: Int64
    @NSManaged public var numberOfGoodAnswers: Int64
    @NSManaged public var numberOfBadAnswersQuiz: Int64
    @NSManaged public var numberOfGoodAnswersQuiz: Int64
    @NSManaged public var question: String?
    @NSManaged public var questionTrueOrFalse: String?
    @NSManaged public var theme: String?
    @NSManaged public var timeLine: String?
    @NSManaged public var trueOrFalseAnswer: String?
    @NSManaged public var wikiSearchWord: String?
    @NSManaged public var order: Int64
    
    var wrappedId: UUID {
        id ?? UUID()
    }
    var wrappedDate: String {
        date ?? ""
    }
    var wrappedQuestion: String {
        question ?? ""
    }
    var wrappedCorrectTAnswer: String {
        correctTAnswer ?? ""
    }
    var wrappedIncorrectAnswer1: String {
        incorrectAnswer1 ?? ""
    }
    var wrappedIncorrectAnswer2: String {
        incorrectAnswer2 ?? ""
    }
    var wrappedIncorrectAnswer3: String {
        incorrectAnswer3 ?? ""
    }
    var wrappedWikiSearchWord: String {
        wikiSearchWord ?? ""
    }
    var wrappedQuestionTrueOrFalse: String {
        questionTrueOrFalse ?? ""
    }
    var wrappedTrueOrFalseAnswer: String {
        trueOrFalseAnswer ?? ""
    }
    var wrappedTimeLine: String {
        timeLine ?? ""
    }
    var wrappedTheme: String {
        theme ?? ""
    }
    var wrappedNumberOfGoodAnswers: Int{
        Int(numberOfGoodAnswers)
    }
    var wrappedNumberOfBadAnswers: Int{
        Int(numberOfBadAnswers)
    }
    var wrappedNumberOfGoodAnswersQuiz: Int{
        Int(numberOfGoodAnswersQuiz)
    }
    var wrappedNumberOfBadAnswersQuiz: Int{
        Int(numberOfBadAnswersQuiz)
    }
    var wrappedOrder: Int{
        Int(order)
    }


}

extension HistoricalEventDetail : Identifiable {

}
