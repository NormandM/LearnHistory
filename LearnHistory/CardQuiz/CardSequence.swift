//
//  CardSequence.swift
//  NewHistoryCards
//
//  Created by Normand Martin on 2021-12-04.
//

import SwiftUI
class CardSequence: ObservableObject{
    @Published var upperCard = ""
    @Published var bottomCard = ""
    @Published var cardId = UUID()
    @Published var cardDateLowerCard = ""
    @Published var cardDateUpperCar = ""
    @Published var cardResponseIsLeft = false
    @Published var indexOfCard = 0
    var selectedTheme: String
    var allEvents: [Event]
    var questionViewModel: QuestionViewModel
    init (selectedTheme: String, questionViewModel: QuestionViewModel) {
        self.selectedTheme = selectedTheme
        self.allEvents = Bundle.main.decode([Event].self, from: selectedTheme)
        self.questionViewModel = questionViewModel
        initialize()
    }
    func initialize() {
        indexOfCard = questionViewModel.index
        let allCards = questionViewModel.allEvents
        var leftOrRightCard = ["L", "R"]
        var indexOfUpperCard = Int()
        var indexOfLowerCard = Int()
        let numberOfCards = allCards.count
            switch indexOfCard {
            case 0,1,2:
                indexOfUpperCard = indexOfCard
                indexOfLowerCard = indexOfCard + 3
                cardResponseIsLeft = false
            case numberOfCards - 1, numberOfCards - 2, numberOfCards - 3:
                indexOfUpperCard = indexOfCard
                indexOfLowerCard = indexOfCard - 3
                cardResponseIsLeft = true
            default:
                indexOfUpperCard = indexOfCard
                leftOrRightCard.shuffle()
                if leftOrRightCard[0] == "L" {
                    cardResponseIsLeft = true
                    indexOfLowerCard = indexOfCard - 3
                }else{
                    cardResponseIsLeft = false
                    indexOfLowerCard = indexOfCard + 3
                }
                
            }
        upperCard = allCards[indexOfUpperCard].timeLine
        cardDateUpperCar = allCards[indexOfUpperCard].date
        cardDateLowerCard = allCards[indexOfLowerCard].date
        bottomCard = allCards[indexOfLowerCard].timeLine
        cardId = allCards[indexOfLowerCard].id
        }
    
}
