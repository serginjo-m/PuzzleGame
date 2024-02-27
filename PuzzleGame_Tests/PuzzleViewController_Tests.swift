//
//  PuzzleViewController_Tests.swift
//  PuzzleGame_Tests
//
//  Created by Serginjo Melnik on 26/02/24.
//

import XCTest
@testable import PuzzleGame

//Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
//->Naming Structure: test_[struct or class]_[variable or func]_[expected result]


//Testing Stucture:

//Given (Arrange)

//When (Act)

//Then (Assert)


final class PuzzleViewController_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Make sure puzzle constructor is defined
    func test_PuzzleViewController_puzzle_shouldBeDefined(){
        //Given (Arrange)
        let vc = PuzzleViewController()
        
        //When (Act)
        let puzzle = vc.puzzle
        //Then (Assert)
        XCTAssertNotNil(puzzle)
    }
    
    //Make sure that collection view is hidden before network service response received
    func test_PuzzleViewController_puzzleCollectionView_shouldBeHidden(){
        //Given
        let vc = PuzzleViewController()
        
        //When
        let collectionView = vc.puzzleCollectionView
        
        //Then
        XCTAssertTrue(collectionView.isHidden)
    }
    
    //Make sure that activity indicator is animating before network response received
    func test_PuzzleViewController_activityIndicator_shouldAnimating(){
        //Given (Arrange)
        let vc = PuzzleViewController()
        //When (Act)
        let indicator = vc.activityIndicator
        //Then (Assert)
        XCTAssertTrue(indicator.isAnimating)
    }
    
    //Make sure that screenElements func toggles visibility of elements properly
    func test_PuzzleViewController_screenElements_shouldToggleDisplaying(){
        //Given (Arrange)
        let vc = PuzzleViewController()
        let activityIndicator = vc.activityIndicator
        let collectionView = vc.puzzleCollectionView
        //When (Act)
        vc.screenElements(shouldShow: true)
        //Then (Assert)
        XCTAssertFalse(activityIndicator.isAnimating)
        XCTAssertFalse(collectionView.isHidden)
    }
    
    //Make sure that puzzle is unordered every time when game is started
    func test_PuzzleViewController_puzzle_shouldBeUnordered(){
        for _ in 0...100 {
            //Given (Arrange)
            let puzzleVC = PuzzleViewController()
            
            //When (Act)
            let puzzle = puzzleVC.puzzle
            //Then (Assert)
            XCTAssertNotEqual(puzzle.orderedItems, puzzle.unOredredItems)
        }
    }
    
}
