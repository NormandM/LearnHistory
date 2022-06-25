//
//  SectionHeader.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-02-12.
//

import SwiftUI

struct SectionHeader: View {
let text: String
var body: some View {
Text(text)
        .font(.headline)
        .fontWeight(.bold)
        .padding()
            .frame(width: UIScreen.main.bounds.width, height: 28,alignment: .leading)
            .background(Color.black)
            .foregroundColor(Color.white)
            
    }
}

