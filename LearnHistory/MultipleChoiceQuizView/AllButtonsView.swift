//
//  AllButtonsView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-01-16.
//

import SwiftUI

struct AllButtonsView: View {
    var body: some View {
        ZStack{
            LazyVGrid(columns: [GridItem(), GridItem()]){
                ForEach((0..<4)){buttonIndex in
                    Button{
                        
                    }label: {
                        QuizButtonTextModifier4()
                        
                    }
                }
            }
            .background(ColorReference.lightGreen)
            .cornerRadius(15)
            .padding(.leading)
            .padding(.trailing)
            Text("X")
                .foregroundColor(.black)
                .font(.system(size: 60))
                .fontWeight(.bold)
        }
    }
}

struct AllButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        AllButtonsView()
    }
}
