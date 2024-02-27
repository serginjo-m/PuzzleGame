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
    
    
    //don't really like this approach
    func test_PhotoLoader_fetchImage_shouldReturnImage(){
        //Given (Arrange)
        let loader = PhotoApi.GetPhoto()
        //When (Act)
        var image: UIImage?
        
        loader.fetchImage { outcome in
            switch outcome {
                
            case .success(let img):
                image = img
            case .failure(_):
                image = nil
            }
            //Then (Assert)
           XCTAssertNotNil(image)
        }
    }
    
    
    //This one checks if function returns something in 5 seconds
    func test_PhotoLoader_fetchImage_shouldReturnData(){
        //Given (Arrange)
        let photoLoader = PhotoApi.GetPhoto()

        //When (Act)
        var image: UIImage?
        let expectation = XCTestExpectation()
        
        photoLoader.fetchImage { outcome in
            
            switch outcome {
                
            case .success(let img):
                image = img
            case .failure(_):
                image = nil
            }

            expectation.fulfill()
        }
        //Then (Assert)
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(image)
    }
    //Make sure that the baseURL string can be converted to valid URL
    func test_PhotoLoader_baseURL_shouldBeValidURLString(){
        //Given (Arrange)
        let loader = PhotoApi.GetPhoto()
        var baseUrl = loader.baseURL
        //When (Act)
        let validUrl = URL(string: baseUrl)
        //Then (Assert)
        XCTAssertNotNil(validUrl)
    }
    
}
