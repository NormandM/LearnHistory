//
//  OptionView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-03-20.
//

import SwiftUI

struct OptionView: View {
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var optionButtonActionAllCards: (() -> Void)?
    var optionBurronActionWrongCards: (() -> Void)?
    @State private var boxDimension = CGFloat()
    var body: some View {
        VStack {
            Button{
                optionButtonActionAllCards!()
            }label:{
                Text("Use All Cards")
                    .italic()
                    .fontWeight(.bold)
            }
            .padding(.bottom)
            
            Button{
                optionBurronActionWrongCards!()
            }label:{
                Text("Use incorrectly\nanswered cards")
                    .italic()
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
             
        }
        .padding()
        .background(ColorReference.darkGreen)
        .cornerRadius(25)
        .onAppear{
            if deviceWidth > deviceHeight {
               boxDimension = deviceWidth
            }else{
               boxDimension = deviceWidth
            }
            
        }
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        OptionView()
    }
}
