//
//  UICollectionView + Extensions.swift
//  Latime
//
//  Created by Andrei Niunin on 19.07.2021.
//

import UIKit

extension UICollectionView {
    
    func addKeyboardNotificationsObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(unscrollWhenKeyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(scrollWhenKeyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.removeObserver(
            self, name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    @IBAction func unscrollWhenKeyboardWillHide(_ notification: NSNotification) {
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        self.contentInset = insets
        self.scrollIndicatorInsets = insets
    }
    
    @IBAction func scrollWhenKeyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardHeight = keyboardFrame?.height ?? 0

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)

        self.contentInset = insets
        self.scrollIndicatorInsets = insets
    }
    
}
