//
//  InspectorViewController+InputContainer.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import UIKit

// MARK: - InputContainer Delegate

extension InspectorViewController: InputContainerDelegate {
    
    @IBAction func callImagePicker() {
        presenter.buttonPressedImagePicker()
    }
    
    func callCamera() {
        presenter.buttonPressedCamera()
    }
    
    func callUnsplash() {
        presenter.buttonPressedUnsplash()
    }
    
    func removeImage() {
        presenter.buttonPressedImageRemove()
    }
    
}

// MARK: - UITextField Delegate

extension InspectorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        presenter.update(title: textField.text ?? "")
    }
    
}

// MARK: Keyboard and InputContainer handler

internal extension InspectorViewController {
    
    func setupObservers() {
        addKeybordHideTapRecognizer()
        addKeyboardNotificationsObservers()
    }
    
    func addKeybordHideTapRecognizer() {
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardNotificationsObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(lowerInputContainer(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(raiseInputContaier(notification:)),
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
    
    func removeGestureRecognizers() {
        view.removeGestureRecognizer(tap)
    }
    
    @IBAction func lowerInputContainer(notification: NSNotification) {
        changeInputContainerHeight(notification, to: 0)
    }
    
    @IBAction func raiseInputContaier(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardHeight = keyboardFrame?.height ?? 0
        changeInputContainerHeight(notification, to: keyboardHeight)
    }
    
    func changeInputContainerHeight(_ notification: NSNotification, to height: CGFloat) {
        let keyboardAnimationDuration = getKeyboardAnimationDuration(notification)
        inputContainer.setHeight(to: height, with: keyboardAnimationDuration)
    }
    
    func getKeyboardAnimationDuration(_ notification: NSNotification) -> Double? {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        return duration
    }
    
}
