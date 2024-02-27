//
//  PuzzleViewController.swift
//  PuzzleGame
//
//  Created by Serginjo Melnik on 22/02/24.
//

import UIKit



class PuzzleViewController: UIViewController{
    
    let cellId = "cellId"
    //shows when 
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.transform = CGAffineTransform(scaleX: 1, y: 1)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()
    
    let moveMessageText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Position is OK!"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.backgroundColor = .systemYellow
        label.alpha = 0
        label.textColor = .black
        return label
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
        collectionView.isScrollEnabled = false
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
        //try to fetch image from server
        PhotoApi.GetPhoto().fetchImage { [weak self] outcome in
            
            guard let strongSelf = self else { return }
            
            switch outcome {
            //success case where server returns image
            case .success(let image):
                strongSelf.puzzleImage = image
            //case where fetch service fails to get image
            case .failure(let error):
                if let responseError = error as? ServiceError {
                    print("Failed with ServiceErrorType: \(responseError)")
                }
                //set puzzle image to default asset
                strongSelf.puzzleImage = UIImage(named: "nature")
            }
            //hide activity indicator and show collection view
            strongSelf.screenElements(shouldShow: true)
            //update collection view with new image
            strongSelf.puzzleCollectionView.reloadData()
        }
    }
    //show/hides indicator & collectionView
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
    //shows message for correct tile
    func showInfoMessage(){
        self.moveMessageText.alpha = 1
        
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 0) {
            self.moveMessageText.alpha = 0
        }
    }
    //configure page elements
    private func configureScreenElements(){
        
        navigationItem.title = "Completed: %"
        view.backgroundColor = .white
        
        view.addSubview(activityIndicator)
        view.addSubview(puzzleCollectionView)
        view.addSubview(dismissButton)
        view.addSubview(moveMessageText)
        
        
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
        
        moveMessageText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        moveMessageText.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 20).isActive = true
        moveMessageText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        moveMessageText.widthAnchor.constraint(equalToConstant: 206).isActive = true
    }
}

extension PuzzleViewController: UICollectionViewDataSource {
    //tile count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return puzzle.unOredredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TileCell
        //set single image for every cell
        if let image = puzzleImage { cell.imageView.image = image }
        //get current value from unordered items
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
        
            let edgeSize = width <= height ? width / 3 : height / 3 
            
            return CGSize(width: edgeSize, height: edgeSize)
    }

    //Insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    //min line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //min interitem spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension PuzzleViewController: UICollectionViewDragDelegate {
    
    //provides the initial set of items (if any) to drag
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.puzzle.unOredredItems[indexPath.item]
        
        
        //if tile in the correct position
        if checkForCorrectPosition(index: indexPath.item){
            //show info message to user
            self.showInfoMessage()
            //prevents from dragging a solved tile
            return [UIDragItem]()
        }
        
        //create provider with current item value
        let itemProvider = NSItemProvider(object: String(item) as NSString)
        //A representation of an underlying data item being dragged from one location to another.
        let dragItem = UIDragItem(itemProvider: itemProvider)
        // associate a custom object with the drag item.
        dragItem.localObject = dragItem
        return [dragItem]
    }
    //compare current item to correct item inside puzzle object
    func checkForCorrectPosition(index: Int) -> Bool {
        let orderedItems = self.puzzle.orderedItems
        let unOrderedItems = self.puzzle.unOredredItems
        return orderedItems[index] == unOrderedItems[index]
    }
    
    //swap items inside puzzle object and collection view
    fileprivate func handleReorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath{
            collectionView.performBatchUpdates {
                //perform swapping inside puzzle object
                puzzle.unOredredItems.swapAt(sourceIndexPath.item, destinationIndexPath.item)
                //perform swapping inside collectionView
                collectionView.reloadItems(at: [sourceIndexPath, destinationIndexPath])
            }
            //dropping item
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
    }
}

extension PuzzleViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if let destinationItem = destinationIndexPath{
            //check if destination tile is in correct position
            if checkForCorrectPosition(index: destinationItem.item) {
                //block this position for dropping current tile
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        }
        //indicates whether items were lifted and have not yet been dropped.
        if collectionView.hasActiveDrag {
            //drop item
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        //cancel
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    
    //confirm droping item and insert into collection view
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        //get IndexPath from coordinator
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        }else{
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            //swap tile, update puzzle object
            self.handleReorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            self.puzzleCollectionView.reloadData()
        }
    }
    //end of drop session
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        //in the end of every drop session checks if puzzle is solved
        if puzzle.unOredredItems == puzzle.orderedItems {
            //if solved, shows congrats
            self.showCongratsAlert()
            //disable any dragg interaction
            collectionView.dragInteractionEnabled = false
        }
    }
}
