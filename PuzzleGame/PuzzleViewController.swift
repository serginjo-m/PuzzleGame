//
//  PuzzleViewController.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 22/02/24.
//

import UIKit

class PuzzleViewController: UIViewController{
    
    let cellId = "cellId"
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    let puzzleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func setupPuzzleCollectionView(){
        puzzleCollectionView.dragInteractionEnabled = true
        puzzleCollectionView.dragDelegate = self
        puzzleCollectionView.dropDelegate = self
        puzzleCollectionView.dataSource = self
        puzzleCollectionView.delegate = self
        puzzleCollectionView.showsVerticalScrollIndicator = false
        puzzleCollectionView.showsHorizontalScrollIndicator = false
        puzzleCollectionView.register(PuzzleCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    var puzzle = Puzzle(title: "StreetFighter", solvedImages: ["1", "2", "3", "4", "5", "6", "7", "8", "9"])
    
    var puzzleImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreenElements()
        screenElements(shouldShow: false)
        setupPuzzleCollectionView()
        getPuzzlePhoto()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        puzzleCollectionView.reloadData()
    }
    
    private func configureScreenElements(){
        
        navigationItem.title = "Completed: %"
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        view.addSubview(puzzleCollectionView)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        puzzleCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        puzzleCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        puzzleCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        puzzleCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    func screenElements(shouldShow: Bool){
        if shouldShow {
            self.activityIndicator.stopAnimating()
        }
        self.puzzleCollectionView.isHidden = !shouldShow
    }
}

extension PuzzleViewController: PhotoLoaderServiceProtocol {
    //TODO: The problem - this func is not really testable?!
    func getPuzzlePhoto(){
        //TODO: Remember to include [weak self] -> because this call is async
        PhotoLoader.shared.fetchImage(from: "https://picsum.photos/1024") { [weak self] imageData in
            if let data = imageData {
                // referenced imageView from main thread
                // as iOS SDK warns not to use images from
                // a background thread
                //MARK: should implement solution where user gon't wait more than 3 seconds
                /*
                 
                 DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    completion()
                 }
                 */
                DispatchQueue.main.async {
                    self?.puzzleImage = UIImage(data: data)
                    self?.screenElements(shouldShow: true)
                    self?.puzzleCollectionView.reloadData()
                }
            } else {
                self?.puzzleImage = UIImage(named: "nature")
            }
        }
    }
}

extension PuzzleViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return puzzle.unSolvedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PuzzleCell
        
        if let image = puzzleImage {
            cell.imageView.image = image
        }
        
        let puzzleWidth = self.puzzleCollectionView.frame.width
        let puzzleHeight = self.puzzleCollectionView.frame.height
        let thirdWidth = -puzzleWidth * 0.33
        let twoThirdsWidth = -puzzleWidth * 0.66
        let thirdHeight = -puzzleHeight * 0.33
        let twoThirdsHeight = -puzzleHeight * 0.66
        
        //TODO: New solution should be scaleble, keep that in mind!
        switch puzzle.unSolvedImages[indexPath.item] {
            
        case "1":
            cell.template = (0, 0)
        case "2":
            cell.template = (0, thirdWidth)//TODO: That's not the perfect pixel solution
        case "3":
            cell.template = (0, twoThirdsWidth)
        case "4":
            cell.template = (thirdHeight, 0)
        case "5":
            cell.template = (thirdHeight, thirdWidth)
        case "6":
            cell.template = (thirdHeight, twoThirdsWidth)
        case "7":
            cell.template = (twoThirdsHeight, 0)
        case "8":
            cell.template = (twoThirdsHeight, thirdWidth)
        case "9":
            cell.template = (twoThirdsHeight, twoThirdsWidth)
        default:
            break
        }
        
        
        
        return cell
    }
}

extension PuzzleViewController: UICollectionViewDelegateFlowLayout {
    //TODO: Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewHeight = collectionView.bounds.height/3//TODO: Not a perfect pixel size
            let collectionViewWidth = collectionView.bounds.width/3
            return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }

    //TODO: Insets
    //this method implements UIEdgeInsets for different size of puzzle
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PuzzleViewController: UICollectionViewDragDelegate {
    
    //As you can see, in the ‘itemsForBeginning’ method we are calling our ‘dragItem’ that will deal with the dragItem to be returned. The helper method ‘dragItem’ helps us create the itemProvider with the correct string or image content, depending on the cell we are dragging.
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        //TODO: Seems like it has an isssue but I don't realy know how to imaplement it
        let item = self.puzzle.unSolvedImages[indexPath.item]
        let solvedItem = self.puzzle.solvedImages[indexPath.item]
        
        //this prevents from dragging a solved cell
        if item == solvedItem {
            return [UIDragItem]()
        }
        
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = dragItem
        return [dragItem]
    }
}

extension PuzzleViewController: UICollectionViewDropDelegate {
    /*
        This method tell the DropDelegate that something is happening when the user drags a cell and drops it at a new location.
        UICollectionViewDropProposal has four types of operation which is copy,forbidden,cancel,move.In this project I have used move operation which is to arrange the puzzles.
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if let destinationItem = destinationIndexPath{
            
            let item = self.puzzle.unSolvedImages[destinationItem.item]
            let solvedItem = self.puzzle.solvedImages[destinationItem.item]
            
            if item == solvedItem {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        }
        
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    /*  Use this method to accept the dropped content and integrate it into your collection view.
        In your implementation, iterate over the items property of the coordinator object and fetch the data from each UIDragItem.
        Incorporate the data into your collection view's data source and update the collection view itself by inserting any needed items.
        When incorporating items, use the methods of the coordinator object to animate the transition from the drag item's preview to the corresponding item in your collection view.We have calculating whether or not the cell will be dropped out of bounds.
     */
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
            self.puzzleCollectionView.reloadData()
        }
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath{
            collectionView.performBatchUpdates {
                puzzle.unSolvedImages.swapAt(sourceIndexPath.item, destinationIndexPath.item)
                collectionView.reloadItems(at: [sourceIndexPath, destinationIndexPath])
            }
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
    }
    
    //this method is called every time a item is dropped and checks everytime if puzzle is solved or not.If unsolvedImage array equals to solved image array. Change dragInteractionEnabled to false to tell user that puzzle has solved and show Alert .Enable rightBarbutton to true to navigate to next puzzle.
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        if puzzle.unSolvedImages == puzzle.solvedImages {
            Alert.showSolvedPuzzleAlert(on: self)
            collectionView.dragInteractionEnabled = false
        }
    }
}
