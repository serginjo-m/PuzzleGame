//
//  Outcome.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 27/02/24.
//

import Foundation

enum Outcome<Value>
{
    //success case
    case success(Value)
    //failure case
    case failure(Error)
    
    var value: Value? {
        if case .success(let theValue) = self {
            return theValue
        }
        return nil
    }
    
    var error: Error? {
        if case .failure(let theError) = self {
            return theError
        }
        return nil
    }
}
