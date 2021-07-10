//
//  TimelinePresenter.swift
//  Latime
//
//  Created by Andrei Niunin on 08.07.2021.
//

import Foundation

class TimelinePresenter{
    
    var view: TimelineViewProtocol!
    var router: TimelineRouterProtocol!
    var interactor: TimelineInteractorProtocol!

}

extension TimelinePresenter: TimelinePresenterProtocol {
    
}
