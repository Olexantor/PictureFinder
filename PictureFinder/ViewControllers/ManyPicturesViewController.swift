//
//  ManyPicturesViewController.swift
//  PictureFinder
//
//  Created by Александр on 13.12.2021.
//

import SnapKit
import UIKit

class ManyPicturesViewController: UIViewController {
    private let searchController = UISearchController(
        searchResultsController: nil
    )

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var arrayOfPics = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        setupSearchController()
        testMethod()
    }

    func testMethod() {
        NetworkManager.shared.fetchPicturesLinksWith(
            query: "рота американских солдат",
            completion: { [self] pictures in
                self.arrayOfPics = pictures.refsOnPictures
                print(arrayOfPics)
            },
            failure: { error in
            print(error.localizedDescription)
            })
    }

    func setupCollectionView() {
        collectionView.backgroundColor = UIColor(
            red: 102/255,
            green: 102/255,
            blue: 102/255,
            alpha: 1
        )
        collectionView.register(
            ManyPicturesCell.self,
            forCellWithReuseIdentifier: ManyPicturesCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
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

// MARK: UICollectionViewDataSource

extension ManyPicturesViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        9
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ManyPicturesCell.identifier,
            for: indexPath
        ) as! ManyPicturesCell
        cell.backgroundColor = .red
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ManyPicturesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout: UICollectionViewLayout,
        sizeForItemAt: IndexPath
    ) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
}

// MARK: - SearchBarDelegate

extension ManyPicturesViewController: UISearchBarDelegate {}

// MARK: - API Methods

extension ManyPicturesViewController {
    
    func getPicturesWith(request: String) {
        NetworkManager.shared.fetchPicturesLinksWith(
            query: request,
            completion: { [self] pictures in
                self.arrayOfPics = pictures.refsOnPictures
                print(arrayOfPics)
            },
            failure: { error in
            print(error.localizedDescription)
            })
    }
}
