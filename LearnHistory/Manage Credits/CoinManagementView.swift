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
    var iapManager = IAPManager()
    @State private var isNotConnectedNoReason = false
    @State private var showingAlertNoConnection = false
    @State private var showNoCoinsPurchased = false
    @State private var price = ""
    @ObservedObject var products = productsDB.shared
    @State private var stringCoin = String(UserDefaults.standard.integer(forKey: "coins"))
    @State private var showAlertPurchased = false
    @Binding var coins: Int
    @State private var coinsPurchased = UserDefaults.standard.bool(forKey: "coinsPurchased")
    @Binding var nextButtonIsVisible: Bool
    @Binding var hintButtonIsVisible: Bool
    @Binding var fromNocoinsView: Bool
    let publisher = IAPManager.shared.purchasePublisher
    var body: some View {
            ZStack {
                ColorReference.lightGreen
                VStack {
                    Spacer()
                    HStack {
                        VStack {
                            Text("CREDIT AVAILABLE: ".localized + "\(self.stringCoin)" + " coins".localized)
                                .foregroundColor(ColorReference.red)
                                .font(.headline)
                                .fontWeight(.heavy)
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
                    .frame(width: deviceHeight > deviceWidth ? deviceWidth * 0.85 : deviceWidth * 0.5, height: deviceHeight * 0.25)
                    .padding(.top)
                    
                    VStack{
                        VStack {
                        Text("Do you enjoy LEARN HISTORY?\nBuy 200 coins for ".localized + "\(self.price)".localized + ",\nit will last you forever!".localized)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .padding(.bottom)

                        Button(action: {
                            if self.isNotConnectedNoReason {
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
                            HStack{
                                Text("200 coins for: ")
                                    .fontWeight(.bold)
                                Text("\(self.price)".localized)
                                    .foregroundColor(ColorReference.red)
                                    .fontWeight(.bold)
                                    
                            }
                            .font(.caption)
                            
                        }
                        .frame(width: deviceHeight > deviceWidth ? deviceWidth * 0.85 : deviceWidth * 0.5, height: deviceHeight * 0.40)
                        
                    }

                        Button{
                            self.coins =  UserDefaults.standard.integer(forKey: "coins")
                            questionSection = .multipleChoiceQuestionNotAnswered
                            nextButtonIsVisible =  false
                            hintButtonIsVisible = true
                            fromNocoinsView = false
                        }label: {
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }
                        .buttonStyle(ArrowButton())
                        .opacity(questionSection == .multipleChoiceQuestionNotAnswered ? 0.0 : 1.0)
                        .padding()
                }
            }
            .alert(isPresented: self.$showingAlertNoConnection) {
                Alert(title: Text("You are not connected to the internet"), message: Text("You cannot make a purchase"), dismissButton: .default(Text("OK")){
                    })
            }
            .alert(isPresented: self.$showAlertPurchased) {
                Alert(title: Text("200 coins were added to your credit"), message: Text("Back to the quiz!"), dismissButton: .default(Text("OK")){
                    UserDefaults.standard.set(true, forKey: "coinsPurchased")
                    self.coinsPurchased =  UserDefaults.standard.bool(forKey: "coinsPurchased")
                    })
            }

            
            .onAppear{
                print("price: \(self.price)")
                print(self.products.items[0])
                IAPManager.shared.startObserving()
                self.price = IAPManager.shared.getPriceFormatted(for: self.products.items[0]) ?? ""
                let reachability = Reachability()
                let isConnected = reachability.isConnectedToNetwork()
                IAPManager.shared.getProductsV5()
                self.isNotConnectedNoReason = false
                if !isConnected{
                    self.isNotConnectedNoReason = true
                    print("not connected")
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
        .ignoresSafeArea()
        .navigationTitle("Need any coins?")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            presentationMode.wrappedValue.dismiss()

        }){
            if fromNocoinsView {
                Text("")
            }else{
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .padding()

            }


        })
    }
    
}

struct CoinManagement_Previews: PreviewProvider {
    static var previews: some View {
        CoinManagementView(questionSection: .constant(.showCoinMangementView), coins: .constant(10), nextButtonIsVisible: .constant(false), hintButtonIsVisible: .constant(false), fromNocoinsView: .constant(true))
        
    }
}

