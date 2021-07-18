//
//  Inspect_ViewDelegates.swift
//  Latime
//
//  Created by Andrei Niunin on 18.07.2021.
//

import UIKit

// MARK: - InputContainer Delegate

protocol InputContainerDelegate: AnyObject {
    
    func titleUpdated(_ : String)
    func callImagePicker()
    func callCamera()
    func callUnsplash()
    func removeImage()
    
}

// MARK: - Scrollable Delegate

protocol Scrollable: AnyObject {
    
    func scrollRectToVisible(_ rect: CGRect)
    
}

