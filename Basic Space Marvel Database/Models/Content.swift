//
//  Comic.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

class Content: NSObject, Decodable
{
    var resourceURI: String
    var name: String?
    var type: String?
    var thumbnail: Thumbnail?
    
    enum CodingKeys: String, CodingKey
    {
        case resourceURI
        case name
        case type
        case thumbnail
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resourceURI = try values.decode(String.self, forKey: .resourceURI)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
    }
}
