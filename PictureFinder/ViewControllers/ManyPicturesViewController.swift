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
    
    private var picturesReferences = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        searchController.searchBar.searchTextField.addTarget(
            self,
            action: #selector(searchButtonTapped),
            for: UIControl.Event.primaryActionTriggered
        )
    }
    
    @objc private func searchButtonTapped(textField:UITextField) {
        searchBarButtonClicked(searchController.searchBar)
    }
}

// MARK: UICollectionViewDataSource

extension ManyPicturesViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        picturesReferences.count
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

extension ManyPicturesViewController: UISearchBarDelegate {
    func searchBarButtonClicked(_ searchBar: UISearchBar) {
        guard let textField = searchBar.text, !textField.isEmpty else { return }
        getPicturesWith(request: textField)
    }
}

// MARK: - API Methods

extension ManyPicturesViewController {
    
    func getPicturesWith(request: String) {
        NetworkManager.shared.fetchPicturesLinksWith(
            query: request,
            completion: { [weak self] pictures in
                guard let self = self else { return }
                self.picturesReferences = pictures.refsOnPictures
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            },
            failure: { [weak self] error in
                guard let self = self else {return}
                self.errorAlert(with: "\(error)")
            })
    }
}

 // MARK: - Alerts

extension ManyPicturesViewController {
    
    private func errorAlert(with message: String) {
        let alert = UIAlertController(
            title: "Error!",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
