//
//  UserManager.swift
//  TwitSplit
//

import Foundation

class UserManager {
    private var _user: User? = nil
    public var activeUser: User? {
        get {
            return self._user
        }
    }
    
    func login(user: User) {
        self._user = user
    }
}
