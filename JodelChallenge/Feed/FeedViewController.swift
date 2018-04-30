//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Apurva Kochar on 4/28/18.
//  Copyright (c) 2018 Jodel. All rights reserved.
//

import UIKit
import SDWebImage

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    /*
        ViewModel
     */
    var viewModel: FeedViewModel?
    /*
        Router taking care of navigation and data transfer
     */
    var router: (NSObjectProtocol & FeedRoutingLogic & FeedDataPassing)?
    /*
        CellIdentifier
     */
    let reusableIdentifier = "ImageCell"
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let router = FeedRouter()
        viewController.router = router
        router.viewController = viewController
        viewModel = FeedViewModel()
        initViewModel()
        router.dataStore = viewModel
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let cell = sender as! UICollectionViewCell
        let selectedIndex = collectionView?.indexPath(for: cell)?.row
        viewModel?.selectedIndex = selectedIndex
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Flickr Images"
        
      }
    
    func initViewModel() {
        viewModel?.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel?.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        viewModel?.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel?.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                }else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            
        }
        
        viewModel?.reloadViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        
        viewModel?.fetchPhotos()
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
     @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
    //MARK: CollectionView
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! ImageCell
        let cellVM = viewModel?.getCellViewModel( at: indexPath )
        cell.imageView.sd_setImage(with: cellVM?.imageUrl, completed: nil)
        cell.imageView.layer.cornerRadius = 6.0
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width, height: view.frame.width - 20)
    }
}
