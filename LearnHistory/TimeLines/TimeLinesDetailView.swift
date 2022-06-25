//
//  TimeLinesDetailView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-02-01.
//

import SwiftUI

struct TimeLinesDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var selectedTheme: String
    @FetchRequest(entity: HistoricalEvent.entity(), sortDescriptors: []) var historicaEvent: FetchedResults<HistoricalEvent>
    var fetchRequestHistoricalEvent: FetchRequest<HistoricalEvent>
    init (selectedTheme: String) {
        self.selectedTheme = selectedTheme
        fetchRequestHistoricalEvent = FetchRequest<HistoricalEvent>(entity: HistoricalEvent.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \HistoricalEvent.order, ascending: true)
        ],predicate: NSPredicate(format: "theme == %@", selectedTheme))
        UITableView.appearance().backgroundColor = .black
        
    }
    var body: some View {
        List{
            ForEach (fetchRequestHistoricalEvent.wrappedValue) {event in
                NavigationLink(destination: TimeLinesDescriptionsView(searchWord: event.wrappedWikiSearchWord)) {
                    HStack {
                        Text(event.wrappedDate)
                            .fontWeight(.semibold)
                            .frame(width: 120, alignment: .leading)
                            
                        Text(event.wrappedTimeLine)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }

                }
            }
            .listRowBackground(ColorReference.lightGreen)
        }

        .navigationTitle("History Time Lines")
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "chevron.backward")
                .foregroundColor(.white)
                .padding()
        })
        
    }
    
}

struct TimeLinesDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLinesDetailView(selectedTheme: "")
    }
}
