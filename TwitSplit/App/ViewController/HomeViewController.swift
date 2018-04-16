//
//  HomeViewController.swift
//  TwitSplit
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let result = TweetService().postTweet(content: "")
        
        switch result {
        case .failure(let error):
            self.presentAlert(title: "Error", message: "\(error)", actionTitles: ["OK"])
        case .success(let value):
            value.forEach { tweet in
                print("\(tweet.content)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

