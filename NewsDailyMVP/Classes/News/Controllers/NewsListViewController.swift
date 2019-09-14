//
//  NewsListViewController.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/6/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit

protocol NewsListViewControllerType: class {
    func updateList()
    func setTitle()
    func addPikerView()
    func updateListAfterChangeCountryAndCategory()
}

class NewsListViewController: UIViewController {
    var presenter: NewsListPresenterType!

    @IBOutlet weak var tableView: UITableView!
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NewsListPresenter(view: self)
        configureTableView()
        presenter.newsListViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func selectCountryAndCategory(_ sender: Any) {
        presenter.createPickerView()
    }
    
}

// MARK: - NewsListViewControllerType

extension NewsListViewController: NewsListViewControllerType {
    
    func updateList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateListAfterChangeCountryAndCategory() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.tableView.numberOfRows(inSection: 0) != 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    func addPikerView() {
        picker.delegate = self
        picker.frame = CGRect(x: 0, y: Int(UIScreen.main.bounds.height - 264), width: Int(UIScreen.main.bounds.width), height: 216)
        picker.backgroundColor = .white
        
        presenter.changeSelectedCategory(presenter.getCategoryByIndex(picker.selectedRow(inComponent: 0)))
        presenter.changeSelectedCountry(presenter.getIdCountryByIndex(picker.selectedRow(inComponent: 1)))
        view.addSubview(picker)
        addToolbar()
    }
    
    func addToolbar() {
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 314, width: UIScreen.main.bounds.size.width, height: 50))
        let doneButton = UIBarButtonItem(title: lsDone,
                                         style: .plain,
                                         target: self,
                                         action: #selector(dismissPickerView))
        toolBar.setItems([doneButton], animated: true)
        toolBar.tintColor = .blue
        toolBar.barTintColor = .white
        view.addSubview(toolBar)
    }
    
    @objc func dismissPickerView() {
        presenter.resetArticles()
        presenter.newsListUpdate()
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func setTitle() {
        navigationItem.title = lsTopNews
    }
}

// MARK: - UITableView

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countOfArticles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter.isLastCell(indexPath: indexPath)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewsListTableViewCell", for: indexPath) as! NewsListTableViewCell
        presenter.configure(cell, forRow: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.newsWasSelected(with: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UIPickerView

extension NewsListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return presenter.countOfCategories
        } else {
            return presenter.countOfCountries
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return presenter.getCategoryByIndex(row)
        } else {
            return presenter.getCountryByIndex(row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            let selectedCategory = self.presenter.getCategoryByIndex(row)
            self.presenter.changeSelectedCategory(selectedCategory)
        } else {
            let selectedCountry = self.presenter.getIdCountryByIndex(row)
            self.presenter.changeSelectedCountry(selectedCountry)
        }
        
    }
    
}
