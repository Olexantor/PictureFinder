//
//  PicturesModel.swift
//  PictureFinder
//
//  Created by Александр on 18.12.2021.
//

struct PictureModel: Decodable {
    
    let imagesResults: [ImagesResult]

    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
    }
}

struct ImagesResult: Decodable {
    let original: String
}
