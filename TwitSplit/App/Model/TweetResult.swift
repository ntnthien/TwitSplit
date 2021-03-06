//
//  TweetResult.swift
//  TwitSplit
//

import Foundation

enum TweetError: Error {
    case empty
    case charsCountExccess
    case invalid
    
    var localizedDesc: String {
        switch self {
        case .empty:
            return "You haven't enter any word. Please enter it!"
        case .charsCountExccess:
            return "You h. Please try again!"
        case .invalid:
            return "Oops, an error occurs. Please try again!"
        }
    }
}

enum TweetResult {
    typealias Value = [Tweet]
    typealias Error = TweetError // Aliasing TweetError to Error
    
    case success(Value)
    case failure(Error)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
