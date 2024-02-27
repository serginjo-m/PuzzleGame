//
//  Outcome.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 27/02/24.
//

import Foundation

enum Outcome<Value>
{
    //success case with some value(generic)?
    case success(Value)
    //failure case with Error
    case failure(Error)
    
    //contains a value, with optioanal Value
    //in .success case it assign an enum (Outcome) value to "value" var. Else nil
    var value: Value?
    {
        if case .success(let theValue) = self
        {
            return theValue
        }
        return nil
    }
    //contains optional error
    //in case of .failure it assigns Error to "error" variable
    var error: Error?
    {
        if case .failure(let theError) = self
        {
            return theError
        }
        return nil
    }
    
    //holds success Bool
    //in case of success true, eles false
    var success: Bool
    {
        if case .success = self
        {
            return true
        }
        return false
    }
}
