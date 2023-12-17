//
//  LanguageViewModel.swift
//  FacePartsEditor
//
//  Created by Nguyễn Kiến Tường on 17/12/2023.
//

import Foundation

enum AppLanguage: String {
    case ENGLISH = "en"
    case VIETNAMESE = "vi"
}

class LanguageViewModel: ObservableObject {
    private static var sharedInstance: LanguageViewModel?
    class var shared : LanguageViewModel {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = LanguageViewModel()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        
        return sharedInstance
    }
    
    @Published var currentLanguage: AppLanguage = .VIETNAMESE
}

extension String {
    /// Localizes a string using given language from Language enum.
    /// - parameter language: The language that will be used to localized string.
    /// - Returns: localized string.
    func localized(_ language: AppLanguage = .VIETNAMESE) -> String {
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        return localized(bundle: bundle)
    }
    
    /// Localizes a string using self as key.
    ///
    /// - Parameters:
    ///   - bundle: the bundle where the Localizable.strings file lies.
    /// - Returns: localized string.
    private func localized(bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
