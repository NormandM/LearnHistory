//
//  LineView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-05-31.
//

import SwiftUI

struct LineView: View {
    var themeText: String
    var fromQuiz: Bool
    @State private var progressionNumber = 0.0
    var body: some View {
        HStack{
            Text(themeText)
                .foregroundColor(.black)
                .preferredColorScheme(.light)
            Spacer()
            if fromQuiz {
                if progressionNumber == 1.0 {
                    Image("mortarboard")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                    
                }else if progressionNumber > 0.0{
                    HStack {
                        Text(String(progressionNumber * 100))
                        Text("%")
                    }
                    .preferredColorScheme(.light)
                    .foregroundColor(ColorReference.darkGreen)
                }
            }
        }
        .onAppear{
            progressionNumber = UserDefaults.standard.double(forKey: themeText)
        }
    }
}

//struct LineView_Previews: PreviewProvider {
//    static var previews: some View {
//        LineView(filter: "france", themeText: "Chine", fromQuiz: false)
//    }
//}
