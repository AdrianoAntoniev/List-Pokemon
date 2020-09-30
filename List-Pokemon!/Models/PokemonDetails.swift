//
//  PokemonDetails.swift
//  List-Pokemon!
//
//  Created by Adriano Rodrigues Vieira on 29/09/20.
//  Copyright © 2020 Adriano Rodrigues Vieira. All rights reserved.
//

import Foundation

struct PokemonDetailsData: Decodable {
    var height: Int
    var weight: Int
    var sprites: Sprite
    
    struct Sprite: Decodable {
        var other: Other
        
        struct Other: Decodable {
            var officialArtwork: OfficialArtwork
            
            struct OfficialArtwork: Decodable {
                var frontDefault: String?
            }
            
            private enum CodingKeys : String, CodingKey {
                case officialArtwork = "official-artwork"
            }
        }
        
    }
}
