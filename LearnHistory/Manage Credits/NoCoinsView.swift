//
//  NoCoinsView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-06-18.
//

import SwiftUI

struct NoCoinsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    @FetchRequest var fetchRequest: FetchedResults<HistoricalEventDetail>
    var selectedTheme: String
    @Binding var questionSection: QuestionSection
    @Binding var hintButtonIsVisible: Bool
    @Binding var fromNoCoinsView: Bool
    init (selectedTheme: String, questionSection: Binding<QuestionSection>, hintButtonIsVisible: Binding<Bool>, fromNoCoinsView: Binding<Bool>){
        self.selectedTheme = selectedTheme
        _fetchRequest = FetchRequest<HistoricalEventDetail>(sortDescriptors: [
            NSSortDescriptor(keyPath: \HistoricalEventDetail.order, ascending: true)])
        _questionSection = questionSection
        _hintButtonIsVisible = hintButtonIsVisible
        _fromNoCoinsView = fromNoCoinsView
        
    }
    var body: some View {
        ZStack {
            ColorReference.darkGreen
            VStack {
                Image("H5")
                    .resizable()
                    .frame(width: deviceHeight * 0.1, height: deviceHeight * 0.1, alignment: .center)
                    .padding(.top)
                Text("Learn History")
                    .fontWeight(.bold)
                    .font(.caption)
                    .textCase(.uppercase)
                    .foregroundColor(ColorReference.lightGreen)
                    .multilineTextAlignment(.center)
                Text("You are out of coins!")
                    .foregroundColor(ColorReference.lightGreen)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
               
                VStack {
                    Spacer()
                    Button(action:
                            {
                        questionSection = .showCoinMangementView
                        hintButtonIsVisible = false
                        fromNoCoinsView = true
                    
                    },
                           label: {
                        Text("Buy some coins")
                            .fontWeight(.bold)
                            .italic()
                            .textCase(.uppercase)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                    })
                    Spacer()
                    Button(action:
                            {
                        EraseQuizResult.erase(fetchRequest: fetchRequest, theme: selectedTheme)
                        try? moc.save()
                        let score = UserDefaults.standard.double(forKey: selectedTheme)
                        if UserDefaults.standard.double(forKey: selectedTheme) < score {
                            UserDefaults.standard.set(score, forKey: selectedTheme)
                        }
                        presentationMode.wrappedValue.dismiss()
                        
                    },
                           label: {
                        
                        Text("Exit the Quiz")
                            .fontWeight(.bold)
                            .italic()
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.headline)
                    })
                    Text("It will reset the quiz")
                        .font(.caption)
                        .foregroundColor(ColorReference.lightGreen)
                    Spacer()
                        
                }
                .padding()
            }
            
        }
        .navigationBarHidden(true)

        
    }
}


struct NoCoinsView_Previews: PreviewProvider {

    static var previews: some View {
        NoCoinsView(selectedTheme: "Rome", questionSection: .constant(.showCoinMangementView), hintButtonIsVisible: .constant(false), fromNoCoinsView: .constant(true))
    }
}
