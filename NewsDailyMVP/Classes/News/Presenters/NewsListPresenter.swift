//
//  NewsListPresenter.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/6/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import Foundation

protocol NewsListPresenterType {
    var countOfArticles: Int { get }
    var countOfCountries: Int { get }
    var countOfCategories: Int { get }
    func getCountryByIndex(_ index: Int) -> String
    func getCategoryByIndex(_ index: Int) -> String
    func getIdCountryByIndex(_ index: Int) -> String
    func changeSelectedCountry(_ country: String)
    func changeSelectedCategory(_ category: String)
    func newsListViewDidLoad()
    func createPickerView()
    func configure(_ cell: NewsListCellType, forRow row: Int)
    func newsWasSelected(with index: Int)
    func isLastCell(indexPath: IndexPath)
}

class NewsListPresenter {
    
    
    fileprivate weak var view: NewsListViewControllerType?
    fileprivate var articles: [Articles] = []
    fileprivate let countries = NewsAPICountry.allCases
    fileprivate let categories = NewsAPICategories.allCases
    fileprivate var countriesID: [String] = []
    var selectedCountry = "us"
    var selectedCategory = ""
    private var numberOfPage = 1
    private var isNextPage = false
    
    fileprivate let apiManager: NewsAPIManager
    
    init(view: NewsListViewControllerType, apiManager: NewsAPIManager = NewsAPIManager()) {
        self.view = view
        self.apiManager = apiManager
    }
    
    func fetchNews() {
        let country = selectedCountry
        let category = selectedCategory
        apiManager.getNews(selectedCountry: country, selectedCategory: category, numberOfPage: numberOfPage) { (articles, isNextPage) in
            self.articles.append(contentsOf: articles)
            self.isNextPage = isNextPage
            self.view?.updateList()
        }
    }
    
    
}

//MARK: - NewsListPresenterType

extension NewsListPresenter: NewsListPresenterType {
    
    var countOfArticles: Int {
        return articles.count
    }
    
    var countOfCountries: Int {
        return countries.count
    }
    
    var countOfCategories: Int {
        return categories.count
    }
    
    func getCategoryByIndex(_ index: Int) -> String {
        return categories[index].rawValue
    }

    func getCountryByIndex(_ index: Int) -> String {
        return countries[index].rawValue
    }
    
    func getIdCountryByIndex(_ index: Int) -> String {
        let selectedCountry = countries[index]
        switch selectedCountry {
        case .argentina:
            return "ar"
        case .australia:
            return "au"
        case .brazil:
            return "br"
        case .canada:
            return "ca"
        case .china:
            return "cn"
        case .germany:
            return "de"
        case .france:
            return "fr"
        case .unitedKingdom:
            return "gb"
        case .hongKong:
            return "hk"
        case .ireland:
            return "ie"
        case .india:
            return "in"
        case .italy:
            return "it"
        case .netherlands:
            return "nl"
        case .norway:
            return "no"
        case .russia:
            return "ru"
        case .saudiArabia:
            return "sa"
        case .unitedStates:
            return "us"
        case .southAfrica:
            return "za"
        }
    }
    
    func changeSelectedCountry(_ country: String) {
        selectedCountry = country
    }
    
    func changeSelectedCategory(_ category: String) {
        selectedCategory = category
    }
    
    func newsListViewDidLoad() {
        fetchNews()
        view?.setTitle()
    }
    
    func createPickerView() {
        articles = []
        numberOfPage = 1
        isNextPage = false
        view?.addPikerView()
    }
    
    func configure(_ cell: NewsListCellType, forRow row: Int) {
        let title = articles[row].title
        let description = articles[row].description
        var date = articles[row].publishedAt
        date.removeLast(10)
        let imageURL = articles[row].urlToImage
        cell.setArticle(title: title, description: description, date: date, imageURL: imageURL)
    }
    
    func isLastCell(indexPath: IndexPath) {
        if articles.count > 0 {
            if indexPath.row == articles.count - 1 {
                if isNextPage == true {
                    numberOfPage += 1
                    fetchNews()
                }
            }
        }
    }
    
    func newsWasSelected(with index: Int) {
        transitionToNewsDetailsScreenFromList(by: index)
    }
}

// MARK: - Transitions

extension NewsListPresenter {
    private func transitionToNewsDetailsScreenFromList(by index: Int) {
        let newsDetailViewController = NewsDetailViewController.createFromStoryboard(named: "NewsDetailViewController")
        
        newsDetailViewController.presenter = NewsDetailPresenter(view: newsDetailViewController, article: articles[index])
        
        let transactionListViewController = view as! NewsListViewController
        transactionListViewController.navigationController?.present(newsDetailViewController, animated: true, completion: nil)
    }
}

