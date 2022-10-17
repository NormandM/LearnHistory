//
//  Card.swift
//  NewHistoryCards
//
//  Created by Normand Martin on 2021-11-28.
//

import SwiftUI
enum DragState {
    case unknown
    case good
    case bad
}
struct Card: View {
    @State private var dragState = DragState.unknown
    @State private var dragAmount = CGSize.zero
    var clearColor: Bool
    var cardText: String
    var responseButton: AnswerButton?
    var index: Int
    var fontColorIsClear: Bool
    var onEnded: ((CGPoint,Int, String) -> Void)?
    var onChanged: ((CGPoint) -> DragState)?
    var removal: (() -> Void)? = nil
    var gradientSelection: Gradient
    var fontColor: Color?
    var fontWeight: Font.Weight?
    var fontType: Font?
    var body: some View {
        let gradientClear: Gradient = Gradient(colors: [.clear, .clear])

        ZStack {
            LinearGradient(gradient: (clearColor ? gradientClear : gradientSelection), startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            VStack{
                Text(cardText)
                    .font(fontType ?? .body)
                    .fontWeight(fontWeight ?? .regular)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .foregroundColor(fontColorIsClear ? .clear : fontColor ?? .black)
            
                    .padding(5)
                responseButton
            }
        }
        .offset(self.dragAmount)
        .zIndex(dragAmount == .zero ? 0 : 1)
        .shadow(color: .black, radius: dragAmount == .zero ? 0 : 10 )
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged{
                    self.dragAmount = CGSize(width: $0.translation.width, height: $0.translation.height)
                    self.dragState = self.onChanged?($0.location) ?? .unknown
                }
                .onEnded {
                    if self.dragState == .good {
                        self.onEnded?($0.location, self.index, self.cardText)
                        self.dragAmount = .zero
                        self.removal?()
                    }else{
                        withAnimation(.spring()){
                            self.dragAmount = .zero
                        }
                    }
                })
                    
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card( clearColor: false, cardText: "This is an example of a question", index: 0, fontColorIsClear: false, gradientSelection: Gradient(colors: [ColorReference.orange, ColorReference.red]))
    }
}
struct CardBack: View {
    var hintDemanded: Bool
    var body: some View {
        ZStack {
            ColorReference.lightGreen
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            VStack{
                Text("X")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                if hintDemanded {
                    Text("\(Coins.badAnswer1) coins")
                }else{
                    Text("\(Coins.badAnswer2) coins")
                }
                
            }
            .foregroundColor(.black)

            
            
        }
    }
    
}
enum Colors {
    case gradient
    case gradientClear
    case red
    case green
}
