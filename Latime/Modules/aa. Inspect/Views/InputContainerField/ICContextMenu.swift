//
//  imagePickerContextMenu.swift
//  Latime
//
//  Created by Andrei Niunin on 14.07.2021.
//

import UIKit


// MARK: - ImagePicker ContextMenu

protocol ImagePickerContextMenu {
    
    // Adopters of this protocol implement the actual actions.
    func photoPicker()
    func imagePicker()
    func unsplashPicker()
    func removeImage()
}

extension ImagePickerContextMenu {
    
    var performRemoveImage: UIAction {
        UIAction(title: "Delete".localized,
                 image: UIImage(systemName: "trash"),
                 attributes: .destructive) { [self] _ in
            self.removeImage()
        }
    }
    
    func imageAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Image", comment: ""),
                        image: UIImage(systemName: "photo.fill")) { action in
            self.imagePicker()
        }
    }
    
    func photoAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Photo", comment: ""),
                        image: UIImage(systemName: "camera.fill")) { action in
            self.photoPicker()
        }
    }
    
    func unsplashAction() -> UIAction {
        return UIAction(title: NSLocalizedString("Unsplash", comment: ""),
                        image: UIImage(systemName: "camera.aperture")) { action in
            self.unsplashPicker()
        }
    }
}
