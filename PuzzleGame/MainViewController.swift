//
//  MainViewController.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 25/02/24.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play New Game", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .link
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleNewGameSession), for: .touchUpInside)
        return button
    }()
    
    var gameTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Puzzle Game"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 36)
        label.textColor = .black
        return label
    }()
    
    @objc func handleNewGameSession(){
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(PuzzleViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        configureViews()
    }
    
    fileprivate func configureViews(){
        view.backgroundColor = .white
        view.addSubview(playButton)
        view.addSubview(gameTitle)
        
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        gameTitle.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -50).isActive = true
        gameTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        gameTitle.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
}
