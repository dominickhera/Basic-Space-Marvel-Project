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
    var items: [Content]
    
    init(available: Int, items: [Content])
    {
        self.available = available
        self.items = items
    }
    
    enum CodingKeys: String, CodingKey
    {
        case available
        case items
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        available = try values.decode(Int.self, forKey: .available)
        items = try values.decode([Content].self, forKey: .items)
        
    }
}
