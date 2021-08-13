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

//// MARK: - DatePicker Delegate
//
//protocol InspectDateInputDelegate: AnyObject {
//    
//    func dateChanged(_ date : Date)
//    func intervalChanged(_ interval: TimeInterval)
//    
//}


// MARK: - TitleSegmentedControl Delegate

protocol TitleSegmentedDelegate: AnyObject {

    //var currentSegment: Int? { get set }
    func setCurrentSegment(_:Int)
    
}
