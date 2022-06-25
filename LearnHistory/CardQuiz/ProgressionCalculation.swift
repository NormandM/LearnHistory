//
//  ProgressionCalculation.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-05-11.
//

import SwiftUI

struct Progression {
    static func calculation(fetchRequest: FetchedResults<HistoricalEvent>, numberOfQuestion: Int) -> CGFloat {
        var numberOfGoodAnswers = 0
        var numberOfBadAnswers = 0
        var score = CGFloat()
        for event in fetchRequest {
            if event.wrappedNumberOfGoodAnswersQuiz > 0{
                numberOfGoodAnswers = numberOfGoodAnswers + 1
            }
            if event.wrappedNumberOfBadAnswersQuiz > 0 {
                numberOfBadAnswers = numberOfBadAnswers + 1
            }
        }
        score = CGFloat(Double(numberOfGoodAnswers)/Double(numberOfQuestion))
        return score
    }
    static func message(questionViewModel: QuestionViewModel, progressNumber: CGFloat, score: Double, answerIsGood: Bool) -> ProgressionMessage {
        var progressionMessage = ProgressionMessage.inProgress
        print("progressNumber: \(progressNumber)")
        if progressNumber >= 1.0 && score == 1.0{
            progressionMessage = .expertAchieved
            GoodAnswer5.add()
        }else if progressNumber >= 1.0{
            progressionMessage = .finished
        }else if answerIsGood && progressNumber < 1.0{
            progressionMessage = .inProgress3QuestionFinished
        }else{
            progressionMessage = .inProgress
        }
        return progressionMessage
    }
    static func numberOfAnswers(fetchRequest: FetchedResults<HistoricalEvent>) -> Int{
        var numberOfGoodAnswers = 0
        var numberOfBadAnswers = 0
        var numberOfAnswers = 0
        for event in fetchRequest {
            if event.wrappedNumberOfGoodAnswersQuiz > 0{
                numberOfGoodAnswers = numberOfGoodAnswers + 1
            }
            if event.wrappedNumberOfBadAnswersQuiz > 0 {
                numberOfBadAnswers = numberOfBadAnswers + 1
            }
        }
        numberOfAnswers = numberOfGoodAnswers + numberOfBadAnswers
        return numberOfAnswers
        
    }
    static func quizProgress(fetchRequest: FetchedResults<HistoricalEvent>) -> CGFloat{
        let numberOfAnswers = numberOfAnswers(fetchRequest: fetchRequest)
        let numberOfQuestion = fetchRequest.count
        return CGFloat(numberOfAnswers)/CGFloat(numberOfQuestion)
    }
 
}
