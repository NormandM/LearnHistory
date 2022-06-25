//
//  FilteredView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-03-19.
//

import SwiftUI

struct FilteredView: View {
    @FetchRequest var fetchRequest: FetchedResults<HistoricalEvent>
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
        
    }
    init(filter: String) {
        _fetchRequest = FetchRequest<HistoricalEvent>(sortDescriptors: [NSSortDescriptor(keyPath: \HistoricalEvent.order, ascending: true)], predicate: NSPredicate(format: "theme == %@", filter))
    }
    var body: some View {
        List(fetchRequest, id: \.self) { event in
            HStack {
            Text(event.wrappedQuestion)
                    .fontWeight(.bold)
                    .frame(width: deviceWidth * 0.5, alignment: .leading)
                    .padding(.trailing)
                HStack {
                    VStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(ColorReference.darkGreen)
                            .padding(.bottom)
                        Text(String(event.wrappedNumberOfGoodAnswers))
                            .foregroundColor(ColorReference.darkGreen)
                    }
                    .padding(.trailing)
                    VStack {
                        Text("X")
                            .foregroundColor(ColorReference.red)
                            .padding(.bottom)
                        Text(String(event.wrappedNumberOfBadAnswers))
                            .foregroundColor(ColorReference.red)
                    }
                }
            }
        }
    }
}

struct FilteredView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredView(filter: "French History".localized)
    }
}
