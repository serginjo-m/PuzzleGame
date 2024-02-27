//
//  Puzzle.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 23/02/24.
//

import Foundation

struct Puzzle: Codable {
    
    var orderedItems: [Int]
    var unOredredItems: [Int]
    var userCorrectDrop: [Int: Int]

    init() {
        //solved order (when to show alert: You Win!)
        self.orderedItems = Array(0...8)
        //here is a trick of mixing an array
        self.unOredredItems = self.orderedItems.shuffled()
        //holds users correct drops that helps to block only correct position tile by user
        self.userCorrectDrop = [:]
    }
}
