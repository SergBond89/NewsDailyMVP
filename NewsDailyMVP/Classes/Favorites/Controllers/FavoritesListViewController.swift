//
//  FavoritesListViewController.swift
//  NewsDailyMVP
//
//  Created by Sergey on 8/12/19.
//  Copyright © 2019 SergBondCompany. All rights reserved.
//

import UIKit
import CoreData

protocol FavoritesListViewControllerType: class {
    func updateList()
    func setTitle()
}

class FavoritesListViewController: UIViewController {
    
    var presenter: FavoritesListPresenterType!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FavoritesListPresenter(view: self)
        configureTableView()
        presenter.newsListViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.newsListViewWillAppear()
        presenter.fetchResultsController.delegate = self
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

// MARK: - FavoritesListViewControllerType

extension FavoritesListViewController: FavoritesListViewControllerType {
    func updateList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func setTitle() {
        navigationItem.title = NSLocalizedString("Favorites News", comment: "")
    }
}

// MARK: - Fetch results controller delegate

extension FavoritesListViewController: NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        presenter.articles = controller.fetchedObjects as! [Article]
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// MARK: - UITableView

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countOfArticles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FavoritesListTableViewCell", for: indexPath) as! FavoritesListTableViewCell
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
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: NSLocalizedString("Delete", comment: "")) { (action, indexPath) in
            self.presenter.deleteArticle(by: indexPath)
        }
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [delete]
    }
    
}
