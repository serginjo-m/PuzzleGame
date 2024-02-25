//
//  PuzzleCell.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 23/02/24.
//

import UIKit
class PuzzleCell: UICollectionViewCell {
    
    var template: (top: CGFloat, leading: CGFloat)? {
        didSet{
            self.imageTopAnchor.constant = self.template!.top
            self.imageLeadingAnchor.constant = self.template!.leading
        }
    }
    
    let imageView: UIImageView = {
        let iView = UIImageView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.contentMode = .scaleAspectFill
        return iView
    }()
    
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
