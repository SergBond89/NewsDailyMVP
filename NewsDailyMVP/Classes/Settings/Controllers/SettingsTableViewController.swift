//
//  SettingsTableViewController.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/18/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import L10n_swift

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var languageSC: UISegmentedControl!

    private let langManager = LangManager.current
    
    var selectedLang: String!
    let userDefaults = UserDefaults.standard
    
    let languageKey = "languageKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        
    }
    
    func loadSettings() {
        setTitle()
        languageSC.selectedSegmentIndex = userDefaults.integer(forKey: languageKey)
    }
    
    
    func setTitle() {
        navigationItem.title = lsSettings
    }
    
    @IBAction func languageSCAction(_ sender: UISegmentedControl) {
        userDefaults.set(languageSC.selectedSegmentIndex, forKey: languageKey)
        selectedLang = langManager.langArray[languageSC.selectedSegmentIndex]
        PrefsManager.current.lang = selectedLang
        L10n.shared.language = selectedLang
        
        UIView.transition(with: UIApplication.shared.windows[0], duration: 0.5, options: .transitionFlipFromRight, animations: {
            
            UIApplication.shared.windows[0].rootViewController = UIStoryboard(
                name: "TabBar",
                bundle: nil
                ).instantiateInitialViewController()}, completion: nil)
        LangManager.current.initLanguages() 
  
    }
    
}
