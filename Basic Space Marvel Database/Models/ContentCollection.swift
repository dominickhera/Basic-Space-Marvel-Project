//
//  ComicCollection.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

class ContentCollection: NSObject, Decodable
{
    
    var available: Int
    var collectionURI: String
    var items: [Content]
    var returned: Int
    
    enum CodingKeys: String, CodingKey
    {
        case available
        case collectionURI
        case items
        case returned
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        available = try values.decode(Int.self, forKey: .available)
        collectionURI = try values.decode(String.self, forKey: .collectionURI)
        items = try values.decode([Content].self, forKey: .items)
        returned = try values.decode(Int.self, forKey: .returned)
        
    }
}
