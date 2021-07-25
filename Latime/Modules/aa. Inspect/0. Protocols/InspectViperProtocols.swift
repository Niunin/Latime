//
//  InspectorProtocols.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import CoreData.NSManagedObjectContext
import UIKit.UIImage

// MARK: - Router Protocol

protocol InspectRouterProtocol: AnyObject {
    
    var entry: InspectEntryPoint! { get set }
    
    static func build(context: NSManagedObjectContext,model: TimePoint) -> InspectEntryPoint
    
    func showImagePicker()
    func showCamera()
    func showUnsplash()
    
}

// MARK: - View Protocol

protocol InspectViewProtocol: AnyObject {
    
    var presenter: InspectPresenterProtocol! { get set }
    
    func configure(model: InspectModel)
    func configure(image: UIImage?)
    func configure(date: Date)
    func configure(interval: TimeInterval)
}

// MARK: - Presenter Protocol

protocol InspectPresenterProtocol: AnyObject {
    
    var view: InspectViewProtocol! { get set }
    var router: InspectRouterProtocol! { get set }
    var interactor: InspectInteractorProtocol! { get set }
    
    func buttonPressedRemove()
    func buttonPressedImagePicker()
    func buttonPressedCamera()
    func buttonPressedUnsplash()
    func buttonPressedImageRemove()
    func viewUpdated(title: String?)
    func viewUpdated(date : Date)
    func viewUpdated(timeInterval: TimeInterval)
    func screenWillClose()

    func interactorUpdated(date: Date)
    func interactorUpdated(interval: Int64)
    func interactorUpdated(image: UIImage?)
}

// MARK: - Interactor Protocol

protocol InspectInteractorProtocol: AnyObject {
    
    var model: TimePoint { get }
    
    func update(title: String?)
    func update(date: Date)
    func update(interval: Int64)
    func update(image: UIImage?)
    func delete()
    func prepareForClosing()
    
}

// MARK: - DataManager Protocol

protocol InspectDataManagerProtocol: AnyObject {
    
    var model: TimePoint { get }
    func update(title: String)
    func update(date: Date)
    func update(interval: Int64)
    func update(image: UIImage?)
    func delete()
    func saveContext()
    
}
