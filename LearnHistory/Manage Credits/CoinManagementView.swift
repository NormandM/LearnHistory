//
//  CoinManagement.swift
//  HistoryCards
//
//  Created by Normand Martin on 2020-05-13.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import SwiftUI
import StoreKit
import Combine

struct CoinManagementView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    @Binding var questionSection: QuestionSection
    @ObservedObject var monitor = NetworkMonitor()
    var iapManager = IAPManager()
    @State private var showingAlertNoConnection = false
    @State private var price = ""
    @ObservedObject var products = productsDB.shared
    @State private var stringCoin = String(UserDefaults.standard.integer(forKey: "coins"))
    @State private var showAlertPurchased = false
    @Binding var coins: Int
    @State private var coinsPurchased = UserDefaults.standard.bool(forKey: "coinsPurchased")
    @Binding var nextButtonIsVisible: Bool
    @Binding var hintButtonIsVisible: Bool
    @Binding var fromNocoinsView: Bool
    var lastQuizSection: QuestionSection
    let publisher = IAPManager.shared.purchasePublisher
    var body: some View {
            ZStack {
                ColorReference.lightGreen
                VStack {
                    Spacer()
                    HStack {
                        VStack {
                            Text("Need any coins?")
                                .font(.headline)
                            Text("CREDIT: ".localized + "\(self.stringCoin)" + " coins".localized)
                                .foregroundColor(ColorReference.red)
                                .font(.headline)
                                .fontWeight(.heavy)
                                .padding()
                            Text("To preserve the visual integrity and user experience there are no adds in Learn History+.")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .italic()
                                .multilineTextAlignment(.center)
                                .padding()
                                .border(Color.black, width: 1)
                        }
                    }
                    .frame(width: deviceHeight > deviceWidth ? deviceWidth * 0.85 : deviceWidth * 0.7)
                    .padding(.top)
                    Spacer()
                    VStack{
                        VStack {
                        Text("Do you enjoy LEARN HISTORY?\nBuy 200 coins for ".localized + "\(self.price)".localized + ",\nit will last you forever!".localized)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .font(.footnote)

                        Button(action: {
                            if !monitor.isConnected {
                                self.showingAlertNoConnection = true
                            }else{
                                _ = IAPManager.shared.purchaseV5(product: self.products.items[0])
                            }
                        }){
                            Image("StyleCoin").renderingMode(.original)
                                .resizable()
                                .frame(width: deviceHeight * 0.12
                                       , height: deviceHeight * 0.12)
                        }
                        .alert(isPresented: self.$showingAlertNoConnection) {
                            Alert(title: Text("You are not connected to the internet"), message: Text("You cannot make a purchase"), dismissButton: .default(Text("OK")){
                                })
                        }
                            HStack{
                                Text("200 coins for: ")
                                    .fontWeight(.bold)
                                Text("\(self.price)".localized)
                                    .foregroundColor(ColorReference.red)
                                    .fontWeight(.bold)
                                    
                            }
                            .font(.caption)
                            
                        }
                       .frame(width: deviceHeight > deviceWidth ? deviceWidth * 0.85 : deviceWidth * 0.7)
                        
                    }
                    Spacer()
                        Button{
                            self.coins =  UserDefaults.standard.integer(forKey: "coins")
                            if coins < 0 {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            if fromNocoinsView {
                                questionSection = .multipleChoiceQuestionNotAnswered
                            }else if lastQuizSection == .menuPage{
                                self.presentationMode.wrappedValue.dismiss()
                            }else{
                                questionSection = lastQuizSection
                            }
                            
                            nextButtonIsVisible =  false
                            hintButtonIsVisible = true
                            fromNocoinsView = false
                        }label: {
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }
                        .buttonStyle(ArrowButton())
                    Spacer()
                }
            }
            .onAppear{
                if !monitor.isConnected{

                }else{
                    IAPManager.shared.startObserving()
                    self.price = IAPManager.shared.getPriceFormatted(for: self.products.items[0]) ?? ""
                }
            }
            .onDisappear{
                IAPManager.shared.stopObserving()
            }

        .onReceive(publisher, perform: {value in
            self.stringCoin = value.0
            self.showAlertPurchased = true
            UserDefaults.standard.set(true, forKey: "coinsPurchased")
            self.coinsPurchased =  UserDefaults.standard.bool(forKey: "coinsPurchased")
        })
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
    
    
}

struct CoinManagement_Previews: PreviewProvider {
    static var previews: some View {
        CoinManagementView(questionSection: .constant(.showCoinMangementView), coins: .constant(10), nextButtonIsVisible: .constant(false), hintButtonIsVisible: .constant(false), fromNocoinsView: .constant(true), lastQuizSection: .multipleChoiceQuestionNotAnswered)
        
    }
}

