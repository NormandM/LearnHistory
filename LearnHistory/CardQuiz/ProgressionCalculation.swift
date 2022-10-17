//
//  ProgressionCalculation.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-05-11.
//

import SwiftUI

struct Progression {
    static func calculation(fetchRequest: FetchedResults<HistoricalEventDetail>, numberOfQuestion: Int) -> CGFloat {
        var numberOfGoodAnswersQuiz = 0
        var numberOfBadAnswersQuiz = 0
        var score = CGFloat()
        for event in fetchRequest {
            if event.wrappedNumberOfGoodAnswersQuiz > 0{
                numberOfGoodAnswersQuiz = numberOfGoodAnswersQuiz + 1
            }
            if event.wrappedNumberOfBadAnswersQuiz > 0 {
                numberOfBadAnswersQuiz = numberOfBadAnswersQuiz + 1
            }
        }
        score = CGFloat(Double(numberOfGoodAnswersQuiz)/Double(numberOfQuestion))
        return score
    }
    static func message(questionViewModel: QuestionViewModel, progressNumber: CGFloat, score: Double, answerIsGood: Bool) -> ProgressionMessage {
        var progressionMessage = ProgressionMessage.inProgress
        if progressNumber >= 1.0 && score == 1.0{
            progressionMessage = .expertAchieved
            GoodAnswer5.add()
        }else if progressNumber >= 1.0{
            progressionMessage = .finished
        }
        return progressionMessage
    }
    static func numberOfAnswers(fetchRequest: FetchedResults<HistoricalEventDetail>) -> Int{
        var numberOfGoodAnswersQuiz = 0
        var numberOfBadAnswersQuiz = 0
        var numberOfAnswersQuiz = 0
        for event in fetchRequest {
            if event.wrappedNumberOfGoodAnswersQuiz > 0{
                numberOfGoodAnswersQuiz = numberOfGoodAnswersQuiz + 1
            }
            if event.wrappedNumberOfBadAnswersQuiz > 0 {
                numberOfBadAnswersQuiz = numberOfBadAnswersQuiz + 1
            }
        }
        numberOfAnswersQuiz = numberOfGoodAnswersQuiz + numberOfBadAnswersQuiz
        return numberOfAnswersQuiz
        
    }
    static func quizProgress(fetchRequest: FetchedResults<HistoricalEventDetail>) -> CGFloat{
        let numberOfAnswers = numberOfAnswers(fetchRequest: fetchRequest)
        let numberOfQuestion = fetchRequest.count
        return CGFloat(numberOfAnswers)/CGFloat(numberOfQuestion)
    }
 
}
