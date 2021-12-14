//
//  ManyPicturesViewController.swift
//  PictureFinder
//
//  Created by Александр on 13.12.2021.
//

import UIKit

class ManyPicturesViewController: UICollectionViewController {
    
    private let searchController = UISearchController(
        searchResultsController: nil
    )
    
    let cellIdentifier = "Pictures cell"

    override func viewDidLoad() {
        
        super.viewDidLoad()
//        collectionView.backgroundColor = UIColor(
//            red: 102/255,
//            green: 102/255,
//            blue: 102/255,
//            alpha: 1
//        )
        setupCollectionView()
        setupNavigationBar()
        setupSearchController()
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = UIColor(
            red: 102/255,
            green: 102/255,
            blue: 102/255,
            alpha: 1
        )
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupNavigationBar() {
        
        title = "Picture finder"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            red: 255/255,
            green: 153/255,
            blue: 0/255,
            alpha: 1
        )
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func setupSearchController() {
        
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.barTintColor = .white
    }
    

}

//MARK: UICollectionViewDataSource
extension ManyPicturesViewController {
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        10
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        )
        return cell
    }
    
    
}

//MARK: UICollectionViewDelegate
extension ManyPicturesViewController {
    
    func collectionView(
        _: UICollectionView,
        layout: UICollectionViewLayout,
        sizeForItemAt: IndexPath
    ) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 250)
    }
    
}

//MARK: - SearchBarDelegate
extension ManyPicturesViewController: UISearchBarDelegate {

}
