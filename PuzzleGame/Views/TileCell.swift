//
//  PuzzleCell.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 23/02/24.
//

import UIKit
class TileCell: UICollectionViewCell {
    
    var tileViewModel: TileViewModel? {
        didSet{
            guard let tileViewModel = tileViewModel else {return}
            //set image top padding
            self.imageTopAnchor.constant = tileViewModel.topPadding
            //set image left padding
            self.imageLeadingAnchor.constant = tileViewModel.leftPadding
        }
    }
    
    let imageView: UIImageView = {
        let iView = UIImageView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.contentMode = .scaleAspectFill
        return iView
    }()
    
    //using constant parameter of this two constraints can update image padding dynamicaly
    var imageTopAnchor: NSLayoutConstraint!
    var imageLeadingAnchor: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(imageView)
        imageTopAnchor = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        imageTopAnchor.isActive = true
        imageLeadingAnchor = imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        imageLeadingAnchor.isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 3).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
