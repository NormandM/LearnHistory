//
//  TimeLinesDescriptionsView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-02-03.
//

import SwiftUI

struct TimeLinesDescriptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var questionSection = QuestionSection.multipleChoiceQuestionNotAnswered
    @ObservedObject var monitor = NetworkMonitor()
    @State private var showAlertSheet = false
    @State private var imageIsLoading = false
    var searchWord: String

    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            WiKiView(imageIsLoading: $imageIsLoading, wikiSearch: searchWord, questionSection: QuestionSection.trueOrFalseHint)
                .padding()
                .alert(isPresented: $showAlertSheet) {
                    Alert(
                        title: Text("No Internet Connection"),
                        message: Text("Sorry, no information can be displayed"),
                        dismissButton: .default(Text("Ok"), action:  {
                            dismiss()
                        })
                    )
                }
                
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            dismiss()
        }){
            Image(systemName: "chevron.backward")
                .foregroundColor(.white)
        })
        .onAppear{
            if !monitor.isConnected {
                showAlertSheet = true
                imageIsLoading = false
            }else{
                imageIsLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    imageIsLoading = false
                }
                
            }
        }
    }
}

struct TimeLinesDescriptionsView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLinesDescriptionsView(searchWord: "")
    }
}
