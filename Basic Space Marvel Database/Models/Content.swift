//
//  Comic.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

class Content: NSObject, Decodable
{
    var name: String?
    var thumbnail: Thumbnail?
    
    init(name: String?, thumbnail: Thumbnail?)
    {
        self.name = name
        self.thumbnail = thumbnail
    }
    
    enum CodingKeys: String, CodingKey
    {
        case name
        case type
        case thumbnail
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
    }
}
