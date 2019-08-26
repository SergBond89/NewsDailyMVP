//
//  NewsAPIManager.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/6/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import Foundation

class NewsAPIManager {
    
    private let apiKey = "d9e1bc5a6b834a4d8c0de8afd83d9295"
    private var isNextPage = false
    
    func getNews(selectedCountry: String, selectedCategory: String, numberOfPage: Int, completion: @escaping (_ news: [Articles], _ isNextPage: Bool) -> ()){
        
        let url = URL(string: "https://newsapi.org/v2/top-headlines")!
        var request = URLRequest(url: url)
        let pageQueryItem = URLQueryItem(name: "page", value: String(numberOfPage))
        let keyQueryItem = URLQueryItem(name: "apiKey", value: apiKey)
        let countryQueryItem = URLQueryItem(name: "country", value:  selectedCountry)
        let categoryQueryItem = URLQueryItem(name: "category", value: selectedCategory)
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [pageQueryItem, countryQueryItem, categoryQueryItem, keyQueryItem]
        request.url = urlComponents.url!
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            
            guard let data = data else { return }
            do {
                let news = try JSONDecoder().decode(News.self, from: data)
                let countOfPage = Int(news.totalResults/20) + 1
                if countOfPage - numberOfPage > 0 {
                    self.isNextPage = true
                } else {
                    self.isNextPage = false
                }
                completion(news.articles, self.isNextPage)
            } catch let error {
                print(error)
            }
            }.resume()
        
    }
}


