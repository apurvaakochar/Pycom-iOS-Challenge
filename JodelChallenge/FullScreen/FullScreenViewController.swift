//
//  FullScreenCollectionView.swift
//  JodelChallenge
//
//  Created by Apurva Kochar on 4/29/18.
//  Copyright © 2018 Jodel. All rights reserved.
//

import UIKit

class FullScreenViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

   
    /*
     CellIdentifier
     */
    let reusableIdentifier = "ImageCell"
    /*
     ViewModel
     */
    var viewModel: FullScreenViewModel?
    /*
     Router taking care of navigation and data transfer
     */
    var router: FullScreenDataPassing?
    
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
        viewModel = FullScreenViewModel()
        initViewModel()
        let router = FullScreenRouter()
        viewController.router = router
        router.dataStore = viewModel
    }
    
    //MARK: View Lifecycle
    
    override func viewDidLoad(){
       
        super.viewDidLoad()
        self.title = "Photos"
        viewModel?.processFetchedPhotos()
    }
    
    private func initViewModel(){
        viewModel?.reloadViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
                let indexPath = IndexPath(item: (self?.viewModel?.selectedIndex)!, section: 0)
                self?.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
    
    //MARK: CollectionView
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! ImageCell
        let cellVM = viewModel?.getCellViewModel( at: indexPath )
        cell.fullImageView.sd_setImage(with: cellVM?.imageUrl) {
            (image, error, cacheType, url) in
        }
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
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
