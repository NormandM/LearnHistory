//
//  QuestionAnsweredView.swift
//  FirstQuizTest
//
//  Created by Normand Martin on 2021-11-23.
//

import SwiftUI

struct QuestionAnsweredView: View {
    @StateObject var questionViewModel = QuestionViewModel()
    var body: some View {
            VStack {
                Spacer()
                Text(questionViewModel.wikiSearchWord)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
    }
}

struct QuestionAnsweredView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionAnsweredView()
    }
}
