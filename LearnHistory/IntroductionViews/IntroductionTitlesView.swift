//
//  IntroductionTitles.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-01-30.
//

import SwiftUI

struct IntroductionTitlesView: View {
    @Binding var isQuizSelectionView: Bool
    @Binding var isTimeLineView: Bool
    @Binding var isViewStudy: Bool
    @Binding var isViewManageCredit: Bool
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var body: some View {
        ZStack {
            ColorReference.darkGreen
            VStack {
                Image("H5")
                    .resizable()
                    .frame(width: deviceHeight * 0.15, height: deviceHeight * 0.15, alignment: .center)
                    .padding(.top)
                Text("Learn History")
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(ColorReference.lightGreen)
                    .multilineTextAlignment(.center)
                VStack {
                    Spacer()
                    Button(action:
                            {
                        isTimeLineView =  true
                    },
                           label: {
                        Text("Timelines")
                            .fontWeight(.bold)
                            .italic()
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.headline)
                            
                        
                    })
                    Text("Events and Dates")
                        .font(.caption)
                        .foregroundColor(ColorReference.lightGreen)
                    Spacer()
                    Button(action: {
                        isViewStudy =  true
                    },
                           
                           label: {
                        Text("Study")
                            .fontWeight(.bold)
                            .italic()
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.headline)
                        
                            
                    })
                    Group {
                    Text("Read and learn")
                        .font(.caption)
                        .foregroundColor(ColorReference.lightGreen)
                    Spacer()
                    Button(action: {
                        isQuizSelectionView = true
                    },
                           label: {
                        Text("Quiz")
                            .fontWeight(.bold)
                            .italic()
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.headline)
                    })
                    Text("Test your knowledge")
                        .font(.caption)
                        .foregroundColor(ColorReference.lightGreen)

                    Spacer()
                    Button(action: {
                        isViewManageCredit = true
                    },
                           label: {
                        Text("Manage your credits")
                            .italic()
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .foregroundColor(.white)
                            .font(.headline)
                            
                    })
                    }
                    Spacer()
                    
                }

            }
        }
        .navigationBarHidden(true)
    }
}

struct IntroductionTitles_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionTitlesView(isQuizSelectionView: .constant(false), isTimeLineView: .constant(false), isViewStudy: .constant(false), isViewManageCredit: .constant(false))
    }
}
