//
//  FeedTest.swift
//  JodelChallengeTests
//
//  Created by Apurva Kochar on 4/30/18.
//  Copyright © 2018 Jodel. All rights reserved.
//

import XCTest
@testable import JodelChallenge

class FeedTest: XCTestCase {
    
    var feedViewModel: FeedViewModel!
    var feedViewController: FeedViewController!
    var fullScreenViewController: FullScreenViewController!
    
    override func setUp() {
        super.setUp()
        feedViewModel = FeedViewModel()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        feedViewController = storyboard.instantiateViewController(withIdentifier: "Feed") as! FeedViewController
        fullScreenViewController = storyboard.instantiateViewController(withIdentifier: "FullScreen") as! FullScreenViewController
    }
    
    override func tearDown() {
        super.tearDown()
        feedViewModel = nil
        feedViewController = nil
        fullScreenViewController = nil
    }
    
    /*
    If internet is unavailable, urls should be loaded from the database
     */
    
    func testInternetUnavailable() {
       feedViewModel.errorOccured = "Internet not available"
        XCTAssertEqual(feedViewModel.numberOfCells , 10)
    }
    /*
     The number of photo Urls fetched by Flickr API
     */
    
    func testFlickrAPI() {
        let exp = expectation(description: "FlickrAPI fetches Urls and runs the callback closure")
        FlickrApi.fetchPhotos {
            (photos, error) in
            XCTAssertEqual(photos?.count, 10)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) {
            error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    /*
     Test if the urls are transferred to the FullScreen View
     */
    func testDataTransfer() {
        let array = ["https://farm1.static.flickr.com/871/41741981292_cb09e4bc40_m.jpg", "https://farm1.static.flickr.com/958/26899493407_99b8711b3d_m.jpg"]
        feedViewController.viewModel?.processFetchedPhoto(photoUrls : array )
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = feedViewController.collectionView?.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        let segue = UIStoryboardSegue.init(identifier: "FullScreen", source: feedViewController, destination: fullScreenViewController)
        feedViewController.performSegue(withIdentifier: "FullScreen", sender: cell)
        feedViewController.prepare(for: segue, sender: cell)
        let desinationVC = segue.destination as! FullScreenViewController
        let dataStore = desinationVC.router?.dataStore
        let photoUrls = dataStore?.photoUrls
        XCTAssertEqual(photoUrls?.count, array.count)
    }
    
}
