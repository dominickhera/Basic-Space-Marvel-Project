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
    
    init(id: Int, name: String, characterDescription: String, thumbnail: Thumbnail, comics: ContentCollection, events: ContentCollection)
    {
        self.id = id
        self.name = name
        self.characterDescription = characterDescription
        self.thumbnail = thumbnail
        self.comics = comics
        self.events = events
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case characterDescription = "description"
        case thumbnail
        case comics
        case events

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
    }
}
