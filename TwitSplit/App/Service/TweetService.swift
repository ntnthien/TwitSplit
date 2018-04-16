//
//  TweetService.swift
//  TwitSplit
//

import Foundation
import RxSwift

class TweetService {
    struct TweetConfig {
        var maxCharCount: Int
        var maxCharCountAvoidCounter: Int {
            return self.maxCharCount - 4 // Remove counter part
        }
        var charSet: CharacterSet
    }
    
    let config: TweetConfig!
    
    init(config: TweetConfig? = nil) {
        self.config = config ?? TweetConfig(maxCharCount: 50, charSet: CharacterSet.whitespacesAndNewlines)
    }
    
    // MARK: - Validation
    
    /// Validate Empty String
    func validateEmptyString(content: String) -> TweetError? {
        return content.isEmpty ? .invalid : nil
    }
    
    /// Validate Max Char Count
    func validateMaxCharCount(components: [String], maxCharCount: Int) -> TweetError? {
        return components.filter { $0.count > maxCharCount }.count > 0 ? .invalid : nil
    }
    
    /// Combine with counter `<index>/<count> <content>`
    func combineContentWithCounter(content: String, lineIndex: Int, lineCount: Int) -> String {
        return "\(lineIndex + 1)/\(lineCount) \(content)"
    }
    
    /// Process Multiple lines String
    func process(components: [String], maxCharCount: Int) -> [String] {
        var results = [String]()
        var line: String = ""
        // Run a loop to go through components and process
        components.forEach { word in
            let newString = line != "" ? line + " " + word : word
            // Case
            if newString.count < maxCharCount {
                line = newString
            } else {
                results.append(line)
                line = word
            }
        }
        
        results.append(line)
        
        return results
    }
    
    // MARK: - Tweet
    
    /// Post Tweet
    func postTweet(content: String) -> TweetResult {
        // Trim the Content first
        let trimmedContent = content.trim()
        
        // Validate Content
        if let error = self.validateEmptyString(content: trimmedContent) {
            return TweetResult.failure(error)
        }
        
        // Happy case (count < MaxCount)
        if content.count < config.maxCharCount {
            return .success([Tweet(content: content)])
        }
        
        // Start splitting into components
        let components = content.splitComponents(charSet: self.config.charSet)
        
        // Validate charCount <= maxCharCount
        if let error = self.validateMaxCharCount(components: components, maxCharCount: self.config.maxCharCountAvoidCounter) {
            return TweetResult.failure(error)
        }
        
        // Process String
        let processed: [String] = self.process(components: components, maxCharCount: config.maxCharCountAvoidCounter)
        
        // Combine with counter
        let result: [Tweet] = processed.enumerated().map { (index, content) in
            return Tweet(content: self.combineContentWithCounter(content: content, lineIndex: index, lineCount: processed.count))
        }
        
        return .success(result)
    }
    
    // Return post tweet observer
    func postTweetObserver(content: String) -> Observable<TweetResult> {
        return Observable.create {[unowned self] (observer) -> Disposable in
            let result = self.postTweet(content: content)
            
            observer.onNext(result)
            
            return Disposables.create()
        }
    }
}
