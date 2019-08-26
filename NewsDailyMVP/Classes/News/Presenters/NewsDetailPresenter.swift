//
//  NewsDetailPresenter.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/9/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import Foundation
import UIKit

protocol NewsDetailPresenterType {
    func newsDetailViewDidLoad()
    func saveToMyFavoriteNews()
}

class NewsDetailPresenter {
    
    fileprivate weak var view: NewsDetailViewControllerType?
    fileprivate let article: Articles

    init(view: NewsDetailViewControllerType, article: Articles) {
        self.view = view
        self.article = article
    }
    
}

extension NewsDetailPresenter: NewsDetailPresenterType {
    func newsDetailViewDidLoad() {
        view?.updateScreen(withTitle: article.title, content: article.content, urlToImage: article.urlToImage, url: article.url)
    }
    func saveToMyFavoriteNews() {
        if let contex = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            let article = Article(context: contex)
            article.author = self.article.author
            article.title = self.article.title
            article.descriptions = self.article.description
            article.content = self.article.content
            var date = self.article.publishedAt
            date.removeLast(10)
            article.date = date
            article.url = self.article.url
            article.imageUrl = self.article.urlToImage
            
            do {
                try contex.save()
                print("Сохранение удалось!")
            } catch let error {
                print("Не удалось сохранить данные \(error)", error.localizedDescription)
            }
        }
    }
    
}
