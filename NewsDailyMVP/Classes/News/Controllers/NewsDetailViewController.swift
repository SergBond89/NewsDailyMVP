//
//  NewsDetailViewController.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/9/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import SafariServices

protocol NewsDetailViewControllerType: class {
    func updateScreen(withTitle title: String?, content: String?, urlToImage: String?, url: String?)
}

class NewsDetailViewController: UIViewController, StoryboardCreation {
    
    static var storyboardType = "News"
    var presenter: NewsDetailPresenterType!
    private var urlToOpenInBrowser: String?
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var openInBrowserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.newsDetailViewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "like"), style: .plain, target: self, action: #selector(saveArticleInMyFavoriteNews))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismiss"), style: .plain, target: self, action: #selector(backButtonPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.navigationItem.rightBarButtonItem?.isEnabled = presenter.isNewsAlreadyExist()
    }
    
    @objc func saveArticleInMyFavoriteNews(){
        presenter.saveToMyFavoriteNews()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func openInBrowser(_ sender: UIButton) {
        guard let url = urlToOpenInBrowser else { return }
        let svc = SFSafariViewController(url: URL(string: url)!)
        present(svc, animated: true, completion: nil)
    }
    
}

// MARK: - NewsDetailViewControllerType

extension NewsDetailViewController: NewsDetailViewControllerType {
    
    func updateScreen(withTitle title: String?, content: String?, urlToImage: String?, url: String?) {
        titleLabel.text = title
        contentLabel.text = content
        urlToOpenInBrowser = url
        
        DispatchQueue.main.async {
            if let urlString = urlToImage {
                let url = URL(string: urlString)
                self.articleImage.kf.indicatorType = .activity
                self.articleImage.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ],
                    progressBlock: nil)
            } else {
                self.articleImage.image = UIImage(named: "placeholder")
            }
        }
    }
    
}
