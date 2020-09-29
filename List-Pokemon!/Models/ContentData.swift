//
//  ContentData.swift
//  List-Pokemon!
//
//  Created by Adriano Rodrigues Vieira on 29/09/20.
//  Copyright © 2020 Adriano Rodrigues Vieira. All rights reserved.
//

import Foundation

struct ContentData: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [[String:String]]?
}
