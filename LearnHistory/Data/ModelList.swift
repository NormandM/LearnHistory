//
//  ModelList.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-02-06.
//

import Foundation
struct HistorySection: Codable, Equatable, Identifiable {
    var id:UUID
    var name: String
    var themes: [Themes]
}

struct Themes: Codable, Equatable, Identifiable {
    var id:UUID
    var themeTitle: String
}
