//
//  Puzzle.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 23/02/24.
//

import Foundation

struct Puzzle: Codable {
    
    var orderedItems: [String]
    var unOredredItems: [String]

    init() {
        //solved order (when to show alert: You Win!)
        self.orderedItems = Array(1...9).map({ element in
            return "\(element)"
        })
        //here is a trick of mixing an array
        self.unOredredItems = self.orderedItems.shuffled()
    }
}
