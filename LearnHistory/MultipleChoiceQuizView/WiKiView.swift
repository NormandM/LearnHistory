//
//  ContentView.swift
//  SearchingWikipedia
//
//  Created by Normand Martin on 2021-12-28.
//

import SwiftUI
import WikipediaKit
import ActivityIndicatorView


struct WiKiView: View {
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    @Binding var imageIsLoading: Bool
    @State private var wikiImage = ""
    var wikiSearch: String
    var questionSection: QuestionSection
    @ObservedObject var monitor = NetworkMonitor()
    @State private var wikiText = ""
    @State private var wikiTitle = ""
    var body: some View {
        ZStack {
            if questionSection == .multipleChoiceQuestionAnsweredCorrectly || questionSection == .trueOrFalseHint{
                VStack {
                    Spacer()
                    ScrollView{
                        Text(wikiTitle)
                            .foregroundColor(.white)
                            .font(.title)
                            .multilineTextAlignment(.center)
                        AsyncImage(url: URL(string: wikiImage)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else if phase.error != nil {
                                VStack {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: deviceHeight * 0.25)
                                        .foregroundColor(ColorReference.lightGreen)
                                    Text("No available image")
                                    
                                }
                                
                            } else {
                                ProgressView()
                            }
                        }
                        .background(Color.white)
                        .frame(height: deviceHeight * 0.3)
                        .padding(.top)
                        Text(wikiText)
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .padding()
                    }
                }
                .background(Color.black)

                
            }else if questionSection == QuestionSection.trueOrFalseQuestionDisplayed {
                AsyncImage(url: URL(string: wikiImage)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    }else if phase.error != nil {
                        VStack {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: deviceHeight * 0.25)
                                .foregroundColor(ColorReference.lightGreen)
                            Text("No available image")
                        }
                    } else {
                        ProgressView()
                    }
                }
                .background(Color.white)
                .frame(height: deviceHeight * 0.3)
                .padding(.top)
            }
            VStack {
                ActivityIndicatorView(isVisible: $imageIsLoading, type: .default())
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(ColorReference.lightGreen)

                Text("Loading...")
                    .foregroundColor(.black)
                    .opacity(imageIsLoading ? 1.0 : 0.0)
                    

            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            fetchWikiData(element: wikiSearch)

        }

    }
    func fetchWikiData(element: String) {
        _ = Wikipedia.shared.requestOptimizedSearchResults(language: WikipediaLanguage("en".localized), term: element){(searchResults, error) in
            guard error == nil else {return}
            guard let searchResults = searchResults else {return}
            for articlePreview in searchResults.items {
                if let image = articlePreview.imageURL{
                    wikiImage.append("\(image)")
                    imageIsLoading = false
                }else{
                    wikiImage.append(contentsOf: "H5")
                    imageIsLoading = false
                }
                wikiText.append(articlePreview.displayText)
                wikiTitle.append(articlePreview.title)
                break
            }
        }
    }
}

struct WikiView_Previews: PreviewProvider {
    static var previews: some View {
        WiKiView( imageIsLoading: .constant(true), wikiSearch: "Robespierre", questionSection: .multipleChoiceQuestionAnsweredCorrectly)
    }
}

