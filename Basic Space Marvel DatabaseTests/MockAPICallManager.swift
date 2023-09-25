//
//  MockAPICallManager.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/24/23.
//

import Foundation

class MockAPICallManager: APIProtocol
{
    var bundle: Bundle
    {
        Bundle(for: type(of: self))
    }
    
    var networkManager: NetworkProtocol?
    
    init(networkManager: NetworkProtocol?)
    {
        self.networkManager = networkManager
    }
    
    func getHeroList(pageCount: Int, callback: @escaping ([Character]?, Error?) -> Void)
    {
        
        let requestURL = "https://gateway.marvel.com/v1/public/characters"
        
        networkManager?.request(requestURL: requestURL, queryItems: [URLQueryItem]())
        {
            serverResponse, data, error in
            
            guard let serverResponse = serverResponse, serverResponse.statusCode == 200 else { callback(nil, error);return }
            guard let data = data else {callback(nil, error); return}
            do
            {
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawResponseModel.self, from: data)
                callback(response.nestedData.results, error)
            }
            catch
            {
                print(error)
                callback(nil, error)
            }
        }
    }
    
    func getContentList(pageCount: Int, hero: Character, contentType: contentType, callback: @escaping ([Content]?, Error?) -> Void) {
        
        let requestURL = "https://gateway.marvel.com/v1/public/characters/\(hero.id)/\(contentType)"

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "offset", value: "\(pageCount)"),
            URLQueryItem(name: "apikey", value: "publicAPIKey"),
            URLQueryItem(name: "ts", value: "1"),
            URLQueryItem(name: "hash", value: "1"),
            URLQueryItem(name: "limit", value: "2")
        ]
        networkManager?.request(requestURL: requestURL, queryItems: queryItems)
        {
            serverResponse, data, error in
            
            guard let data = data else {callback(nil, error); return}
            do
            {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawDetailResponseModel.self, from: data)
                callback(response.nestedData.results, error)
            }
            catch
            {
                print(error)
                callback(nil, error)
            }
        }
    }
    
    
}
