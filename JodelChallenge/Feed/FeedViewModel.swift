//
//  FeedInteractor.swift
//  JodelChallenge
//
//  Created by Apurva Kochar on 4/28/18.
//  Copyright (c) 2018 Jodel. All rights reserved.
//
import UIKit

protocol FeedBusinessLogic {
    func fetchPhotos()
}

protocol FeedPresentationLogic {
    var isLoading: Bool {get set}
    var alertMessage: String? {get set}
    var numberOfCells: Int {get}
}
protocol FeedDataStore {
    var photoUrls: NSArray {get set}
    var selectedIndex: Int? {get set}
}

class FeedViewModel: FeedPresentationLogic, FeedDataStore{

    var selectedIndex: Int?
    var coreDataHelper: CoreDataHelper?
    
    init() {
        coreDataHelper  = CoreDataHelper()
    }
    
    var photoUrls: NSArray = NSArray()
    
    private var cellViewModels: [ImageCellViewModel] = [ImageCellViewModel]() {
        didSet {
            self.reloadViewClosure?()
            coreDataHelper?.saveImageUrls(photoUrls: photoUrls)
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var errorOccured: String? {
        didSet {
            self.loadFromCache(errorMessage: errorOccured!)
        }
    }
    
    var reloadViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    

    func getCellViewModel( at indexPath: IndexPath ) -> ImageCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
}

extension FeedViewModel: FeedBusinessLogic{
    
    func fetchPhotos() {
        self.isLoading = true
        FlickrApi.fetchPhotos{ [weak self]
            (photos, error) in
            self?.isLoading = false
            if let error = error {
                self?.errorOccured = error.localizedDescription
            } else {
                self?.processFetchedPhoto(photoUrls: photos! as NSArray)
            }
        }
    }
    
    private func processFetchedPhoto(photoUrls : NSArray) {
        self.photoUrls = photoUrls
        var icvm = [ImageCellViewModel]()
        for photoUrl in photoUrls {
            icvm.append( createCellViewModel(url: photoUrl as! URL ))
        }
        self.cellViewModels = icvm
    }
    
    func processFetchedPhoto(photoUrls : [String] ) {
        var fcvm = [ImageCellViewModel]()
        var urls = [URL]()
        for photoUrl in photoUrls {
            let url = URL(string: photoUrl)!
            fcvm.append( createCellViewModel(url: url) )
            urls.append(url)
        }
        self.cellViewModels = fcvm
        self.photoUrls = urls as NSArray
    }
    
    private func createCellViewModel(url : URL ) -> ImageCellViewModel {
        return ImageCellViewModel(imageUrl: url)
    }
    
    private func separateUrls(urlString: String) {
        let urls = urlString.components(separatedBy: ",")
        processFetchedPhoto(photoUrls: urls)
    }
    
    private func loadFromCache(errorMessage: String) {
        coreDataHelper?.loadFromCache(errorMessage: errorMessage){
            (urlString, errorMessage) in
            if(urlString == "") {
                self.alertMessage = errorMessage
            }
            else {
                self.separateUrls(urlString: urlString)
            }
        }
    }
}


