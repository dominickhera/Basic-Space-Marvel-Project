//
//  APICallManager.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation
import CryptoKit

protocol APIProtocol
{
    func getHeroList(pageCount: Int, callback: @escaping(_ heroList: [Character]?, _ error: Error?) -> Void)
    func getContentList(pageCount: Int, hero: Character, contentType: contentType, callback: @escaping(_ contentList: [Content]?, _ error: Error?) -> Void)
}

class APICallManager: APIProtocol
{
    var networkManager: NetworkManager?
    
    init(networkManager: NetworkManager?)
    {
        self.networkManager = networkManager
    }
    
    func getHeroList(pageCount: Int, callback: @escaping(_ heroList: [Character]?, _ error: Error?) -> Void)
    {
        let requestURL = "https://gateway.marvel.com/v1/public/characters"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let tempDate = dateFormatter.string(from: Date())
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "offset", value: "\(pageCount)"),
            URLQueryItem(name: "apikey", value: "\(publicAPIKey)"),
            URLQueryItem(name: "ts", value: tempDate),
            URLQueryItem(name: "hash", value: getAuthHash())
        ]
        
        networkManager?.request(requestURL: requestURL, queryItems: queryItems)
        {
            serverResponse, data, error in
            
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
    
    func getContentList(pageCount: Int, hero: Character, contentType: contentType, callback: @escaping(_ contentList: [Content]?, _ error: Error?) -> Void)
    {
        let requestURL = "https://gateway.marvel.com/v1/public/characters/\(hero.id)/\(contentType)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let tempDate = dateFormatter.string(from: Date())
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "offset", value: "\(pageCount)"),
            URLQueryItem(name: "apikey", value: "\(publicAPIKey)"),
            URLQueryItem(name: "ts", value: tempDate),
            URLQueryItem(name: "hash", value: getAuthHash())
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

extension APICallManager
{
    private var privateAPIKey: String
    {
      get
        {

        guard let filePath = Bundle.main.path(forResource: "Configuration", ofType: "plist") else { fatalError("Error") }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Marvel_Private_API_Key") as? String else { fatalError("couldnt find private api key") }
        return value
      }
    }
    
    private var publicAPIKey: String
    {
      get
        {

        guard let filePath = Bundle.main.path(forResource: "Configuration", ofType: "plist") else { fatalError("Error") }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Marvel_Public_API_Key") as? String else { fatalError("couldnt find private api key") }
        return value
      }
    }
    
    private func getAuthHash() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let tempDate = dateFormatter.string(from: Date())
        let baseHash: String = tempDate+privateAPIKey+publicAPIKey
        let authHash = Insecure.MD5.hash(data: baseHash.data(using: .utf8)!).map {String(format: "%02x", $0)}.joined()
        
        return authHash
    }
}
