//
//  GlancePresenter.swift
//  Timeboy
//
//  Created by Andrei Niunin on 02.05.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - protocol

protocol UnsplashPresenterProtocol: AnyObject {
    
    var view: UnsplashViewProtocol! { get set }
    var router: UnsplashRouterProtocol! { get set }
    var interactor: UnsplashInteractorProtocol! { get set }
    
    // view functions
    func configureView()
    func updateCollectionViewCell()
    func getItemDataFor(
        index: Int,
        completion: @escaping (_ image: UIImage?,_ imageSource: ImageSource ) -> Void
    )
    
    // router functions
    func closeScreen()
    
    // Interactor functions
    func performSearch(with query: String?)
    func imagePicked(index: Int)
    func imagesCatalogUpdated(with numberOfItems: Int)
    
}

// MARK: - Object

class UnsplashPresenter: UnsplashPresenterProtocol {
    
    // MARK: properties
    
    weak var view: UnsplashViewProtocol!
    var router: UnsplashRouterProtocol!
    var interactor: UnsplashInteractorProtocol!
    
    // MARK: view functions
    
    func configureView() {
    
    }
    
    // Presenter should not know about cell and collectin. Name it more abstract
    func updateCollectionViewCell() {
    
    }
    
    // MARK: router functions
    
    func closeScreen() {
        router.closeCurrentViewController()
    }
    
    // MARK: interactor functions
    
    // TODO: This completion is real bad. It should not go through
    func getItemDataFor(index: Int, completion: @escaping (_ image: UIImage?,_ imageSource: ImageSource ) -> Void) {
        interactor.getItemFor(index: index, completion: completion)
    }
    
    func performSearch(with query: String?) {
        interactor.orderImagesDataPackage(with: query)
    }
    
    func imagesCatalogUpdated(with numberOfItems: Int) {
        view?.catalogVolume = numberOfItems
    }
    
    func imagePicked(index: Int) {
        interactor.getFullSizeItemFor(index: index)
        closeScreen()
    }
    
}
