//
//  Pictures.swift
//  PictureFinder
//
//  Created by Александр on 20.12.2021.
//
import UIKit

struct Pictures {
    var refsOnPictures = [URL]()
    
    init?(data: PictureModel) {
        data.imagesResults.forEach { image in
            guard let url = URL(string: image.original) else { return }
            refsOnPictures.append(url)
        }
    }
}
