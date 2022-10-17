//
//  NoInternetConnectionView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-10-08.
//

import SwiftUI

struct NoInternetConnectionView: View {
    @Binding var questionSection: QuestionSection
    var selectedTheme: String
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("There is no\ninternet connection.")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    
                Text("The information on this page cannot be displayed. You can however continue with the quiz.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .padding()
                Spacer()
                Button(action: {
                    questionSection = .trueOrFalseQuestionDisplayed
                },
                       label: {
                    Image(systemName: "arrow.right")
                        .font(.title)
                })
                .buttonStyle(ArrowButton())
                .padding(.bottom)
            }
            .frame(width: 350, height: deviceHeight * 0.6)
            .border(.white)

        }
        .navigationTitle(selectedTheme)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct NoInternetConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoInternetConnectionView(questionSection: .constant(.noInternetConnection), selectedTheme: "France")
    }
}
