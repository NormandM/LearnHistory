//
//  Card.swift
//  NewHistoryCards
//
//  Created by Normand Martin on 2021-11-28.
//

import SwiftUI
struct Card: View {
    @State private var dragAmount = CGSize.zero
    var clearColor: Bool
    var cardText: String
    var index: Int
    var fontColorIsClear: Bool
    var onEnded: ((CGPoint,Int, String) -> Void)?
    
    var body: some View {
        let gradient: Gradient = Gradient(colors: [ColorReference.orange, ColorReference.red])
        let gradientClear: Gradient = Gradient(colors: [.clear, .clear])
        ZStack {
            LinearGradient(gradient: clearColor ? gradientClear : gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Text(cardText)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .foregroundColor(fontColorIsClear ? .clear : .black)
        }
        .offset(self.dragAmount)
        .zIndex(dragAmount == .zero ? 0 : 1)
        .shadow(color: .black, radius: dragAmount == .zero ? 0 : 10 )
        .gesture(
            DragGesture(coordinateSpace: .global)
                .onChanged{
                    self.dragAmount = CGSize(width: $0.translation.width, height: $0.translation.height)
                }
                .onEnded {
                    self.onEnded?($0.location, self.index, self.cardText)
                    self.dragAmount = .zero
                })
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card( clearColor: false, cardText: "This is an example of a question", index: 0, fontColorIsClear: false)
    }
}
struct CardBack: View {
    var body: some View {
        ZStack {
            ColorReference.lightGreen
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Text("X")
                .font(.largeTitle)
                .fontWeight(.bold)
            
        }
    }
    
}
