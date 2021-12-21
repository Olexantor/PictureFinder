//
//  PicturesData.swift
//  PictureFinder
//
//  Created by Александр on 15.12.2021.
//

import Foundation

struct PicturesData: Decodable {
    let imagesResults: [ImagesResult]

    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
    }
}

struct ImagesResult: Decodable {
    let position: Int
    let original: String
}
