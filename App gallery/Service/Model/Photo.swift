//
//  Photo.swift
//  App gallery
//
//  Created by Владислав Шушпанов on 20.08.2021.
//

import Foundation

struct Photo: Codable {
    let likes: Int
    let urls: [URLKind.RawValue:String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

typealias PhotoData = [Photo]


