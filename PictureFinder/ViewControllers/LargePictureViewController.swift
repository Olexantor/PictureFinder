//
//  LargePictureViewController.swift
//  PictureFinder
//
//  Created by Александр on 22.12.2021.
//

import Nuke
import SnapKit
import UIKit

class LargePictureViewController: UIViewController {
   
    private let urlsOfPictures: [URL]
    
    private var currentIndex: Int
    
//    private var availableIndex {
//    }
    
    private var largePictureImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() {
        didSet {}
    }
    
    private var resizedImageProcessors: [ImageProcessing] {
        let imageSize = CGSize(width: view.frame.width, height: view.frame.width)
        return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFit)]
    }
    
    private let sourceButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = secondaryColor
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("Open source file", for: .normal)
        button.addTarget(self, action: #selector(sourceButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = secondaryColor
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("Next ->", for: .normal)
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = secondaryColor
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("<- Previous", for: .normal)
        button.addTarget(self, action: #selector(previousButtonAction), for: .touchUpInside)
        return button
    }()
    
    init(urlsOfPictures: [URL], currentIndex: Int) {
        self.urlsOfPictures = urlsOfPictures
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainColor
        setupSubviews()
        setConstraints()
        nukeLoadingOptions()
        getPicture()
    }
    
    @objc func sourceButtonAction(sender: UIButton!) {
        let webVC = WebViewController(pictureUrl: urlsOfPictures[currentIndex])
        present(webVC, animated: true)
    }
    
    @objc func nextButtonAction(sender: UIButton!) {
        if (currentIndex + 1) < urlsOfPictures.count {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        getPicture()
    }
    
    @objc func previousButtonAction(sender: UIButton!) {
        if (currentIndex - 1) >= 0 {
            currentIndex -= 1
        } else {
            currentIndex = urlsOfPictures.count - 1
        }
        getPicture()
    }
    
    private func setupSubviews() {
        view.addSubview(largePictureImageView)
        view.addSubview(sourceButton)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
    }
    
    private func setConstraints() {
        largePictureImageView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.right.equalToSuperview()
        }
        sourceButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
        }
        nextButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview().inset(20)
        }
        previousButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func nukeLoadingOptions() {
        let contentModes = ImageLoadingOptions.ContentModes(
            success: .scaleAspectFit,
            failure: .scaleAspectFill,
            placeholder: .scaleAspectFill
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
    
    private func getPicture() {
        let url = urlsOfPictures[currentIndex]
        let request = ImageRequest(
            url: url,
            processors: resizedImageProcessors
        )
        Nuke.loadImage(with: request, into: largePictureImageView)
    }
}
