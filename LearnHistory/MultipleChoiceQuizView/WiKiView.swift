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
    @Binding var imageIsLoading: Bool
    @State private var wikiImage = ""
    var wikiSearch: String
    var questionSection: QuestionSection
    @ObservedObject var monitor = NetworkMonitor()
    @State private var wikiText = ""
    @State private var wikiTitle = ""
    @State private var showWiki = false
    @State private var showAlertSheet = false
    var body: some View {
        ZStack {
                if questionSection == .multipleChoiceQuestionAnsweredCorrectly || questionSection == .trueOrFalseHint{
                    VStack {
                        Spacer()
                        Image(uiImage: wikiImage.load())
                            .resizable()
                            .scaledToFit()
                            .background(Color.white)
                            .padding(.top)
                        ScrollView{
                            Text(wikiTitle)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                            
                            Text(wikiText)
                                .font(.title2)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .padding()
                        }
                    }
                    .background(Color.black)
                    
                }else if questionSection == QuestionSection.trueOrFalseQuestionDisplayed {
                    Image(uiImage: wikiImage.load())
                        .resizable()
                        .scaledToFit()
                        .background(Color.white)
                        .padding()
                    
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
        WiKiView( imageIsLoading: .constant(true), wikiSearch: "Robespierre", questionSection: .multipleChoiceQuestionNotAnswered)
    }
}

extension String {
    func load() -> UIImage {
        do{
            guard let url = URL(string: self) else {
                return UIImage()
            }
            let data: Data = try
            Data(contentsOf: url, options: .uncached)
            return UIImage(data:data) ?? UIImage()
        }catch{
            
        }
        return UIImage(named: "H5")!
    }
}
