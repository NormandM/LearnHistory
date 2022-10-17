//
//  ContentView.swift
//  PrticleEffects
//
//  Created by Normand Martin on 2022-08-06.
//

import SwiftUI

struct ParticleEffectView: View {
    var body: some View {
        ZStack {
            Color.black
            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)
                .modifier(ParticlesModifier(delay: 0.0))
                .offset(x: -100, y : -50)
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 12, height: 12)
                    .modifier(ParticlesModifier(delay: 1.0))
                    .offset(x: 60, y : 100)
            Circle()
                .fill(Color.blue)
                .frame(width: 12, height: 12)
                .modifier(ParticlesModifier(delay: 2.0))
                .offset(x: 100, y : -50)
            
        }
        .ignoresSafeArea()
    }
}

struct ParticleEffectView_Previews: PreviewProvider {
    static var previews: some View {
        ParticleEffectView()
    }
}
