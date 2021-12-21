//
//  ManyPicturesCell.swift
//  PictureFinder
//
//  Created by Александр on 14.12.2021.
//

import UIKit

class ManyPicturesCell: UICollectionViewCell {
    static let identifier = "Pictures cell"
    let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = colorForCollectionView
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
