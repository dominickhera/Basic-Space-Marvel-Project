//
//  Enums.swift
//  Basic Space Marvel Database
//
//  Created by Dominick Hera on 9/24/23.
//

import Foundation

enum contentType: String
{
    case comics = "comics"
    case events = "events"
}

enum urlType: String
{
    case detail// = "details"
    case wiki //= "wiki"
    case comiclink// = "comiclink"
    var title: String 
    {
        switch self
        {
        case .detail : return "Details"
        case .wiki : return "Wiki"
        case .comiclink : return "Comics"
        }
    }
}
