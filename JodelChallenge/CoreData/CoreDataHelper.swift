//
//  CoreDataHelper.swift
//  JodelChallenge
//
//  Created by Apurva Kochar on 4/30/18.
//  Copyright © 2018 Jodel. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    fileprivate var managedContext: NSManagedObjectContext?
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func saveImageUrls(photoUrls: NSArray) {
        let flickrUrls = photoUrls.componentsJoined(by: ",")
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrImages")
        do {
            let result = try self.managedContext!.fetch(userFetch) as! [FlickrImagesMO]
            if (result.count > 0) {
                result.first?.url = flickrUrls
            }
            else {
                insertNewValue(flickrUrls: flickrUrls)
            }
             saveContext()
        } catch {
            print("Failed")
        }
    }
    
    func loadFromCache(errorMessage: String, completionHandler: @escaping (_ urlString: String, _ errorMessage: String) -> Void) {
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FlickrImages")
        do {
            let result = try self.managedContext!.fetch(userFetch) as! [FlickrImagesMO]
            if(result.count > 0){
                let urlString = result.first?.url
                completionHandler(urlString!, "")
            }
            else {
                completionHandler("", errorMessage)
            }
        } catch {
            completionHandler("", errorMessage)
            print("Failed")
        }
    }
    
    private func insertNewValue(flickrUrls: String) {
        let userEntity = NSEntityDescription.entity(forEntityName: "FlickrImages", in: managedContext!)!
        let flickrImages = NSManagedObject(entity: userEntity, insertInto: managedContext)
        flickrImages.setValue(flickrUrls, forKey: "url")
    }
    
    private func saveContext() {
        do {
            try self.managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }
}
