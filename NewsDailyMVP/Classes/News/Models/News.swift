//
//  News.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/6/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import Foundation

struct News: Codable {
    var status: String
    var totalResults: Int
    var articles: [Articles]
    
}
