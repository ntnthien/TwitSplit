//
//  TweeterViewModel.swift
//  TwitSplit
//

import Foundation
import RxSwift

protocol TweeterViewModelType {
    var tweetsObservable: Observable<[Tweet]> { get }
    
}

class TweeterViewModel: TweeterViewModelType {
    let tweetsVariable: Variable<[Tweet]> = Variable<[Tweet]>([])
    lazy var tweetsObservable: Observable<[Tweet]> = self.tweetsVariable.asObservable()
    
    
}
