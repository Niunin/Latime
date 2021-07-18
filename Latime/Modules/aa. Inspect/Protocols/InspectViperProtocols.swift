//
//  InspectorProtocols.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import CoreData.NSManagedObjectContext
import UIKit.UIImage

// MARK: - Router

protocol InspectRouterProtocol: AnyObject {
    
    var entry: InspectEntryPoint! { get set }
    
    static func build(context: NSManagedObjectContext,model: TimePoint) -> InspectEntryPoint
    
    func showImagePicker()
    func showCamera()
    func showUnsplash()
    
}

// MARK: - View

protocol InspectViewProtocol: AnyObject {
    
    var presenter: InspectPresenterProtocol! { get set }
    
    func configureView(withModel: InspectorModel)
    func configureView(withImage: UIImage?)
}

// MARK: - Presenter

protocol InspectPresenterProtocol: AnyObject {
    
    var view: InspectViewProtocol! { get set }
    var router: InspectRouterProtocol! { get set }
    var interactor: InspectInteractorProtocol! { get set }
    
    func update(title: String?)
    func update(date : Date)
    func configureView(withImage: UIImage?)
    
    func buttonPressedRemove()
    func buttonPressedImagePicker()
    func buttonPressedCamera()
    func buttonPressedUnsplash()
    func buttonPressedImageRemove()
    func screenWillClose()
    
}

// MARK: - Interactor

protocol InspectInteractorProtocol: AnyObject {
    
    var model: TimePoint { get }
    
    func update(title: String?)
    func update(date: Date)
    func update(image: UIImage?)
    func delete()
    func prepareForClosing()
    
}

// MARK: DataManager

protocol InspectDataManagerProtocol: AnyObject {
    
    var model: TimePoint { get }
    func update(title: String)
    func update(date: Date)
    func update(image: UIImage?)
    func delete()
    func saveContext()
    
}

// MARK: DatePicker Delegate

protocol InspectDatePickerDelegate: AnyObject {
    
    func dateChanged(_ date : Date)
    
}

// MARK: - DatePicker Protocol

protocol InspectorDatePickerProtocol: AnyObject {
    
//    var reuseIdentifier: String { get }
    var delegate: InspectDatePickerDelegate! { get set }
    func setDate(_ date : Date)
    
}
