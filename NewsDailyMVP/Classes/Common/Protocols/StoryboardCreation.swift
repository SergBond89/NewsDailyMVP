//
//  StoryboardCreation.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/9/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit

protocol StoryboardCreation where Self: UIViewController {
    static var storyboardType: String { get }
    static func createFromStoryboard(named: String) -> Self
}

extension StoryboardCreation {
    static func createFromStoryboard(named: String) -> Self {
        let storyboard = UIStoryboard(name: storyboardType, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: named) as! Self
    }
}
