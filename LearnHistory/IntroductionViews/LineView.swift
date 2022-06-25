//
//  LineView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-05-31.
//

import SwiftUI

struct LineView: View {
    var themeText: String
    @State private var progressionNumber = 0.0
    var body: some View {
        HStack{
            Text(themeText)
                .foregroundColor(.black)
            Spacer()
            if progressionNumber == 1.0{
                Image("mortarboard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
            }
        }
        .onAppear{
          //  UserDefaults.standard.set(1.0, forKey: themeText)
            progressionNumber = UserDefaults.standard.double(forKey: themeText)
        }
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView(themeText: "Chine")
    }
}
