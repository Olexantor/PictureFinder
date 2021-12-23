//
//  ManyPicturesViewController.swift
//  PictureFinder
//
//  Created by Александр on 13.12.2021.
//

import Nuke
import SnapKit
import UIKit

class ManyPicturesViewController: UIViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .red
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        let transfrom = CGAffineTransform.init(scaleX: 3, y: 3)
        indicator.transform = transfrom
        return indicator
    }()
    
    private let searchController = UISearchController(
        searchResultsController: nil
    )
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(
        top: 10,
        left: 10,
        bottom: 10,
        right: 10
    )
    private var paddingWidth: CGFloat { sectionInsets.left * (itemsPerRow + 1)
    }
    private var availableWidth: CGFloat { collectionView.frame.width - paddingWidth
    }
    private var widthOfItem: CGFloat { availableWidth / itemsPerRow
    }
    
    private var picturesReferences = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupNavigationBar()
        setupSearchController()
        setupCollectionView()
        nukeLoadingOptions()
    }
    
    private func setupActivityIndicator() {
        collectionView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        title = "Picture finder"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = secondaryColor
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
    
    @objc private func searchButtonTapped(textField: UITextField) {
        searchBarButtonClicked(searchController.searchBar)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = mainColor
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
}

// MARK: - UICollectionViewDataSource Methods

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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ManyPicturesCell.identifier,
            for: indexPath
        ) as? ManyPicturesCell else {
            return UICollectionViewCell()
        }
        let url = picturesReferences[indexPath.item]
        var resizedImageProcessors: [ImageProcessing] {
            let imageSize = CGSize(width: widthOfItem, height: widthOfItem)
            return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFit)]
        }
        let request = ImageRequest(
            url: url,
            processors: resizedImageProcessors
        )
        Nuke.loadImage(with: request, into: cell.imageView)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods

extension ManyPicturesViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthOfItem = availableWidth / itemsPerRow
        return CGSize(width: widthOfItem, height: widthOfItem)
    }
    
   func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
   ) -> UIEdgeInsets {
        return sectionInsets
    }
    
   func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UICollectionViewDelegate Methods

extension ManyPicturesViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let detailedVC = LargePictureViewController(
            urlsOfPictures: picturesReferences,
            currentIndex: indexPath.item
        )
        present(detailedVC, animated: true)
    }
}

// MARK: - SearchBarDelegate

extension ManyPicturesViewController: UISearchBarDelegate {
    private func searchBarButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        guard let textField = searchBar.text, !textField.isEmpty else { return }
        getPicturesWith(request: textField)
    }
}

// MARK: - API Methods

extension ManyPicturesViewController {
    private func getPicturesWith(request: String) {
        NetworkManager.shared.fetchPicturesLinksWith(
            query: request,
            completion: { [weak self] pictures in
                guard let self = self else { return }
                self.picturesReferences = pictures.refsOnPictures
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            },
            failure: { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.errorAlert(with: "\(error)")
                }
            }
        )
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

// MARK: - Nuke presets

extension ManyPicturesViewController {
   
   private func nukeLoadingOptions() {
       let contentModes = ImageLoadingOptions.ContentModes(
           success: .scaleAspectFit,
           failure: .scaleAspectFit,
           placeholder: .scaleAspectFit
       )
       
       ImageLoadingOptions.shared.contentModes = contentModes
       ImageLoadingOptions.shared.placeholder = UIImage(
           systemName: "timer",
           withConfiguration: colorOfSystemPics
       )
       ImageLoadingOptions.shared.failureImage = UIImage(
           systemName: "clear",
           withConfiguration: colorOfSystemPics
       )
       ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.5)
   }
}
