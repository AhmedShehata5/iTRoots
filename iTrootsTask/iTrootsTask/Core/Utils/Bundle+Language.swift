//
//  Bundle+Language.swift
//  iTrootsTask
//
//  Created by Ahmed on 28/01/2026.
//

import Foundation

private var bundleKey: UInt8 = 0

class BundleEx: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static func setLanguage(_ language: String) {
        object_setClass(Bundle.main, BundleEx.self)
        
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let value = path != nil ? Bundle(path: path!) : nil
        
        objc_setAssociatedObject(
            Bundle.main,
            &bundleKey,
            value,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}
