//
//  UnsplashPreview.swift
//  iX-33
//
//  Created by Andrea Nunti on 09.04.2021.
//

import UIKit

class PreviewViewController: UIViewController {
    
    let imageView = UIImageView()
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 250)
        view.addSubview(imageView)
    }
    
}
