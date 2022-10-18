//
//  NMLogo.swift
//  HistoryCards
//
//  Created by Normand Martin on 2020-05-13.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import SwiftUI

struct NMLogo:  View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var xOffset: CGFloat = 300
    @State private var showContentView = false
    @State private var coins = UserDefaults.standard.integer(forKey: "coins")
    @State private var indexOfQuestion = UserDefaults.standard.integer(forKey: "indexOfQuestion")
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
       }
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                if showContentView {
                    NavigationLink(destination: IntroView(), isActive: $showContentView) {EmptyView()
                        
                    }
                }else{
                    ZStack {
                        VStack{
                            Spacer()
                            Image(colorScheme == .light ? "Normand martin Logo" : "Normand martin LogoDarkMode")
                                .resizable()
                                .frame(width: geo.size.height/2.3, height: geo.size.height/2.3)
                            Text("Apps")
                                .font(.title)
                                .offset(x: self.xOffset)
                            Spacer()
                            Spacer()
                        }
                    }
                    .onAppear{
                        withAnimation(Animation.linear(duration: 2.0).delay(1.0)) {
                            self.xOffset = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            showContentView = true
                        }
                    }
                }
                
            }.onAppear{
                if !indexOfQuestionAlreadyExist(indexOfQuestion: indexOfQuestion) {
                    UserDefaults.standard.set(0, forKey: "indexOfQuestion")
                }
                if !pointsAlreadyExists(points: coins) {
                    UserDefaults.standard.set(60, forKey: "coins")
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    func indexOfQuestionAlreadyExist(indexOfQuestion: Int) -> Bool {
        return UserDefaults.standard.object(forKey: "indexOfQuestion") != nil
    }
    func pointsAlreadyExists(points: Int) -> Bool {
        return UserDefaults.standard.object(forKey: "coins") != nil
    }
}

//struct NMLogo_Previews: PreviewProvider {
//    static var previews: some View {
//        NMLogo()
//    }
//}
