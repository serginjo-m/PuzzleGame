//
//  TileViewModel.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 27/02/24.
//

import Foundation

struct TileViewModel {
    //image left padding
    let leftPadding: CGFloat
    //image top padding
    let topPadding: CGFloat
    
    init(width: CGFloat, height: CGFloat, index: Int){
        //calculates tile row position
        let rowDivider = CGFloat(index % 3)
        //calculates tile column position
        let colDivider = CGFloat(index / 3)
        //screen rotation require using of smallest side
        let minSide = min(width, height)
        //padding measurement unit is one tile size
        let tileSizeDimensionPadding = -minSide / 3
        
        //calculate image padding based on tile position in grid
        self.leftPadding = rowDivider == 0 ? 0 : tileSizeDimensionPadding * rowDivider
        self.topPadding = colDivider == 0 ? 0 : tileSizeDimensionPadding * colDivider
    }
    
}
