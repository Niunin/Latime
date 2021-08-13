//
//  UnsplashCollectionViewCollectionViewController.swift
//  Timeboy
//
//  Created by Andrei Niunin on 02.05.2021.
//

import UIKit

// MARK: - Object

class UnsplashCollectionView: UICollectionView {
    
    private let layout = UICollectionViewFlowLayout()
    
    // MARK: init
    
    init () {
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = UIColor.myViewBackground
        register(UnsplashCell.self, forCellWithReuseIdentifier: UnsplashCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: configure view
    
    func configureLayout(size: CGSize) {
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        layout.itemSize = CGSize(width: size.width/2-6, height: size.width/2-6)
    }
    
}
