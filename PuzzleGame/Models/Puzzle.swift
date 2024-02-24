//
//  Puzzle.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 23/02/24.
//

import Foundation

struct Puzzle: Codable {
    var title: String
    var solvedImages: [String]
    var unSolvedImages: [String]
    
    init(title: String, solvedImages: [String]) {
        //denotes the full size image name which is used to show hint
        self.title = title
        //solved order (when to show alert: You Win!)
        self.solvedImages = solvedImages
        //here is a trick of mixing an array
        self.unSolvedImages = self.solvedImages.shuffled()
    }
}
