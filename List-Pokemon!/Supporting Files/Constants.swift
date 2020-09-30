//
//  Constants.swift
//  List-Pokemon!
//
//  Created by Adriano Rodrigues Vieira on 29/09/20.
//  Copyright © 2020 Adriano Rodrigues Vieira. All rights reserved.
//

import Foundation

struct Constants {
    // URLS
    static let POKEMON_API = "https://pokeapi.co/api/v2/pokemon?limit=1051&offset=0"
    
    // Constants relative to UI
    static let REUSABLE_CELL_FOR_TABLEVIEW = "Cell"
    static let DETAILS_SEGUE_NAME = "DetailsSegue"
    static let SEARCH_BAR_PLACEHOLDER = "Digite o nome do Pokémon"
    static let BLANK_IMAGE_NAME = "sem-imagem.jpeg"
    
    // Constants for label text
    static let FONT_NAME = "American Typewriter"
    static let FONT_SIZE = 20

    // Keys for json queries
    static let POKEMON_NAME_KEY = "name"
    static let POKEMON_URL_KEY = "url"
}

