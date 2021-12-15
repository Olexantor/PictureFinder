//
//  PictureModel.swift
//  PictureFinder
//
//  Created by Александр on 15.12.2021.
//

import Foundation

struct PictureModel {
    let imagesResults: [ImagesResult]

    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
    }
}

struct ImagesResult: Codable {
    let position: Int
    let original: String
}
