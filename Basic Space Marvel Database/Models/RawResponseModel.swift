//
//  RawResponseModel.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

class RawResponseModel: NSObject, Decodable
{
    var nestedData: NestedHeroResultsModel
    
    enum CodingKeys: String, CodingKey
    {
        case nestedData = "data"
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nestedData = try values.decode(NestedHeroResultsModel.self, forKey: .nestedData)
    }
}
