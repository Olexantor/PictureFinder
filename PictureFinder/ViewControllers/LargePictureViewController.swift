//
//  LargePictureViewController.swift
//  PictureFinder
//
//  Created by Александр on 22.12.2021.
//

import SnapKit
import UIKit

class LargePictureViewController: UIViewController {
   
    private let urlsOfPictures: [URL]
    
    private let currentIndex: Int
    
//    private var availableIndex {
//    }
    
    private var largePictureImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() {
        didSet {}
    }
    
    private let sourceButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = secondaryColor
        button.setTitle("Open source file", for: .normal)
        button.addTarget(self, action: #selector(sourceButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = secondaryColor
        button.setTitle("Next ->", for: .normal)
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = secondaryColor
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
    }
    
    @objc func sourceButtonAction(sender: UIButton!) {
        print("Source button tapped")
    }
    
    @objc func nextButtonAction(sender: UIButton!) {
        print("Next button tapped")
    }
    
    @objc func previousButtonAction(sender: UIButton!) {
        print("Previous button tapped")
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
            maker.centerX.equalToSuperview()
            maker.top.equalTo(largePictureImageView).inset(30)
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
}
