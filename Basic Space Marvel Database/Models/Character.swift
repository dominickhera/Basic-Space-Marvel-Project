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
    var comics: ContentCollection
    var events: ContentCollection
    var series: ContentCollection
    var stories: ContentCollection
    var urls: [UrlModel]
    
    init(id: Int, name: String, characterDescription: String, thumbnail: Thumbnail, comics: ContentCollection, events: ContentCollection, series: ContentCollection, stories: ContentCollection, urls: [UrlModel])
    {
        self.id = id
        self.name = name
        self.characterDescription = characterDescription
        self.thumbnail = thumbnail
        self.comics = comics
        self.events = events
        self.series = series
        self.stories = stories
        self.urls = urls
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case characterDescription = "description"
        case thumbnail
        case comics
        case events
        case series
        case stories
        case urls
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        characterDescription = try values.decode(String.self, forKey: .characterDescription)
        thumbnail = try values.decode(Thumbnail.self, forKey: .thumbnail)
        comics = try values.decode(ContentCollection.self, forKey: .comics)
        events = try values.decode(ContentCollection.self, forKey: .events)
        series = try values.decode(ContentCollection.self, forKey: .series)
        stories = try values.decode(ContentCollection.self, forKey: .stories)
        urls = try values.decode([UrlModel].self, forKey: .urls)
    }
}
