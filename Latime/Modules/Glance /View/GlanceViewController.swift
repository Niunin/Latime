//
//  GlanceViewController.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit
import CoreData

// MARK: - Object

class GlanceViewController: UIViewController {
    
    var presenter: GlancePresenterProtocol!
    
    private var tableView: GlanceTableView!
    
    private var model: [GlanceModel] = []
    private var numberOfRows: Int {
        get {
            model.count
        }
    }
    
    // MARK: view life cycle
    
    override func loadView() {
        tableView = GlanceTableView(self)
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationView()
    }
    
}

// MARK: - Setup Navigation Controller

extension GlanceViewController {
    
    private func setupNavigationView() {
        self.navigationController?.navigationBar.tintColor = UIColor.myAccent
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let image = UIImage(systemName: "gear")
        let navBarItemLeft = UIBarButtonItem(image: image, style: .plain , target: self, action: #selector(showPreferences))
        
        let navBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showInspector))
        navigationItem.rightBarButtonItems = [navBarItem]
        navigationItem.leftBarButtonItems = [navBarItemLeft]
    }
    
    // MARK: actions
    
    @IBAction private func showInspector() {
        presenter.showInspector(for: nil)
    }
    
    @IBAction private func showPreferences(){
        presenter.showPreferences()
    }

}

// MARK: - GlanceView Protocol

extension GlanceViewController: GlanceViewProtocol {
    
    func update(models: [GlanceModel]) {
        self.model = models
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func add(rowsTo indices: [IndexPath]) {
        tableView.insertRows(at: indices, with: .fade)
    }
    
    func remove(rowsAt indices: [IndexPath]) {
        tableView.deleteRows(at: indices, with: .fade)
    }
    
    func increaseIndicator(ofRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? GlanceMissionTVCell {
            cell.insertIndicatorMark()
        }
    }
    
    func decreaseIndicator(ofRowAt indexPath: IndexPath, mark: Int) {
        if let cell = tableView.cellForRow(at: indexPath) as? GlanceMissionTVCell {
            cell.removeIndicatorMark(at: mark)
        }
    }

    func minimizeIndicator(ofRowAt indexPath: IndexPath) {
        guard  let cell = tableView.cellForRow(at: indexPath) as? GlanceMissionTVCell else { return }
        cell.minimizeIndicator()
    }
    
    func maximizeIndicator(ofRowAt indexPath: IndexPath) {
        guard  let cell = tableView.cellForRow(at: indexPath) as? GlanceMissionTVCell else { return }
        cell.maximizeIndicator()
    }

}

// MARK: - UITableView DataSource

extension GlanceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    // FIXME: This implementation is super ugly and wrong. But i don't know how to fix. Maybe using diffable data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = model[indexPath.row]
        
        if cellData.type == .mission {
            typealias cellType = GlanceMissionTVCell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! cellType
            cell.configure(timePoint: cellData)
            return cell
        } else {
            typealias cellType = GlancePhaseTVCell
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as! cellType
            cell.configure(timePoint: cellData)
            return cell
        }
    }
    
}

// MARK: - UITableView Delegate

extension GlanceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter.cellWasTapped(AtRowWith: indexPath)
    }
    
    // MARK: context menu
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifierString = NSString(string: "\(indexPath.row)")
        return UIContextMenuConfiguration(
            identifier: identifierString,
            previewProvider: nil,
            actionProvider: { _ in
                return self.makeActionProviderMenu(indexPath)
            })
    }
    
    private func makeActionProviderMenu(_ indexPath: IndexPath) -> UIMenu {
        if tableView.cellForRow(at: indexPath) is GlanceMissionTVCell {
            return makeParentPointMenu(indexPath)
        } else {
            return makePhaseMenu(indexPath)
        }
    }
    
}

// MARK: - GlanceContextMenu protocol

extension GlanceViewController: GlanceContextMenuProtocol {
    
    func performInspect(_ indexPath: IndexPath) {
        presenter.showInspector(for: indexPath.row)
    }
    
    func performAddSubRow(_ indexPath: IndexPath) {
        presenter.add(subRowToRowAt: indexPath)
    }
    
    func performDelete(_ indexPath: IndexPath) {
        presenter.delete(rowAt: indexPath)
    }
    
}

