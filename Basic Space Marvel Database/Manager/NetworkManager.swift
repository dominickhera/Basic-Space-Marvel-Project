//
//  NetworkManager.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

protocol URLSessionProtocol
{
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol 
{
    func resume()
}

class NetworkManager
{
    
    private let session: URLSessionProtocol
            
    init(session: URLSessionProtocol)
    {
        self.session = session
    }
    
    func request(requestURL: String, queryItems: [URLQueryItem] = [URLQueryItem](), callback: @escaping(_ serverResponse: HTTPURLResponse?, _ data: Data?, _ error: Error?) -> Void)
    {
        var requestURL = URLComponents(string: requestURL)
        requestURL?.queryItems = queryItems
        guard let requestURLString = requestURL?.string, let url = URL(string: requestURLString) else { callback(nil, nil, nil); return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request)
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

extension URLSession: URLSessionProtocol 
{
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol 
    {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
