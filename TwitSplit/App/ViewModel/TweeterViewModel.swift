//
//  TweeterViewModel.swift
//  TwitSplit
//

import RxSwift
import RxCocoa

protocol TweeterViewModelType {
    var tweetsDriver: Driver<TweetResult> { get }
}

class TweeterViewModel: TweeterViewModelType {
    var tweetsDriver: Driver<TweetResult>
    let service: TweetService!
    
    init(service: TweetService = TweetService(), tweetContent: Driver<String>, tweetTap: Signal<()>) {
        self.service = service
        self.tweetsDriver = tweetTap.withLatestFrom(tweetContent).flatMapLatest { content in
            service.postTweetObserver(content: content)
                .asDriver(onErrorJustReturn: .failure(.invalid))
        }
    }
}
