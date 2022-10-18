//
//  AlreadyAnExpertView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-06-04.
//

import SwiftUI

struct AlreadyAnExpertView: View {
    @Environment(\.dismiss) private var dismiss
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
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
                    .padding()
                    .foregroundColor(.black)
                    .font(.title)
                    .multilineTextAlignment(.center)
                VStack {
                    Text("The History of ")
                        .foregroundColor(.black)
                        .font(.title)
                    Text(theme)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ColorReference.darkGreen)
                }
                .multilineTextAlignment(.center)
                .preferredColorScheme(.dark)
                Spacer()
                Text("Do you want to start over?")
                    .font(.headline)
                    .foregroundColor(.black)
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
            .navigationBarBackButtonHidden(true)
        }
    }
    func buttonAction() {
        withAnimation {
            startOver = true
            UserDefaults.standard.set(0.0, forKey: theme)
        }
        
    }
    func buttonAction2() {
        dismiss()
    }
    
}

struct AlreadyAnExpertView_Previews: PreviewProvider {
    static var previews: some View {
        AlreadyAnExpertView(theme: "France", startOver: .constant(false))
    }
}
