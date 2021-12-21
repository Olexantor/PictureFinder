//
//  ManyPicturesCell.swift
//  PictureFinder
//
//  Created by Александр on 14.12.2021.
//

import UIKit

class ManyPicturesCell: UICollectionViewCell {
    static let identifier = "Pictures cell"
    private let cellImage: UIImageView = {
        let view = UIImageView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellImage)
        cellImage.frame = contentView.bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
