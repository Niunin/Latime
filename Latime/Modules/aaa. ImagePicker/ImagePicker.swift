//
//  ImagePicker.swift
//  Latime
//
//  Created by Andrei Niunin on 10.07.2021.
//

import UIKit

class ImagePicker: UIImagePickerController {

    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sourceType = .photoLibrary
        delegate = self
        // Do any additional setup after loading the view.
    }
    
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            return
        }
        
        dismiss(animated: true) {
            let imageInfo = ["image": image as Any]
            NotificationCenter.default.post(name: .pickerImageReady, object: nil, userInfo: imageInfo)
        }
    }

}


// MARK: - Utilities
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
