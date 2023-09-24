//
//  UrlModel.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

class UrlModel: NSObject, Decodable
{
    var type: String
    var url: String
    
    enum CodingKeys: String, CodingKey
    {
        case type
        case url
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        url = try values.decode(String.self, forKey: .url)
    }
}
