//
//  ContentView.swift
//  SearchingWikipedia
//
//  Created by Normand Martin on 2021-12-28.
//

import SwiftUI
import WikipediaKit
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
        return UIImage()
    }
}

struct WiKiView: View {
    
    func fetchWikiData(element: String) {
        _ = Wikipedia.shared.requestOptimizedSearchResults(language: WikipediaLanguage("en"), term: element){(searchResults, error) in
            guard error == nil else {return}
            guard let searchResults = searchResults else {return}
            for articlePreview in searchResults.items {
                if let image = articlePreview.imageURL{
                    wikiImage.append("\(image)")
                }
                wikiText.append(articlePreview.displayText)
                wikiTitle.append(articlePreview.title)
                break
            }
        }
    }
    @State private var wikiImage = ""
    var wikiSearch: String
    var questionSection: QuestionSection
    @State private var wikiText = ""
    @State private var wikiTitle = ""
    @State private var showWiki = false
    
    var body: some View {
    if questionSection == QuestionSection.multipleChoiceQuestionAnsweredCorrectly{
        VStack {
                Image(uiImage: wikiImage.load())
                    .resizable()
                    .scaledToFit()
                    .border(.blue, width: 2)

                ScrollView{
                    Text(wikiTitle)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)

                    Text(wikiText)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                }
                .border(.red, width: 2)
                .onAppear{
                    fetchWikiData(element: wikiSearch)
                }
        }
        .background(Color.black)

        }else if questionSection == QuestionSection.trueOrFalseQuestionDisplayed {
            Image(uiImage: wikiImage.load())
                .resizable()
                .scaledToFit()
                .border(.red, width: 2)
                .onAppear{
                    fetchWikiData(element: wikiSearch)
                }
        }
    }
}

struct WikiView_Previews: PreviewProvider {
    static var previews: some View {
        WiKiView(wikiSearch: "Robespierre", questionSection: .trueOrFalseQuestionDisplayed)
    }
}
