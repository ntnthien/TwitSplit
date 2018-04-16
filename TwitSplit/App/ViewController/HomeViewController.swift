//
//  HomeViewController.swift
//  TwitSplit
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var tweetTextField: UITextField!
    private var viewModel: TweeterViewModel!
    private let disposeBag = DisposeBag()
    fileprivate var items = [Tweet]() {
        didSet {
            print("items: \(items)")
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.viewModel = TweeterViewModel(service: TweetService(), tweetContent: self.tweetTextField.rx.text.orEmpty.asDriver(), tweetTap: self.tweetButton.rx.tap.asSignal())
        
        self.setupTableView()
        
        // Observe tweetsDriver
        self.viewModel.tweetsDriver.drive(onNext: { [weak self] (result) in
            switch result {
            case .failure(let error):
                UIAlertController.present(title: "Error", message: "\(error)", actionTitles: ["OK"])
            case .success(let tweets):
                guard let `self` = self else { return }
                self.items += tweets
            }
        }).disposed(by: self.disposeBag)
        
    }

    // Setup Table View
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 180
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)
    }
}

// MARK: - Internal Functions

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as? TweetTableViewCell {
            let item = items[indexPath.row]
            cell.setup(item: item)
            return cell
        }
        return UITableViewCell()
    }
}
