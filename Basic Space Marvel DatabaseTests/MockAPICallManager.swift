//
//  MockAPICallManager.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/24/23.
//

import Foundation

class MockAPICallManager: APIProtocol
{
    func getHeroList(pageCount: Int, callback: @escaping ([Character]?, Error?) -> Void) {
        <#code#>
    }
    
    func getContentList(pageCount: Int, hero: Character, contentType: contentType, callback: @escaping ([Content]?, Error?) -> Void) {
        <#code#>
    }
    
    
}
