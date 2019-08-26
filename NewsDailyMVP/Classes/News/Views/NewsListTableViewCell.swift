//
//  NewsListTableViewCell.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/6/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import Kingfisher

protocol NewsListCellType {
    func setArticle(title: String?, description: String?, date: String, imageURL: String?)
}

class NewsListTableViewCell: UITableViewCell, NewsListCellType {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setArticle(title: String?, description: String?, date: String, imageURL: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = date
        
        DispatchQueue.main.async {
            if let urlString = imageURL {
                let url = URL(string: urlString)
                self.newsImage.kf.indicatorType = .activity
                self.newsImage.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ],
                    progressBlock: nil)
            } else {
                self.newsImage.image = UIImage(named: "placeholder")
            }
        }
    }

}
