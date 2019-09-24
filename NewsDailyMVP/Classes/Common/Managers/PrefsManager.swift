//
//  PrefsManager.swift
//  NewsDailyMVP
//
//  Created by Sergey on 9/9/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import Foundation
import L10n_swift

class PrefsManager {
    
    let langKey = "lang"
    
    static let current = PrefsManager()
    
    private init(){
        UserDefaults.standard.register(defaults: [langKey : Locale.preferredLanguages[0]]) 
    }
    
    var lang:String{
        get{
            return UserDefaults.standard.string(forKey: langKey)!
        }
        set{
            UserDefaults.standard.set(newValue, forKey: langKey)
        }
    }
}
