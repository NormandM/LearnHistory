//
//  SelectedItem.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-03-16.
//

import SwiftUI

struct SelectedItem: View {
    var selectedTheme: String
    var body: some View {
        Text(selectedTheme)
            .foregroundColor(.white)
    }
}

struct SelectedItem_Previews: PreviewProvider {
    static var previews: some View {
        SelectedItem(selectedTheme: "British History")
    }
}
