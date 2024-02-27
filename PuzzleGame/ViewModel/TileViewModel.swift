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
        
        let rowDivider = CGFloat(index % 3)
        let colDivider = CGFloat(index / 3)
       
        let minSide = min(width, height)
        
        let tileSizeDimensionMargin = -minSide / 3
        
        self.leftMargin = rowDivider == 0 ? 0 : tileSizeDimensionMargin * rowDivider
        self.topMargin = colDivider == 0 ? 0 : tileSizeDimensionMargin * colDivider
    }
    
}
