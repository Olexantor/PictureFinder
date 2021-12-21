//
//  Pictures.swift
//  PictureFinder
//
//  Created by Александр on 20.12.2021.
//

struct Pictures {
    var refsOnPictures = [String]()
    
    init?(data: PictureModel) {
        data.imagesResults.forEach { image in
            refsOnPictures.append(image.original)
        }
    }
}
