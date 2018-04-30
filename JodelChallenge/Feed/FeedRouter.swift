//
//  FeedRouter.swift
//  JodelChallenge
//
//  Created by Apurva Kochar on 4/30/18.
//  Copyright (c) 2018 Jodel. All rights reserved.
//

import UIKit

@objc protocol FeedRoutingLogic
{
  func routeToFullScreen(segue: UIStoryboardSegue?)
}

protocol FeedDataPassing
{
  var dataStore: FeedDataStore? { get }
}

class FeedRouter: NSObject, FeedRoutingLogic, FeedDataPassing
{
  weak var viewController: FeedViewController?
  var dataStore: FeedDataStore?
  
  // MARK: Routing
  
  func routeToFullScreen(segue: UIStoryboardSegue?) {
    if let segue = segue {
         let destinationVC = segue.destination as! FullScreenViewController
         var destinationDS = destinationVC.router!.dataStore!
         passDataToFullScreen(source: dataStore!, destination: &destinationDS)
    }
}
  // MARK: Passing data
  
  func passDataToFullScreen(source: FeedDataStore, destination: inout FullScreenDataStore) {
        destination.selectedIndex = source.selectedIndex
        destination.photoUrls = source.photoUrls
    }
}
