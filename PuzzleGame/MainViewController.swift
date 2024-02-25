//
//  MainViewController.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 25/02/24.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play New Game", for: .normal)
        button.addTarget(self, action: #selector(handleNewGameSession), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleNewGameSession(){
        
        navigationController?.pushViewController(PuzzleViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        configureViews()
    }
    
    fileprivate func configureViews(){
        
        view.backgroundColor = .init(white: 0.14, alpha: 1)
        
        let title = UILabel()
        title.textColor = .white
        title.font = .systemFont(ofSize: 24)
        title.text = "Puzzle Game"
        title.textAlignment = .center
        navigationItem.titleView = title
        
        view.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}