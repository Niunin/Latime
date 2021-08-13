//
//  InspectorInterfaces.swift
//  Latime
//
//  Created by Andrei Niunin on 24.05.2021.
//

import Foundation
import CoreData.NSManagedObjectContext
import UIKit.UIImage

// MARK: - Router Interface

protocol InspectRouterInterface: AnyObject {
    
    var entry: InspectEntryPoint! { get set }
    
    static func build(context: NSManagedObjectContext,model: TimePoint) -> InspectEntryPoint
    
    func showImagePicker()
    func showCamera()
    func showUnsplash()
    
}

// MARK: - View Interface

protocol InspectViewInterface: AnyObject {
    
    var presenter: InspectPresenterInterface! { get set }
    
    func configure(model: InspectEntity)
    func configure(image: UIImage?)
    
}

// MARK: - Presenter Interface

protocol InspectPresenterInterface: AnyObject {
    
    var view: InspectViewInterface! { get set }
    var router: InspectRouterInterface! { get set }
    var interactor: InspectInteractorInterface! { get set }
    
    func screenWillClose()
    
    func buttonPressedRemove()
    func buttonPressedImagePicker()
    func buttonPressedCamera()
    func buttonPressedUnsplash()
    func buttonPressedImageRemove()
    func switchToggledIsDependent(_:Bool)
    
    func viewUpdated(title: String?)
    func viewUpdated(date : Date)
    func viewUpdated(timeInterval: TimeInterval)
    
}

// MARK: - Interactor Interface

protocol InspectInteractorInterface: AnyObject {
    
    var data: InspectEntity? { get }
//    var model: TimePoint { get }
//    var dateHandler: DateHandler? { get set }
    
    func updateData()
    func update(title: String?)
    func update(date: Date)
    func update(interval: Int64)
    func update(isDependent: Bool)
    func update(image: UIImage?)
    
    func delete()
    func prepareForClosing()
    
}

// MARK: - Interactor Interface

protocol InspectInteractorOutputInterface: AnyObject {
    
    func interactorUpdatedData(data: InspectEntity) 
    func interactorUpdated(image: UIImage?)
    
}


// MARK: - DataManager Interface

protocol InspectDataManagerInterface: AnyObject {
    
    var model: TimePoint { get }
    func update(title: String)
    func update(date: Date)
    func update(image: UIImage?)
    func delete()
    func saveContext()
    
}
