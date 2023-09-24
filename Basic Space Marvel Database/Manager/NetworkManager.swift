//
//  NetworkManager.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

protocol NetworkProtocol
{
    func request(requestURL: String, queryItems: [URLQueryItem], callback: @escaping(_ serverResponse: HTTPURLResponse?, _ data: Data?, _ error: Error?) -> Void)
}
class NetworkManager: NetworkProtocol
{
    func request(requestURL: String, queryItems: [URLQueryItem] = [URLQueryItem](), callback: @escaping(_ serverResponse: HTTPURLResponse?, _ data: Data?, _ error: Error?) -> Void)
    {
        var requestURL = URLComponents(string: requestURL)
        requestURL?.queryItems = queryItems
        guard let requestURLString = requestURL?.string, let url = URL(string: requestURLString) else { callback(nil, nil, nil); return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            
            guard error == nil, let serverResponse = response as? HTTPURLResponse, serverResponse.statusCode == 200, let receivedData = data else
            {
                callback(nil, nil, error)
                
                return
            }
            
            callback(serverResponse, receivedData, error)
        }
        
        task.resume()
    }
}
