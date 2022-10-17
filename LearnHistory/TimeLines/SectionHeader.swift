//
//  SectionHeader.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-02-12.
//

import SwiftUI

struct SectionHeader: View {
    let text: String
    var isSectionFinished: Bool
    var body: some View {
        HStack {
            Text(text)
                .font(.headline)
                .fontWeight(.bold)
                .frame(height: 40,alignment: .leading)
                .background(Color.black)
                .foregroundColor(Color.white)
            Spacer()
            Image(systemName: "checkmark.seal")
                .font(.largeTitle)
                .frame(height: 40,alignment: .trailing)
                .background(Color.black)
                .foregroundColor(isSectionFinished ? ColorReference.orange : Color.black)
        }
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(text: "Texttutututututuutututuututuutgggg", isSectionFinished: true)
    }
}
