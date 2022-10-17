//
//  SelectionMultipleChoiceView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-07-25.
//

import SwiftUI
import AVFoundation


struct SelectionMultipleChoiceView: View {
    @Environment(\.dismiss) private var dismiss
    var listOfThemes = Bundle.main.decodeJson([HistorySection].self, from:"List.json".localized)
    @State private var finishedNumberOfThemes = 0
    @State private var showParticleEffect = false
    @State private var sectionName = ""
    @State private var sectionNameForParticleEffect = ""
    @State private var isSectionFinished = false
    var soundPlayer = SoundPlayer.shared

    var body: some View {
        if showParticleEffect {
            ZStack {
                ParticleEffectView()
                    .transition(.asymmetric(insertion: .slide, removal: AnyTransition.opacity.animation(.linear(duration: 3.0))))
                    .navigationBarBackButtonHidden(true)
                    .onAppear{
                        soundPlayer.playSound(soundName: "Acoustic Trio", type: "wav", soundState: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                            withAnimation {
                                showParticleEffect = false
                            }
                        }
                    }
                VStack {
                    Text("Congratulation you have mastered:")
                    Text(sectionNameForParticleEffect)
                        .foregroundColor(ColorReference.lightGreen)
                        .fontWeight(.bold)
                        .padding()
                    Text("10 coins were added to your total")
                        .italic()
                        .fontWeight(.bold)
                        .font(.callout)
                        .foregroundColor(ColorReference.orange)
                }
                .preferredColorScheme(.light)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                
            }
        }else{
            if #available(iOS 16.0, *) {
                List{
                    ForEach(listOfThemes) {section in
                        Section(header: SectionHeader(text:(section.name), isSectionFinished: UserDefaults.standard.bool(forKey: section.name))){
                            if section.name != "ADDITIONAL INFORMATION".localized{
                                ForEach(section.themes) {theme in
                                    NavigationLink(destination: MultipleChoiceQuizView(selectedTheme: theme.themeTitle, sectionName: section.name)) {
                                        LineView(themeText: theme.themeTitle, fromQuiz: true)
                                            .onAppear{
                                                countNumberOfFinishedThemes(section: section, theme: theme)
                                            }
                                        
                                    }
                                }
                                .listRowBackground(ColorReference.lightGreen)
                                
                                
                            }else{
                                ForEach(section.themes){theme in
                                    NavigationLink(destination: AppInformationView(theme: theme.themeTitle)){
                                        Text(theme.themeTitle)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .italic()
                                    }
                                }
                                .listRowBackground(ColorReference.orange)
                                .headerProminence(.increased)
                            }
                        }
                        .headerProminence(.increased)
                    }
                }
                .scrollContentBackground(.hidden)
                .preferredColorScheme(.dark)
                .background(Color.black)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action : {
                    dismiss()
                }){
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding()
                })
                .navigationTitle("History themes")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear{
                    let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.appStartUpsCountKey)
                    if count >= 20 {
                        ReviewHandler.requestReview()
                        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.appStartUpsCountKey)
                    }
                    
                    
                }
            }else {

                    List{
                        ForEach(listOfThemes) {section in
                            Section(header: SectionHeader(text:(section.name), isSectionFinished: UserDefaults.standard.bool(forKey: section.name))){
                                if section.name != "ADDITIONAL INFORMATION".localized{
                                    ForEach(section.themes) {theme in
                                        NavigationLink(destination: MultipleChoiceQuizView(selectedTheme: theme.themeTitle, sectionName: section.name)) {
                                            LineView(themeText: theme.themeTitle, fromQuiz: true)
                                                .onAppear{
                                                    countNumberOfFinishedThemes(section: section, theme: theme)
                                                }
                                        }
                                    }
                                    .listRowBackground(ColorReference.lightGreen)
                                }else{
                                    ForEach(section.themes){theme in
                                        NavigationLink(destination: AppInformationView(theme: theme.themeTitle)){
                                            Text(theme.themeTitle)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .italic()
                                            
                                        }
                                    }
                                    .listRowBackground(ColorReference.orange)
                                }
                                
                            }
                            .headerProminence(.increased)
                        }
                    }
                    .preferredColorScheme(.dark)
                    .background(Color.black)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: Button(action : {
                        dismiss()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                    .navigationTitle("History themes")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear{
                        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.appStartUpsCountKey)
                        if count >= 20 {
                            ReviewHandler.requestReview()
                            UserDefaults.standard.set(0, forKey: UserDefaultsKeys.appStartUpsCountKey)
                        }
                        for section in listOfThemes {
                            for theme in section.themes {
                                countNumberOfFinishedThemes(section: section, theme: theme)
                                
                                
                            }
                        }
                        
                        
                    }

                }


        }
            
    }
        
    func countNumberOfFinishedThemes(section: HistorySection, theme: Themes){
        if sectionName != "" && sectionName != section.name {
            finishedNumberOfThemes = 0
        }
        let numberInSection = section.themes.count
        finishedNumberOfThemes = UserDefaults.standard.integer(forKey: theme.themeTitle) + finishedNumberOfThemes
        
        isSectionFinished = UserDefaults.standard.bool(forKey: section.name)
        if numberInSection == finishedNumberOfThemes && !isSectionFinished && showParticleEffect == false{
            showParticleEffect = true
            sectionNameForParticleEffect = section.name
            GoodAnswer5.add()
            GoodAnswer5.add()
            UserDefaults.standard.set(true, forKey: section.name)
        }
        sectionName = section.name
        
    }
    
}

struct SelectionMultipleChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionMultipleChoiceView()
    }
}
