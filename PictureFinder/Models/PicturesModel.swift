//
//  PicturesModel.swift
//  PictureFinder
//
//  Created by Александр on 18.12.2021.
//

struct PicturesModel {
    let images: [String]
    
    init?(data: PicturesData) {
        var tempArray: [String] = []
        data.imagesResults.forEach { image in
            tempArray.append(image.original)
        }
        self.images = tempArray
    }
}
