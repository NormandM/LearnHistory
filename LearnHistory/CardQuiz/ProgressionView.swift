//
//  ProgressionView.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-04-30.
//

import SwiftUI

struct CustomProgressView: View {
    var progress: CGFloat
    @Environment(\.managedObjectContext) var moc
    @State private var orientation = UIDeviceOrientation.unknown
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var numberOfAnswers: Int
    var numberOfQuestions: Int
    var score: Double
    @State private var circleDimension = CGFloat()
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(Color.gray)
            Circle()
                .trim(from: 0.0, to: min(score, 1.0))
                .stroke(AngularGradient(colors: [Color.yellow, ColorReference.orange, ColorReference.red], center: .center), style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .miter))
                .rotationEffect(.degrees(-90))
                .shadow(radius: 2)
            VStack {
                Text("Score:")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text("\(String(format: "%0.0f", score * 100))%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.black)
            
            
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
      //  .frame(width: circleDimension, height: circleDimension)
        .padding()
        .animation(.easeInOut, value: progress)
    }
    func didRotate() -> CGFloat {
        switch orientation {
        case .unknown:
            circleDimension = deviceHeight * 0.20
        case .portrait:
            circleDimension = deviceHeight * 0.20
        case .portraitUpsideDown:
            circleDimension = deviceHeight * 0.35
        case .landscapeLeft:
            circleDimension = deviceHeight * 0.20
        case .landscapeRight:
            circleDimension = deviceHeight * 0.20
        case .faceUp:
            circleDimension = deviceHeight * 0.20
        case .faceDown:
            circleDimension = deviceHeight * 0.20
        default:
            circleDimension = deviceHeight * 0.20
        }
        return circleDimension
    }
}
struct CustomProgressViewUser: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var fetchRequest: FetchedResults<HistoricalEventDetail>
    let sectionName: String
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    @State private var progress: CGFloat
    @State private var theme: String
    @State private var numberOfAnswers: Int
    @State private var numberOfQuestions: Int
    @State private var lastScore = 0.0
    @State private var score: Double
    var answerIsGood: Bool
    @State private var comment = String()
    @State private var numberOfCoinsAdded = String()
    var progressionMessage: ProgressionMessage
    init(progress: CGFloat, theme: String, progressionMessage: ProgressionMessage, numberOfAnswers: Int, numberOfQuestions: Int, score: Double, answerIsGood: Bool, sectionName: String){
        self._theme = State(wrappedValue: theme)
        self.progressionMessage = progressionMessage
        self._numberOfAnswers = State(wrappedValue: numberOfAnswers)
        self._numberOfQuestions = State(wrappedValue: numberOfQuestions)
        self._score = State(wrappedValue: score)
        self._progress = State(wrappedValue: progress)
        _fetchRequest = FetchRequest<HistoricalEventDetail>(sortDescriptors: [
            NSSortDescriptor(keyPath: \HistoricalEventDetail.order, ascending: true)
        ],predicate: NSPredicate(format: "theme == %@", theme))
        self.answerIsGood = answerIsGood
        self.sectionName = sectionName
        
    }
    var body: some View {
        ZStack {
            ColorReference.lightGreen
                .ignoresSafeArea()
            VStack {
                switch progressionMessage {
                case .finished:
                    VStack{
                        Spacer()
                        Group{
                            Text("You have finished the quiz:".localized)
                            Text("\(theme)")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.black)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        Spacer()
                        CustomProgressView(progress: progress, numberOfAnswers: numberOfAnswers, numberOfQuestions: numberOfQuestions, score: score)
                            .frame(width: deviceHeight * 0.25, height: deviceHeight * 0.25)
                            
                        
                        Text(comment)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(ColorReference.darkGreen)
                        
                        Text(numberOfCoinsAdded)
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(ColorReference.red)
                        Spacer()
                        Text("Can you achieve 100%?")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .padding()
                            .background(ColorReference.orange)
                        Spacer()
                        HStack {
                            NMRoundButton(buttonText: "Back".localized, buttonAction: {
                                lastScore = UserDefaults.standard.double(forKey: theme)
                                EraseQuizResult.erase(fetchRequest: fetchRequest, theme: theme)
                                try? moc.save()
                                UserDefaults.standard.set(score, forKey: theme)
                                presentationMode.wrappedValue.dismiss()
                            })
                            .padding(.trailing)
                        }
                    }
                    .padding()
                case .expertAchieved:
                    VStack{
                        Spacer()
                        Text("Congratulation".localized)
                            .foregroundColor(.black)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("You have scored 100% in the quiz:")
                            .foregroundColor(.black)
                            .font(.title)
                            .multilineTextAlignment(.center)
                        Text(theme.localized)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .font(.title)
                            .multilineTextAlignment(.center)
                        Text("5 coins were added to your total")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(ColorReference.red)
                            .padding()
                    Spacer()
                    Image("History Master")
                        .resizable()
                        .scaledToFit()
                        .padding()
                    Spacer()
                    HStack {
                        NMRoundButton(buttonText: "Back".localized, buttonAction: {
                            EraseQuizResult.erase(fetchRequest: fetchRequest, theme: theme)
                            try? moc.save()
                            if UserDefaults.standard.double(forKey: theme) < score {
                                UserDefaults.standard.set(score, forKey: theme)
                            }
                            presentationMode.wrappedValue.dismiss()

                            
                        })
                            .padding(.trailing)
                    }
                
                    }
                    .padding()
                    
                case .inProgress:
                    Spacer()
                    VStack {
                        Text("The quiz is in Progress".localized)
                            .font(.title)
                        
                    }
                case .inProgress3QuestionFinished:
                    Spacer()
                    VStack {
                        Text("The quiz is in Progress".localized)
                            .font(.title)
                    }
                    Text("Good Job!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(ColorReference.darkGreen)
                    Text("You answered correctly, continue!")
                        .fontWeight(.bold)
                    Text("1 coin was added to your total")
                        .font(.title)
                        .foregroundColor(ColorReference.red)
                }
                if progressionMessage != .finished && progressionMessage != .expertAchieved{
                    Spacer()
                    CustomProgressView(progress: progress, numberOfAnswers: numberOfAnswers, numberOfQuestions: numberOfQuestions, score: score)
                        
                }
                Spacer()
                
            }
            
            .onAppear{
                lastScore = UserDefaults.standard.double(forKey: theme)
                let result = determineMessage()
                comment = result.0
                numberOfCoinsAdded = result.1
                
                
            }
        }
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    func determineMessage() -> (String, String){
        if progressionMessage == .finished {
            switch score {
            case 0.0:
                comment = "Try again!".localized
                numberOfCoinsAdded = "0 coin was added to your"
            case 0.1...0.39:
                comment = "Try again!".localized
                numberOfCoinsAdded = "1 coin was added to your total".localized
                GoodAnswer1.add()
            case 0.4...0.59:
                comment = "Good!".localized
                numberOfCoinsAdded = "2 coins were added to your total".localized
                GoodAnswer2.add()
            case 0.6...0.79:
                comment = "Very Good!".localized
                numberOfCoinsAdded = "3 coins were added to your total".localized
                GoodAnswer3.add()
            case 0.8...0.99:
                comment = "Great!".localized
                numberOfCoinsAdded = "4 coins were added to your total".localized
                GoodAnswer4.add()
            case 1.0:
                GoodAnswer5.add()
            default:
                comment = "Try again!".localized
            }
            
            
        }
        return (comment, numberOfCoinsAdded)
    }
}
struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomProgressViewUser(progress: 0.50, theme: "British History".localized, progressionMessage: .finished, numberOfAnswers: 5, numberOfQuestions: 10, score: 0.45, answerIsGood: true, sectionName: "British History")
            
        }
    }
}
