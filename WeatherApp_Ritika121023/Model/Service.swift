//
//  Service.swift
//  WeatherApp_Ritika121023
//
//  Created by user248634 on 10/12/23.
//

import Foundation

class Service{
    
    private init(){}
    static var shared = Service()
    
    func getData(urlStr:String,queryItems:[URLQueryItem]?, completion:@escaping (Result<Data,Error>)->()){

        var urlComponents = URLComponents(string: urlStr)
        if let queryParams = queryItems{
            urlComponents?.queryItems = queryItems
        }
        if let modifiedUrlObj = urlComponents?.url{
            let urlRequest = URLRequest(url: modifiedUrlObj)
            URLSession.shared.dataTask(with: urlRequest) {data, response, error in
                if let error = error{
                    completion(.failure(error))
                }else if let data = data{
                    completion(.success(data))
                }
            }.resume()
        }
    }
}
