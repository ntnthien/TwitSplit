//
//  TweetServiceTest.swift
//  TwitSplitTests
//

import XCTest
@testable import TwitSplit

class TweetServiceTests: XCTestCase {
    
    // MARK: - Setup
    
    let stubbedUser = User(id: UUID(), name: "Do Nguyen", avatarUrl: nil)
    let service = TweetService()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test validation
    
    func testValidateEmptyString() {
        let content = ""
        let expect = TweetError.empty
        let result = service.validateEmptyString(content: content)
        XCTAssertNotNil(result, "Should not be nil")
        XCTAssertEqual(result!, expect, "Should return .empty error")
    }
    
    func testValidateMessageContainsOneWordExcessMaximum() {
        let content = StringHelper.randomString(length: service.config.maxCharCount)
        let expect = TweetError.charsCountExccess
        let components = content.splitComponents(charSet: self.service.config.charSet)
        
        let result = service.validateMaxCharCount(components: components, maxCharCount: service.config.maxCharCountAvoidCounter)
    
        XCTAssertNotNil(result, "Should not be nil")
        XCTAssertEqual(result!, expect, "Should return .charsCountExccess error")
    }
    
    // MARK: - Test combineContentWithCounter()
    func testCombineContentWithCounter(){
        let content = StringHelper.randomString(length: service.config.maxCharCountAvoidCounter)
        let expect = "3/4 \(content)"
        
        let result = service.combineContentWithCounter(content: content, lineIndex: 2, lineCount: 4)
        
        XCTAssertEqual(result, expect, "Should combine with counter `<index+1>/<count> <content>`")
    }
    
    // MARK: - Test postTweet()
    
    func testPostEmptyString() {
        let content = ""
        let expect = TweetError.empty
        
        let result = service.postTweet(content: content, user: stubbedUser)
        
        switch result {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, expect.localizedDescription, "Should return empty content Error")
        case .success:
             XCTFail("Should not return Tweet")
        }
    }
    
    func testPostContentEqualMaxCharCount() {
        let content = StringHelper.randomString(length: service.config.maxCharCountAvoidCounter)
        let expect = [content]
        
        let result = service.postTweet(content: content, user: stubbedUser)
        
        XCTAssertEqual(content.count, service.config.maxCharCountAvoidCounter , "Input should equal max char count")

        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let result):
            XCTAssertEqual(result.count, 1, "Should have 1 Tweet entry")
            XCTAssertEqual(result.map { $0.content }, expect, "Should have the same content")
        }
    }
    
    func testPostAWordLengthLessThanMaxCount() {
        let content = "Put teardown code here."
        let expect = ["Put teardown code here."]
        
        let result = service.postTweet(content: content, user: stubbedUser)
        
        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let result):
            XCTAssertEqual(result.count, 1, "Should have 1 Tweet entry")
            XCTAssertEqual(result.map { $0.content }, expect, "Should have the same content")
            XCTAssertEqual(result.first.map { $0.user.id }, stubbedUser.id, "Should contain the same user UUID")
        }
    }
    
    func testPostMessageContainsMultipleWordsExcessMaximum() {
        let content = "abcd " + StringHelper.randomString(length: service.config.maxCharCountAvoidCounter + 1) + " Do Nguyen"
        let expect = TweetError.charsCountExccess
        
        let result = service.postTweet(content: content, user: stubbedUser)
        
        switch result {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, expect.localizedDescription, "Should return empty content Error")
        case .success:
            XCTFail("Should not return Tweet")
        }
    }
    
    func testPostMessageContainsMultipleWords() {
        let randomString = StringHelper.randomString(length: service.config.maxCharCountAvoidCounter) // Generate String that have max length
        let content = "abcd " + randomString
        let expect = ["1/2 abcd", "2/2 \(randomString)"]
        
        let result = service.postTweet(content: content, user: stubbedUser)
        
        switch result {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .success(let result):
            XCTAssertEqual(result.count, 2, "Should have 2 Tweet entry")
            XCTAssertEqual(result.map { $0.content }, expect, "Should have the same content")
            XCTAssertEqual(result.first.map { $0.user.id }, stubbedUser.id, "Should contain the same user UUID")
        }
    }
}
