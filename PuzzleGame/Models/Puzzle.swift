//
//  Puzzle.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 23/02/24.
//

import Foundation

struct Puzzle: Codable {
    //puzzle items in correct order
    var orderedItems: [Int] 
    //puzzle items in incorrect order
    var unOredredItems: [Int]
    
    init() {
        //solved order
        self.orderedItems = Array(0...8)
        //shuffled items into incorrect positions
        self.unOredredItems = self.orderedItems.shuffled()
    }
}
