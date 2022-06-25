//
//  QuizSelectionView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-01-29.
//

import SwiftUI

struct SelectionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let listOfThemes = Bundle.main.decodeJson([HistorySection].self, from:"List.json".localized)
    @State private var selection: String
    init(selection: String){
        self._selection = State(wrappedValue: selection)
        UITableView.appearance().backgroundColor = .black
    }

    var body: some View {
        List{
            ForEach(listOfThemes) {section in
                Section(header: SectionHeader(text:(section.name))){
                    ForEach(section.themes) {theme in
                        if selection == "MultipleChoiceQuizView"{
                            NavigationLink(destination: MultipleChoiceQuizView(selectedTheme: theme.themeTitle)) {
                                LineView(themeText: theme.themeTitle)
                            }
                        }else if selection == "StudyView" {
                            NavigationLink(destination: StudyView(selectedTheme: theme.themeTitle)) {
                                LineView(themeText: theme.themeTitle)
                            }
                        }else if selection == "TimeLinesDetailView"{
                            NavigationLink(destination: TimeLinesDetailView(selectedTheme: theme.themeTitle)) {
                                LineView(themeText: theme.themeTitle)
                            }
                        }
                    }
                }
                .listRowBackground(ColorReference.lightGreen)
            }
        }
        .navigationTitle("History themes")
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .padding()
        })
    }
}

struct QuizSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView(selection: "MutipleChoiceQuiz")
    }
}


