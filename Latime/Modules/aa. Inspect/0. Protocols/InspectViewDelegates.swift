//
//  Inspect_ViewDelegates.swift
//  Latime
//
//  Created by Andrei Niunin on 18.07.2021.
//

import UIKit

// MARK: - DatePicker Delegate

protocol InspectDateInputDelegate: AnyObject {
    
    func dateChanged(_ date : Date)
    func rectToVisible(_ rect: CGRect)
    
}

// MARK: - InputContainer Delegate

protocol InputContainerDelegate: AnyObject {
    
    func titleUpdated(_ : String)
    func callImagePicker()
    func callCamera()
    func callUnsplash()
    func removeImage()
    
}
