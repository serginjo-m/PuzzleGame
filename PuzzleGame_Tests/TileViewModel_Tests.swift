//
//  TileViewModel_Tests.swift
//  PuzzleGame_Tests
//
//  Created by Serginjo Melnik on 27/02/24.
//

import XCTest
@testable import PuzzleGame
//Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
//->Naming Structure: test_[struct or class]_[variable or func]_[expected result]

//Given (Arrange)

//When (Act)

//Then (Assert)

final class TileViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Make sure view model convert input properly for the first tile
    func test_TileViewModel_margin_shouldConvertProperly(){
        //Given (Arrange)
        let tileViewModel = TileViewModel(width: 600, height: 800, index: 0)
        //When (Act)
        
        //Then (Assert)
        XCTAssertEqual(tileViewModel.leftMargin, 0)
        XCTAssertEqual(tileViewModel.topMargin, tileViewModel.leftMargin)
    }
    //In 3 X 3 size puzzle the last tile should have top and left margin = 2/3 of min size
    func test_TileViewModel_margin_calculateInputForLastTile(){
        //Given (Arrange)
        let tileViewModel = TileViewModel(width: 800, height: 600, index: 8)
        //When (Act)
        
        //Then (Assert)
        XCTAssertEqual(tileViewModel.leftMargin, -400)
        XCTAssertEqual(tileViewModel.topMargin, tileViewModel.leftMargin)
    }

}
