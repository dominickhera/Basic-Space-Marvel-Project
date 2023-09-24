//
//  Thumbnail.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

class Thumbnail: NSObject, Decodable
{
    var path: String
    var thumbnailExtension: String
    
    enum CodingKeys: String, CodingKey
    {
        case path
        case thumbnailExtension = "extension"
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        path = try values.decode(String.self, forKey: .path)
        thumbnailExtension = try values.decode(String.self, forKey: .thumbnailExtension)
    }
    
}
