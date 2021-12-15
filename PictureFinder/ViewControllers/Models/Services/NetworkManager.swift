//
//  NetworkManager.swift
//  PictureFinder
//
//  Created by Александр on 15.12.2021.
//

import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchPicturesLinksWith(
        query: String,
        completion: @escaping (Result<PictureModel, Error>) -> Void) {
            let url = urlSerpapi + query + serpapiKey
            AF.request(url).validate().responseDecodable(of: PictureModel.self) { response in
                switch response.result {
                case .success(let pictures):
                    completion(.success(pictures))
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    
    private init() {}
}
