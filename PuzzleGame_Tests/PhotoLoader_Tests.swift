//
//  PhotoLoader_Tests.swift
//  PuzzleGame_Tests
//
//  Created by Serginjo Melnik on 26/02/24.
//

import XCTest
@testable import PuzzleGame
//Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
//->Naming Structure: test_[struct or class]_[variable or func]_[expected result]

//Given (Arrange)

//When (Act)

//Then (Assert)



final class PhotoLoader_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_PhotoLoader_fetchImage_shouldReturnData(){
        //Given (Arrange)
        let photoLoader = PhotoApi.GetPhoto()

        //When (Act)
        var image: UIImage?
        var expectation = XCTestExpectation()
        photoLoader.fetchImage { data in
            guard let data = data else {return}
            image = UIImage(data: data)
            expectation.fulfill()
        }
        //Then (Assert)
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(image)
    }


}
