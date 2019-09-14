//
//  FavoritesListPresenter.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/12/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol FavoritesListPresenterType {
    var fetchResultsController: NSFetchedResultsController<Article>! { get set }
    var articles: [Article] {get set}
    var countOfArticles: Int { get }
    func newsListViewDidLoad()
    func newsListViewWillAppear()
    func configure(_ cell: FavoritesListCellType, forRow row: Int)
    func newsWasSelected(with index: Int)
    func deleteArticle(by indexPath: IndexPath)
}

class FavoritesListPresenter {
    
    private weak var view: FavoritesListViewControllerType?
    var articles: [Article] = []
    private var news: [Articles] = []
    var fetchResultsController: NSFetchedResultsController<Article>!
    
    init(view: FavoritesListViewControllerType) {
        self.view = view
    }
    
    private func fetchNews() {
        reloadNews()
        self.view?.updateList()
    }
    private func reloadNews() {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchResultsController.performFetch()
                articles = fetchResultsController.fetchedObjects!
                news = []
                for data in articles as [NSManagedObject] {
                    if (data.value(forKey: "title") != nil){
                        var article:Articles = Articles(author: "", title: "", description: "", url: "", urlToImage: "", publishedAt: "", content: "")
                        article.author = data.value(forKey: "author") as? String
                        article.title = data.value(forKey: "title") as? String
                        article.description = data.value(forKey: "descriptions") as? String
                        article.url = data.value(forKey: "url") as? String
                        article.urlToImage = data.value(forKey: "imageUrl") as? String
                        article.publishedAt = data.value(forKey: "date") as? String ?? ""
                        article.content = data.value(forKey: "content") as? String
                        news.append(article)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - FavoritesListPresenterType

extension FavoritesListPresenter: FavoritesListPresenterType {

    var countOfArticles: Int {
        return articles.count
    }
    
    func newsListViewWillAppear(){
        fetchNews()

    }
    
    func newsListViewDidLoad() {
        view?.setTitle()
    }
    
    func configure(_ cell: FavoritesListCellType, forRow row: Int) {
        let title = articles[row].title
        let description = articles[row].descriptions
        let date = articles[row].date
        let imageURL = articles[row].imageUrl
        cell.setArticle(title: title, description: description, date: date, imageURL: imageURL)
    }
    
    func deleteArticle(by indexPath: IndexPath) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            let objectToDelete = self.fetchResultsController.object(at: indexPath)
            context.delete(objectToDelete)
            news.remove(at: indexPath.row)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func newsWasSelected(with index: Int) {
        transitionToNewsDetailsScreenFromList(by: index)
    }
}

// MARK: - Transitions

extension FavoritesListPresenter {
    private func transitionToNewsDetailsScreenFromList(by index: Int) {
        let newsDetailViewController = NewsDetailViewController.createFromStoryboard(named: "NewsDetailViewController")
        
        newsDetailViewController.presenter = NewsDetailPresenter(view: newsDetailViewController, article: news[index])
        let transactionListViewController = view as! FavoritesListViewController
        transactionListViewController.navigationController?.pushViewController(newsDetailViewController, animated: true)
    }
}
