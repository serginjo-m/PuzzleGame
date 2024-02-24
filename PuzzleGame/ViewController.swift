//
//  ViewController.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 22/02/24.
//

import UIKit

class ViewController: UIViewController{
   
    private var collectionView: UICollectionView?
    
    var colors: [UIColor] = [
        .link,.systemGreen, .systemBlue, .red, .systemOrange, .black, .systemPurple, .systemYellow, .systemPink
    ]
    
    var puzzle = [
        Puzzle(title: "StreetFighter", solvedImages: ["1", "2", "3", "4", "5", "6", "7", "8", "9"])
    ]
    
    //current puzzle (difficulty) index
    var index: Int = 0
    //shows hint for 2 seconds
    var gameTimer: Timer?
    //full image
    var hintImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let rightBarItem = UIBarButtonItem(title: "Hint",
                        style: .plain,
                        target: self,
                        action: #selector(handleHint))
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        navigationItem.title = "Users View"
        
        
        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width/3.2,
                                 height: view.frame.size.width/3.2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(PuzzleCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.dragInteractionEnabled = true
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView?.addGestureRecognizer(gesture)
        view.addSubview(collectionView!)
        view.backgroundColor = .white
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer){
        guard let collectionView = self.collectionView else {return}
        
        switch gesture.state{
            
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {return}
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
    
    @objc func handleHint(){
        hintImage.image = UIImage(named: "full")
        hintImage.backgroundColor = .white
        hintImage.contentMode = .scaleAspectFit
        hintImage.frame = self.view.frame
        self.view.addSubview(hintImage)
        self.collectionView?.isHidden = true
        self.view.bringSubviewToFront(hintImage)
        gameTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(removeHintImage), userInfo: nil, repeats: false)
    }
    @objc func removeHintImage() {
        self.view.sendSubviewToBack(hintImage)
        self.collectionView?.isHidden = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

extension ViewController: UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return colors.count
        return puzzle[self.index].unSolvedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PuzzleCell
        cell.imageView.image = UIImage(named: puzzle[self.index].unSolvedImages[indexPath.item])
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.size.width/3.2, height: view.frame.size.width/3.2)
        
        let collectionViewWidth = collectionView.bounds.width
        var customCollectionWidth: CGFloat!
        
        if puzzle[self.index].title == "StreetFighter" {
            customCollectionWidth = collectionViewWidth/4 - 8
        }else{
            customCollectionWidth = collectionViewWidth/3 - 10
        }
        
        return CGSize(width: customCollectionWidth, height: customCollectionWidth)
    }
    
    //TODO: Sort them out correctly
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let item = colors.remove(at: sourceIndexPath.row)
//        colors.insert(item, at: destinationIndexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if puzzle[self.index].title == "StreetFighter" {
            return UIEdgeInsets(top: 40, left: 16, bottom: 40, right: 16)
        }else{
            return UIEdgeInsets(top: 40, left: 10, bottom: 40, right: 10)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.puzzle[self.index].unSolvedImages[indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = dragItem
        return [dragItem]
    }
}

extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        }else{
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            self.collectionView?.reloadData()
        }
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath{
            collectionView.performBatchUpdates {
                puzzle[self.index].unSolvedImages.swapAt(sourceIndexPath.item, destinationIndexPath.item)
                collectionView.reloadItems(at: [sourceIndexPath, destinationIndexPath])
            }
            //MARK: have a bit .....
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        if puzzle[self.index].unSolvedImages == puzzle[self.index].solvedImages {
            Alert.showSolvedPuzzleAlert(on: self)
            
            collectionView.dragInteractionEnabled = false
//            if index == puzzle.count - 1 {
//                navigationItem.rightBarButtonItem?.isEnabled = false
//            }else{
//                navigationItem.rightBarButtonItem?.isEnabled = true
//            }
        }
    }
}
