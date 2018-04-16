//
//  HomeViewController.swift
//  TwitSplit
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var tweetTextField: UITextField!
    private var viewModel: TweeterViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.viewModel = TweeterViewModel(service: TweetService(), tweetContent: self.tweetTextField.rx.text.orEmpty.asDriver(), tweetTap: self.tweetButton.rx.tap.asSignal())
        
        self.viewModel.tweetsDriver.drive(onNext: { [weak self] (result) in
            switch result {
            case .failure(let error):
                UIAlertController.present(title: "Error", message: "\(error)", actionTitles: ["OK"])
            case .success(let tweets):
                guard let `self` = self else { return }
                tweets.forEach {
                    print($0)
                }
            }
        }).disposed(by: self.disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

