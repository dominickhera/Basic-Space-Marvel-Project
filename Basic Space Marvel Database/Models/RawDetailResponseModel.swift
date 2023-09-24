//
//  RawDetailResponseModel.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/24/23.
//

import Foundation

class RawDetailResponseModel: NSObject, Decodable
{
    var nestedData: NestedDetailResultsModel
    
    enum CodingKeys: String, CodingKey
    {
        case nestedData = "data"
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nestedData = try values.decode(NestedDetailResultsModel.self, forKey: .nestedData)
    }
}
