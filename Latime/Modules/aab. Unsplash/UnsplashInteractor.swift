//
//  GlanceInteractor.swift
//  Timeboy
//
//  Created by Andrei Niunin on 02.05.2021.
//

import Foundation
import UIKit.UIImage

// MARK: - Protocol

protocol UnsplashInteractorProtocol {
    
    var presenter: UnsplashPresenterProtocol! { get set }
    var networkManager: UnsplashNetworkInterface! { get set }
    
    func orderImagesDataPackage(with query: String?)
    func getItemFor(index: Int, completion: @escaping (_ image: UIImage?,_ imageSource: ImageSource ) -> Void)
    func getFullSizeItemFor(index: Int)

}

// MARK: - Object

class UnsplashInteractor  {
    
    // MARK: properties
    
    weak var presenter: UnsplashPresenterProtocol!
    var networkManager: UnsplashNetworkInterface!
    
    // TODO: rename it
    var choiceOptionsCatalog: [ImageSource] = [] {
        didSet {
            presenter.imagesCatalogUpdated(with: choiceOptionsCatalog.count)
        }
    }

}

// MARK: - UnsplashInteractorProtocol

extension UnsplashInteractor: UnsplashInteractorProtocol {
    
    // MARK: functionality
    
    // TODO: rafactor these fethces
    func getItemFor(index: Int,  completion: @escaping (_ image: UIImage?,_ imageSource: ImageSource ) -> Void) {
        let choice = choiceOptionsCatalog[index]
        let url = choice.thumbUrl
        
        networkManager.fetchImage(url: url) {[weak self] data, error  in
            if let error = error {
                print(" \(String(describing: error))")
            } else {
                let image = self?.getImage(from: data)
                DispatchQueue.main.async {
                    completion(image, choice)
                }
            }
        }
    }
    
    func getFullSizeItemFor(index: Int) {
        let chosen = choiceOptionsCatalog[index]
        let url = chosen.regularUrl
        
        networkManager.fetchImage(url: url) {[weak self] data, error  in
            if let error = error {
                print(" \(String(describing: error))")
            } else {
                let image = self?.getImage(from: data)
                DispatchQueue.main.async {
                    let imageInfo = ["image": image as Any]
                    NotificationCenter.default.post(name: .pickerImageReady, object: nil, userInfo: imageInfo)
                }
            }
        }
    }
    
    func orderImagesDataPackage(with query: String? = nil) {
        networkManager.fetchImagesDataPackage(searchQuery: query) { [weak self] jsonData, error in
            guard let self = self else {return}
            if let error = error {
                self.handleCompletionError(error: error)
            } else {
                let choice = self.getChoiceOption(from: jsonData)
                DispatchQueue.main.async {
                    self.choiceOptionsCatalog = choice
                }
            }
        }
    }
    
    private func getChoiceOption(from json: Data?) -> [ImageSource] {
        let unsplashPhotosPackage = unpackJson(json)
        let choiceOption = translateToChoiceOption(from: unsplashPhotosPackage)
        return choiceOption
    }
    
    private func unpackJson(_ data: Data?) -> [UnsplashPhoto] {
        do {
            return try [UnsplashPhoto].init(data: data!)
        } catch let error {
            handleCompletionError(error: error)
            return []
        }
    }
    
    private func translateToChoiceOption(from unsplash: [UnsplashPhoto]) -> [ImageSource] {
        unsplash.map { ImageSource(from: $0) }
    }
    
    private func getImage(from data: Data?) -> UIImage? {
        data == nil ? UIImage(systemName: "picture") : UIImage(data: data!)
    }
    
    private func handleCompletionError(error: Error) {
        Swift.debugPrint(" " + String(describing: error))
        DispatchQueue.main.async {
            self.presenter.closeScreen()
        }
    }
    
}
