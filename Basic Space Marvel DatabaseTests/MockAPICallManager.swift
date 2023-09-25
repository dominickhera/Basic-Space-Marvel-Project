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
    
    var networkManager: NetworkManager?
    
    init(networkManager: NetworkManager?)
    {
        self.networkManager = networkManager
    }
    
    func getHeroList(pageCount: Int, callback: @escaping ([Character]?, Error?) -> Void)
    {
        if let path = bundle.url(forResource: "HeroList", withExtension: "json")
        {
            do
            {
                let data = try Data(contentsOf: path)
                let decoder = JSONDecoder()
                let response = try decoder.decode(RawResponseModel.self, from: data)
                
                callback(response.nestedData.results, nil)
            }
            catch
            {
                callback(nil, error)
            }
        }
    }
    
    func getContentList(pageCount: Int, hero: Character, contentType: contentType, callback: @escaping ([Content]?, Error?) -> Void) {
        callback(nil, nil)
    }
    
    
}
