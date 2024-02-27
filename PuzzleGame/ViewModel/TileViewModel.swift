//
//  TileViewModel.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 27/02/24.
//

import Foundation

struct TileViewModel {
    
    let leftMargin: CGFloat
    let topMargin: CGFloat
    
    init(width: CGFloat, height: CGFloat, index: Int){
        //calculates tile row position
        let rowDivider = CGFloat(index % 3)
        //calculates tile column position
        let colDivider = CGFloat(index / 3)
        //screen rotation require using of smallest side
        let minSide = min(width, height)
        //for 3 X 3 puzzle, .....
        let tileSizeDimensionMargin = -minSide / 3
        
        self.leftMargin = rowDivider == 0 ? 0 : tileSizeDimensionMargin * rowDivider
        self.topMargin = colDivider == 0 ? 0 : tileSizeDimensionMargin * colDivider
    }
    
}
