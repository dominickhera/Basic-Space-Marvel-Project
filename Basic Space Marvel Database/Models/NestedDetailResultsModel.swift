//
//  NestedDetailResultsModel.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

class NestedDetailResultsModel: NSObject, Decodable
{
    var results: [Content]
    
    enum CodingKeys: String, CodingKey
    {
        case results
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decode([Content].self, forKey: .results)
    }
}
