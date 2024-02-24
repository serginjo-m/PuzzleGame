//
//  Alert.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 23/02/24.
//

import UIKit

struct Alert {
    private static func showAlert(on viewController: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async { viewController.present(alert, animated: true)}
    }
    
    static func showSolvedPuzzleAlert(on viewController: UIViewController) {
        showAlert(on: viewController, with: "", message: "Congrats!!! \n You have solved this puzzle ")
    }
}
