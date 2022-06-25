//
//  ExtensionForTo Localize.swift
//  LearnHistory
//
//  Created by Normand Martin on 2022-04-05.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
