//
//  SettingsTableViewController.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/18/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    
    @IBOutlet weak var languageSC: UISegmentedControl!
    @IBOutlet weak var nightModeSwitch: UISwitch!
    
    let userDefaults = UserDefaults.standard
    
    let languageKey = "languageKey"
    let nightModeKey = "nightModeKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
    }
    
    func setLabels() {
        nameLabel.text = NSLocalizedString("Settings", comment: "")
        languageLabel.text = NSLocalizedString("Language", comment: "")
        modeLabel.text = NSLocalizedString("Night mode", comment: "")
    }
    
    func loadSettings() {
        setLabels()
        languageSC.selectedSegmentIndex = userDefaults.integer(forKey: languageKey)
        nightModeSwitch.isOn = userDefaults.bool(forKey: nightModeKey)
    }
    
    @IBAction func languageSCAction(_ sender: UISegmentedControl) {
        userDefaults.set(languageSC.selectedSegmentIndex, forKey: languageKey)
        if languageSC.selectedSegmentIndex == 0 {
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            LanguageManager.shared.setLanguage(language: .en, rootViewController: vc) { (view) in
                view.transform = CGAffineTransform(scaleX: 2, y: 2)
                view.alpha = 0
            }
        } else {
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            LanguageManager.shared.setLanguage(language: .ru, rootViewController: vc) { (view) in
                view.transform = CGAffineTransform(scaleX: 2, y: 2)
                view.alpha = 0
            }
        }
    }
    
    @IBAction func nightModeSwitchAction(_ sender: UISwitch) {
        userDefaults.set(nightModeSwitch.isOn, forKey: nightModeKey)
    }
    
}
