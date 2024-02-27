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
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .link
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return button
    }()
    
    let puzzleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
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
        puzzleCollectionView.register(TileCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    var puzzle = Puzzle()
    
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
}

extension PuzzleViewController {
    
    func getPuzzlePhoto(){
        
        PhotoApi.GetPhoto().fetchImage { [weak self] outcome in
            
            guard let strongSelf = self else { return }
            
            switch outcome {
                
            case .success(let image):
                strongSelf.puzzleImage = image
            case .failure(let error):
                if let responseError = error as? ServiceError {
                    //TODO: not the best but ....
                    print("Failed with ServiceErrorType: \(responseError)")
                }
                strongSelf.puzzleImage = UIImage(named: "nature")
            }
            
            strongSelf.screenElements(shouldShow: true)
            strongSelf.puzzleCollectionView.reloadData()
        }
    }
    
    func screenElements(shouldShow: Bool){
        if shouldShow {
            self.activityIndicator.stopAnimating()
        }
        self.puzzleCollectionView.isHidden = !shouldShow
    }
    
    @objc func dismissViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //An alert window with message
    private func showCongratsAlert() {
        let alertController = UIAlertController(title: "Congratulations!", message: "You have solved this puzzle", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "okay", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
    
    private func configureScreenElements(){
        
        navigationItem.title = "Completed: %"
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        view.addSubview(puzzleCollectionView)
        view.addSubview(dismissButton)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let height = view.frame.height <= view.frame.width ? view.frame.height : view.frame.width
        puzzleCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        puzzleCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        puzzleCollectionView.widthAnchor.constraint(equalToConstant: height).isActive = true
        puzzleCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 7).isActive = true
        dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

extension PuzzleViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return puzzle.unOredredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TileCell
        
        if let image = puzzleImage { cell.imageView.image = image }
        
        let index = puzzle.unOredredItems[indexPath.item]
        
        cell.tileViewModel = TileViewModel(width: puzzleCollectionView.frame.width,
                                      height: puzzleCollectionView.frame.height,
                                      index: index)
        return cell
    }
}

extension PuzzleViewController: UICollectionViewDelegateFlowLayout {
    //Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let height = collectionView.frame.height
            let width = collectionView.frame.width
        
            let edgeSize = width <= height ? width / 3 : height / 3 //TODO: NOt pixel perfect solution
            
            return CGSize(width: edgeSize, height: edgeSize)
    }

    //Insets
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
        
        
        let item = self.puzzle.unOredredItems[indexPath.item]
        let solvedItem = self.puzzle.orderedItems[indexPath.item]
        //TODO: fix blocked && untouched cells
        //this prevents from dragging a solved cell
        if item == solvedItem {
            return [UIDragItem]()
        }
        
        
        //TODO: want to be sure this convertion doesn't slow down all movements
        //NSItemProviderWriting
        let itemProvider = NSItemProvider(object: String(item) as NSString)
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
            
            let item = self.puzzle.unOredredItems[destinationItem.item]
            let solvedItem = self.puzzle.orderedItems[destinationItem.item]
            
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
                puzzle.unOredredItems.swapAt(sourceIndexPath.item, destinationIndexPath.item)
                collectionView.reloadItems(at: [sourceIndexPath, destinationIndexPath])
            }
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
    }
    
    //this method is called every time a item is dropped and checks everytime if puzzle is solved or not.If unsolvedImage array equals to solved image array. Change dragInteractionEnabled to false to tell user that puzzle has solved and show Alert .Enable rightBarbutton to true to navigate to next puzzle.
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        if puzzle.unOredredItems == puzzle.orderedItems {
            self.showCongratsAlert()
            collectionView.dragInteractionEnabled = false
        }
    }
}
