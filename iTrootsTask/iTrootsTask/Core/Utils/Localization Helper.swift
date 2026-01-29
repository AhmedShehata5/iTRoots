//
//  Localization Helper.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
