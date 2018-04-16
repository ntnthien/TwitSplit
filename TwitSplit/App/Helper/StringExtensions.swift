//
//  StringExtension.swift
//  TwitSplit
//

import Foundation

extension String {
    /// Trim spaces and newlines
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Split String into String Array
    func splitComponents(charSet: CharacterSet) -> [String] {
        return self.components(separatedBy: charSet)
    }
}
