//
//  NestedResultsModel.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

class NestedHeroResultsModel: NSObject, Decodable
{
    var results: [Character]
    
    enum CodingKeys: String, CodingKey
    {
        case results
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decode([Character].self, forKey: .results)
    }
}
