//
//  LangManager.swift
//  NewsDailyMVP
//
//  Created by Sergey on 9/9/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import Foundation
import L10n_swift

class LangManager{
    
    var langArray = [String]()
    
    static let current = LangManager()
    
    private init(){
        initLanguages()
    }

    func initLanguages(){
        
        langArray = L10n.supportedLanguages
        
    }

}

