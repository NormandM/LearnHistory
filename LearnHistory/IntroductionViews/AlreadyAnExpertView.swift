//
//  AlreadyAnExpertView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-06-04.
//

import SwiftUI

struct AlreadyAnExpertView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var theme: String
    @Binding var startOver: Bool
    var body: some View {
        ZStack {
            ColorReference.lightGreen
                .ignoresSafeArea()
            VStack{
                Image("mortarboard")
                    .resizable()
                    .scaledToFit()
                    .frame(height: deviceHeight * 0.3)
                Spacer()
                Text("You are already an expert in")
                    .font(.title)
                VStack {
                    Text("The History of ")
                        .font(.title)
                        .padding(.bottom)
                    Text(theme)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ColorReference.darkGreen)
                }
                Spacer()
                Text("Do you want to start over?")
                    .font(.headline)
                Spacer()
                HStack{
                    Spacer()
                    NMRoundButton(buttonText: "Yes".localized, buttonAction: buttonAction)
                    Spacer()
                    NMRoundButton(buttonText: "No".localized, buttonAction: buttonAction2)
                    Spacer()
                }
                Spacer()
                

            }
 
        }
    }
    func buttonAction() {
        withAnimation {
            startOver = true
        }
        
    }
    func buttonAction2() {
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct AlreadyAnExpertView_Previews: PreviewProvider {
    static var previews: some View {
        AlreadyAnExpertView(theme: "France", startOver: .constant(false))
    }
}
