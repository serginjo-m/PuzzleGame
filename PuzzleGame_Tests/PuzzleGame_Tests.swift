////
////  PuzzleGame_Tests.swift
////  PuzzleGame_Tests
////
////  Created by Serginjo Melnik on 25/02/24.
////
//
//
//import XCTest
//@testable import PuzzleGame//TODO: Remember to import this
//
////CMND+SHIFT+K - to clean up, if test button doesn't appear
//
////Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
////->Naming Structure: test_[struct or class]_[variable or func]_[expected result]
//
//
////Testing Stucture: Given (Arrange), When (Act), Then (Assert)
//
//
//final class PPuzzleViewController_Tests: XCTestCase {
//    //MARK: Be careful with this approach, because vc could be modified during all tests, so remember to reset it
//    var vc: PuzzleViewController?
//
//    override func setUpWithError() throws {
//        //MARK: calls before all tests
//        self.vc = PuzzleViewController()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    //MARK: this section is often uses to reset our properties (like vc in this case)
//    override func tearDownWithError() throws {
//        //MARK: Calls after all tests
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        self.vc = nil
//    }
//
//    //MARK: That's mine first test ever
//    func test_PuzzleViewController_screenElements_shouldBeHidden(){
//        //Given
//        guard let puzzle = vc else {
//            //It is like fail command
//            XCTFail()
//            return
//        }
//        let coll = puzzle.puzzleCollectionView
//        
//        //When
//        puzzle.screenElements(shouldShow: false)
//        
//        //Then
//        XCTAssertTrue(coll.isHidden)
//    }
//    
//    func test_PuzzleViewController_getPuzzlePhoto_shouldReturnPhoto(){
//        
//        //Given (Arrange)
//        let puzzle = PuzzleViewController()
//        let photo = puzzle.puzzleImage
//        
//        //When (Act)
//        puzzle.getPuzzlePhoto()
//        
//        //Then (Assert)
//        XCTAssertTrue(photo == nil)
//    }
//    //here I testing if puzzle object was injected properly
//    //clearly because puzzleVC - puzzle object unsolvedImages is always random, so can test it!
//    func test_PuzzleViewController_puzzle_shouldBeInjectedValue(){
//        //Given (Arrange)
//        let puzzleVC = PuzzleViewController()
//        
//        let puzzle = Puzzle(title: "StreetFighter", solvedImages: ["1", "2", "3", "4", "5", "6", "7", "8", "9"])
//        
//        //When (Act)
//        puzzleVC.puzzle = puzzle
//        
//        //Then (Assert)
//        XCTAssertEqual(puzzle.unOredredItems, puzzleVC.puzzle.unOredredItems)
//    }
//    //MARK: Safer version
//    //testing a bunch of times, give us possibility to see what happens in random value
//    func test_PuzzleViewController_puzzle_shouldBeInjectedValue_stress(){
//        for _ in 0...100{
//            //Given (Arrange)
//            let puzzleVC = PuzzleViewController()
//            
//            let puzzle = Puzzle(title: "StreetFighter", solvedImages: ["1", "2", "3", "4", "5", "6", "7", "8", "9"])
//            
//            //When (Act)
//            puzzleVC.puzzle = puzzle
//            
//            //Then (Assert)
//            XCTAssertEqual(puzzle.unOredredItems, puzzleVC.puzzle.unOredredItems)
//        }
//    }
//    
//    //This test should test if each puzzle cell is not in the right place(useless)
////    func test_PuzzleViewController_puzzle_shouldBeDifferent(){
////        for _ in 0...10 {
////            //Given (Arrange)
////            let vc = PuzzleViewController()
////            let puzzle = vc.puzzle
////            for i in 0..<9 {
////
////                //When (Act)
////                let x = puzzle.solvedImages[i]
////                let y = puzzle.unSolvedImages[i]
////                //Then (Assert)
////                XCTAssertNotEqual(x, y)
////            }
////        }
////    }
//    
//    //test if empty
//    func test_PuzzleViewController_puzzle_shouldNotBeEmpty(){
//        //Given (Arrange)
//        let vc = PuzzleViewController()
//        let puzzle = vc.puzzle
//        
//        //When (Act)
//        let arr = puzzle.unOredredItems
//        //Then (Assert)
//        XCTAssertTrue(!arr.isEmpty)
//        XCTAssertEqual(arr.count, 9)
//    }
//    //TODO: ShowHide is bad name
//    func test_PuzzleViewController_activityIndicator_shouldShowHideElement(){
//        
//        //Given (Arrange)
//        let vc = PuzzleViewController()
//        let indicator = vc.activityIndicator
//        let coll = vc.puzzleCollectionView
//        //When (Act)
//        vc.screenElements(shouldShow: true)
//        
//        
//        //Then (Assert)
//        XCTAssertFalse(indicator.isAnimating)
//        XCTAssertTrue(!indicator.isAnimating)
//        XCTAssertTrue(!coll.isHidden)
//        XCTAssertFalse(coll.isHidden)
//        
//    }
//
//    func test_PuzzleViewController_Puzzle_titleShouldNotBeEmpty(){
//        //Given (Arrange)
//        let vc = PuzzleViewController()
//        
//        //When (Act)
//        let loopCount: Int = Int.random(in: 1...100)
//        for _ in 0...loopCount {
//            vc.puzzle = Puzzle(title: UUID().uuidString, solvedImages: ["1"])
//            //Then (Assert)
//            XCTAssertFalse(vc.puzzle.title.isEmpty)
//        }
//    }
//    
//    //itemsArray.randomElement()-> returns random element from array
//    
//    
//    /*
//     
//     func saveItem(item: String) throws {
//        guard !item.isEmpty else {
//           DataError.noData
//        }
//     
//        if let x = dataArray.first(where: {$0 == item}){
//            print("Save item")
//        }else{
//            throw DataError.itemNotFound
//        }
//     }
//     
//     enum DataError: LocalizedError {
//        case noData
//        case itemNotFound
//     }
//     
//     //So we not only checking if func throws an error but we also check if func throws a correct error
//     XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw Item Not Found errorr!"){ error in
//         let returnedErrorr = error as? UnitTestingBootcapViewModel.CoreDataError
//         XCTAssertEqual(returnedErrorr, UnitTestingBootcapViewModel.CoreDataError.itemNotFound)
//     }
//     
//     do {
//        try vm.saveItem(item: "")
//     } catch {
//        let returnedError = error as? Unit.....Model.DataError
//        XCTAssertEqual(returnedError, Unit....Model.DataError.noDat)
//     }
//     
//     
//     
//     */
//    
//    
//    //TODO: _downloadWithEscaping_doesReturnValues
//}
////Given (Arrange)
//
////When (Act)
//
////Then (Assert)
