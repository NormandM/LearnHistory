//
//  ParticlesModifier.swift
//  PrticleEffects
//
//  Created by Normand Martin on 2022-08-06.
//

import SwiftUI
struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    @State var delay: Double
    let duration = 7.0
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<80, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration-time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration).delay(delay)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}
