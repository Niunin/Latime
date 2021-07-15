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

protocol InspectorRouterProtocol: AnyObject {
    
    var entry: inspectorEntryPoint! { get set }
    
    static func build(context: NSManagedObjectContext,model: TimePoint) -> inspectorEntryPoint
    
    func showImagePicker()
    func showCamera()
    func showUnsplash()
    
}

// MARK: - View

protocol InspectorViewProtocol: AnyObject {
    
    var presenter: InspectorPresenterProtocol! { get set }
    
    func configureView(withModel: InspectorModel)
    func configureView(withImage: UIImage?)
}

// MARK: - Presenter

protocol InspectorPresenterProtocol: AnyObject {
    
    var view: InspectorViewProtocol! { get set }
    var router: InspectorRouterProtocol! { get set }
    var interactor: InspectorInteractorProtocol! { get set }
    
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

protocol InspectorInteractorProtocol: AnyObject {
    
    var model: TimePoint { get }
    
    func update(title: String?)
    func update(date: Date)
    func update(image: UIImage?)
    func delete()
    func prepareForClosing()
    
}

// MARK: DataManager

protocol InspectorDataManagerProtocol: AnyObject {
    
    var model: TimePoint { get }
    func update(title: String)
    func update(date: Date)
    func update(image: UIImage?)
    func delete()
    func saveContext()
    
}

// MARK: DatePicker Delegate

protocol InspectorDatePickerDelegate: AnyObject {
    
    func dateChanged(_ date : Date)
    
}

// MARK: - DatePicker Protocol

protocol InspectorDatePickerProtocol: AnyObject {
    
//    var reuseIdentifier: String { get }
    var delegate: InspectorDatePickerDelegate! { get set }
    func setDate(_ date : Date)
    
}
