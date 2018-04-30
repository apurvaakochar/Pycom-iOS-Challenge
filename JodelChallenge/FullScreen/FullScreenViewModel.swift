//
//  FullScreenViewModel.swift
//  JodelChallenge
//
//  Created by Apurva Kochar on 4/30/18.
//  Copyright © 2018 Jodel. All rights reserved.
//

import UIKit

protocol FullScreenBusinessLogic {
    func processFetchedPhotos()
}

protocol FullScreenPresentationLogic {
    var numberOfCells: Int {get}
}

protocol FullScreenDataStore {
    var photoUrls: NSArray? {get set}
    var selectedIndex: Int? {get set}
}

class FullScreenViewModel: FullScreenDataStore, FullScreenPresentationLogic{
    var selectedIndex: Int?
    
    var photoUrls: NSArray?
    
    
    private var cellViewModels: [ImageCellViewModel] = [ImageCellViewModel]() {
        didSet {
            self.reloadViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    
    var reloadViewClosure: (()->())?
    
    
    func getCellViewModel( at indexPath: IndexPath ) -> ImageCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func getSelectedIndex() -> Int {
        return selectedIndex!
    }
    
}

extension FullScreenViewModel: FullScreenBusinessLogic{
    
    func processFetchedPhotos() {
        var fcvm = [ImageCellViewModel]()
        for photoUrl in photoUrls! {
            fcvm.append( createCellViewModel(url: photoUrl as! URL ))
        }
        self.cellViewModels = fcvm
    }
    
    private func createCellViewModel(url : URL ) -> ImageCellViewModel {
        return ImageCellViewModel(imageUrl: url)
    }
}



