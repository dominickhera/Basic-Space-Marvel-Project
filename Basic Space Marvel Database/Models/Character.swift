//
//  Character.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/20/23.
//

import Foundation

class Character: NSObject, Decodable
{
    var id: Int
    var name: String
    var characterDescription: String
    var thumbnail: Thumbnail
    var resourceURI: String
    var comics: ContentCollection
    var series: ContentCollection
    var stories: ContentCollection
    var events: ContentCollection
    var urls: [UrlModel]
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case characterDescription = "description"
        case thumbnail
        case resourceURI
        case comics
        case series
        case stories
        case events
        case urls
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        characterDescription = try values.decode(String.self, forKey: .characterDescription)
        thumbnail = try values.decode(Thumbnail.self, forKey: .thumbnail)
        resourceURI = try values.decode(String.self, forKey: .resourceURI)
        comics = try values.decode(ContentCollection.self, forKey: .comics)
        series = try values.decode(ContentCollection.self, forKey: .series)
        stories = try values.decode(ContentCollection.self, forKey: .stories)
        events = try values.decode(ContentCollection.self, forKey: .events)
        urls = try values.decode([UrlModel].self, forKey: .urls)
    }
}
