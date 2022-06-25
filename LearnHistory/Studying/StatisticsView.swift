//
//  StatisticsView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-03-19.
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var selectedTheme: String
    init(selectedTheme: String) {
        self.selectedTheme = selectedTheme
    }
  
    var body: some View {
        FilteredView(filter: selectedTheme)
            .listRowBackground(ColorReference.lightGreen)
            .navigationBarTitle(selectedTheme)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "chevron.backward")
                    .foregroundColor(.white)
            })
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(selectedTheme: "French History")
    }
}
