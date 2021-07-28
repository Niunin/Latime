//
//  ViewControllerUnsplash.swift
//  iX-33
//
//  Created by Andrea Nunti on 31.03.2021.
//

import UIKit




// MARK: - Protocol

protocol UnsplashViewProtocol: AnyObject {
    
    var catalogVolume: Int { get set }
    
}

// MARK: - Object

class UnsplashViewController: UICollectionViewController {
    
    // MARK: properties
    
    var presenter: UnsplashPresenterProtocol!
    
    // views
    private var unsplashCollectionView: UnsplashCollectionView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    // TODO: Maker it private
    var catalogVolume: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: lifecycle
    
    override func loadView() {
        unsplashCollectionView = UnsplashCollectionView()
        unsplashCollectionView.delegate = self
        unsplashCollectionView.dataSource = self
        collectionView = unsplashCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        unsplashCollectionView.configureLayout(size: view.bounds.size)
    }
    
    // MARK: setup views
    
    func setupCollectionView() {
        presenter.performSearch(with: nil)
    }
    
    func setupNavigationController() {
        self.navigationController?.navigationBar.tintColor = UIColor.myAccent
        searchController.searchBar.setShowsCancelButton(true, animated: true)
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

// MARK: - UnsplashView Protocol

extension UnsplashViewController: UnsplashViewProtocol {
    
    // TODO: i should use this protocol
    
}

// MARK: - UICollectionView DataSource

extension UnsplashViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalogVolume
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnsplashCell.identifier, for: indexPath) as! UnsplashCell
        // TODO: View should not ask for data. But how then?
        presenter.getItemDataFor(index: indexPath.row){ image, choice in
            cell.configure(for: cell, choice: choice, image: image)
        }
        return cell
    }
    
}

// MARK: - UICollectionView Delegate

extension UnsplashViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.imagePicked(index: indexPath.row)
    }
    
    // MARK: context menu
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifierString = NSString(string: "\(indexPath.row)")
        return UIContextMenuConfiguration(
            identifier: identifierString,
            // TODO: implement preview provider
            previewProvider: nil,
            actionProvider: nil
        )
    }
    
}

// MARK: - UISearchBar Delegate

extension UnsplashViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        presenter.performSearch(with: searchBar.text )
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.closeScreen()
    }
}
