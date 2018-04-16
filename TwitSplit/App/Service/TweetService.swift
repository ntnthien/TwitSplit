//
//  TweetService.swift
//  TwitSplit
//

import Foundation
import RxSwift

class TweetService {
    struct TweetConfig {
        var maxCharCount: Int
    }
    
    let config: TweetConfig!
    
    init(config: TweetConfig? = nil) {
        self.config = config ?? TweetConfig(maxCharCount: 50)
    }
    
    func validate(content: String) -> TweetError? {
        guard !content.isEmpty else { return .invalid }
        return nil
    }
    
    func split(content: String) -> [String] {
        return []
    }
    
    func tweet(content: String) -> TweetResult {
        let trimmedContent = content.trim()
        if let error = self.validate(content: trimmedContent) {
            return TweetResult.failure(error)
        }
 
        
        // Happy case
        if content.count < config.maxCharCount {
            return .success([Tweet(content: content)])
        }
        
        return .success([])
    }
    
    
    func sendTweet(content: String) -> Observable<TweetResult> {
        return .empty()
    }

}
