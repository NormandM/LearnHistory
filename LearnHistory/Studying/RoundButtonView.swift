//
//  RoundButtonView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-03-15.
//

import SwiftUI

struct NMRoundButton: View {
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var buttonText: String
    var buttonAction: (() -> Void)?
    @State private var buttonDiameter = CGFloat()
    var body: some View {
        Button(action: {
            buttonAction!()
        }) {
            Text(buttonText)
                .frame(width: buttonDiameter, height: buttonDiameter, alignment: .center)
                .font(.caption)
                .foregroundColor(Color.white)
                .background(ColorReference.darkGreen)
                .clipShape(Circle())
        }
        .onAppear{
            if deviceWidth > deviceHeight {
                buttonDiameter = deviceHeight
            }else{
                buttonDiameter = deviceWidth
            }
            buttonDiameter = buttonDiameter * 0.28
            if buttonDiameter > 80 {buttonDiameter = 80}
        }
    }
}

struct NMRoundButton_Previews: PreviewProvider {
    static var previews: some View {
        NMRoundButton(buttonText: "Button Action")
    }
}
