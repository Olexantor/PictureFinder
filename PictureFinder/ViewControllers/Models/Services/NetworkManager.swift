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
        completion: @escaping (Pictures) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        let url = urlSerpapi + query + serpapiKey
        guard let supplementedUrl = url.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else { return }
        AF.request(supplementedUrl).validate().responseJSON { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else { return }
                    let json = try JSONDecoder().decode(PictureModel.self, from: data)
                    guard let pictures = Pictures(data: json) else { return }
                    print(pictures.refsOnPictures)
                    completion(pictures)
                } catch {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

    private init() {}
}
