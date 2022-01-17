//
//  EventViewModel.swift
//  FirstQuizTest
//
//  Created by Normand Martin on 2021-11-06.
//

import Foundation

class EventViewModel: ObservableObject {
    @Published var events: [Event]
    let plistPath = Bundle.main.path(forResource: "FrenchHistory", ofType: "plist")
    init () {
        var eventsArray = [[String]]()
        if let path = plistPath,  let eventNSArray = NSArray(contentsOfFile: path){
            eventsArray = eventNSArray as! [[String]]
        }else{
            eventsArray = []
        }
        var allEvents = [Event]()
        for event in eventsArray {
            var newCard = event[9].replacingOccurrences(of: " ", with: "\n")
            newCard = event[9].replacingOccurrences(of: " ", with: "\n")
            newCard = newCard.replacingOccurrences(of: " ", with: "\n")
            allEvents.append(Event(date: event[0], question: event[1], correctTAnswer: event[2], incorrectAnswer1: event[3], incorrectAnswer2: event[4], incorrectAnswer3: event[5], wikiSearchWord: event[6], questionTrueOrFalse: event[7], trueOrFalseAnswer: event[8], timeLine: newCard))
        }
        events = allEvents
    }

}
