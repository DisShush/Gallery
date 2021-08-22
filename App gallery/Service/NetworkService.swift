//
//  NetworkService.swift
//  App gallery
//
//  Created by Владислав Шушпанов on 20.08.2021.
//

import Foundation

class NetworkService {
    
    func request(completion: @escaping (Data?, Error?) -> Void) {
        
        guard let url = URL(string: "https://api.unsplash.com/photos/random?count=30") else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "Client-ID I63s3J-WxdBruX8J2tfPpPkoXoEERpiIEqFQFLjxyWo"]
        request.httpMethod = "get"
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
                        
            DispatchQueue.main.async {
                completion(data, error)
            }

        }.resume()
        
    }
    
}
