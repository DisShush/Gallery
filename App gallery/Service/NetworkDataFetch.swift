//
//  NetworkDataFetch.swift
//  App gallery
//
//  Created by Владислав Шушпанов on 20.08.2021.
//

import Foundation

class NetworkDataFetch {
    
    var networkService = NetworkService()
    
    func fetchImage(completion: @escaping (PhotoData?) -> ()) {
        
        networkService.request { [self] data, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            let decode = decodeJSON(type: PhotoData.self, data: data)
            DispatchQueue.main.async {
                completion(decode)
            }
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil }
        
        do {
            let json = try decoder.decode(type.self, from: data)
            return json
        } catch let error {
            print(error)
            return nil
        }
    }
}
