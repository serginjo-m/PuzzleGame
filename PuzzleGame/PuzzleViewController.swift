//
//  PuzzleViewController.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 22/02/24.
//

import UIKit

class PuzzleViewController: UIViewController{
   
    private var collectionView: UICollectionView?
    
    var puzzle = Puzzle(title: "StreetFighter", solvedImages: ["1", "2", "3", "4", "5", "6", "7", "8", "9"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width/3.2,
                                 height: view.frame.size.width/3.2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView?.register(PuzzleCell.self, forCellWithReuseIdentifier: "cell")
        //-->
        collectionView?.dragInteractionEnabled = true
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        //<--
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        
        
        view.addSubview(collectionView!)
        
        navigationItem.title = "Users View"
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        //TODO: use it for rotation
        print("view bounds are: \(view.bounds)")
    }

}

extension PuzzleViewController: UICollectionViewDataSource {
    //+
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return colors.count
        return puzzle.unSolvedImages.count
    }
    //+
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PuzzleCell
//        cell.imageView.image = UIImage(named: puzzle.unSolvedImages[indexPath.item])
        let sortedItem = puzzle.solvedImages[indexPath.item]
        let unsortedItem = puzzle.unSolvedImages[indexPath.item]
        if sortedItem == unsortedItem {
            print("this is right place: " + sortedItem + " " + unsortedItem)
        }
        
        switch puzzle.unSolvedImages[indexPath.item] {
        
        case "1":
            cell.template = (0, 0)
        case "2":
            cell.template = (0, -131)
        case "3":
            cell.template = (0, -262)
        case "4":
            cell.template = (-131, 0)
        case "5":
            cell.template = (-131, -131)
        case "6":
            cell.template = (-131, -262)
        case "7":
            cell.template = (-262, 0)
        case "8":
            cell.template = (-262, -131)
        case "9":
            cell.template = (-262, -262)
        default:
            break
        }
        
        
        
        
        
        return cell
    }
}

extension PuzzleViewController: UICollectionViewDelegateFlowLayout {
    //TODO: Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = collectionView.bounds.width
        let customCollectionWidth = (collectionViewWidth/3)
        return CGSize(width: customCollectionWidth, height: customCollectionWidth)
    }

    //TODO: Insets
    //this method implements UIEdgeInsets for different size of puzzle
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    //+
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //+
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PuzzleViewController: UICollectionViewDragDelegate {
    //+
    //As you can see, in the ‘itemsForBeginning’ method we are calling our ‘dragItem’ that will deal with the dragItem to be returned. The helper method ‘dragItem’ helps us create the itemProvider with the correct string or image content, depending on the cell we are dragging.
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.puzzle.unSolvedImages[indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = dragItem
        return [dragItem]
    }
}

extension PuzzleViewController: UICollectionViewDropDelegate {
    //+
    //This method tell the DropDelegate that something is happening when the user drags a cell and drops it at a new location.UICollectionViewDropProposal has four types of operation which is copy,forbidden,cancel,move.In this project I have used move operation which is to arrange the puzzles.
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        
        
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    //+
    //Use this method to accept the dropped content and integrate it into your collection view. In your implementation, iterate over the items property of the coordinator object and fetch the data from each UIDragItem.
    
    //Incorporate the data into your collection view's data source and update the collection view itself by inserting any needed items. When incorporating items, use the methods of the coordinator object to animate the transition from the drag item's preview to the corresponding item in your collection view.We have calculating whether or not the cell will be dropped out of bounds.
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
                puzzle.unSolvedImages.swapAt(sourceIndexPath.item, destinationIndexPath.item)
                collectionView.reloadItems(at: [sourceIndexPath, destinationIndexPath])
            }
            //MARK: have a bit .....
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
    }
    //+
    //this method is called every time a item is dropped and checks everytime if puzzle is solved or not.If unsolvedImage array equals to solved image array. Change dragInteractionEnabled to false to tell user that puzzle has solved and show Alert .Enable rightBarbutton to true to navigate to next puzzle.
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        if puzzle.unSolvedImages == puzzle.solvedImages {
            Alert.showSolvedPuzzleAlert(on: self)
            
            collectionView.dragInteractionEnabled = false
        }
    }
}
