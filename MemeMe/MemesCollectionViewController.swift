//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Nicholas Park on 5/5/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

@objc protocol MemesCollectionProtocol{
    func addMeme()
}

class MemesCollectionViewController: UICollectionViewController {

    
    struct Constants{
        static let CellReuseIdentifier = "MemeCollection Cell"
        static let MemeEditorSegue = "MemeEditor Segue"
        static let MemeDetailSegue = "MemeDetail Segue"
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes = [Meme]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let space: CGFloat = 3.0
        //x dimension
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        //y dimension
        let yDimension = (self.view.frame.size.height - (2*space))/3.0
        
        //Set spacing between cells
        flowLayout.minimumInteritemSpacing = space
        //Set spacing between rows
        flowLayout.minimumLineSpacing = space
        //Set item size
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(MemesCollectionProtocol.addMeme))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.MemeDetailSegue{
            if let mdvc = segue.destinationViewController as? MemeDetailViewController{
                let i = collectionView!.indexPathsForVisibleItems()[0].row
                let meme = memes[i]
                print("The meme title is \(meme.topText)")
                mdvc.meme = meme
            }
            
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
    
        cell.meme = memes[indexPath.row]
        
        return cell
    }
    
    func addMeme(){
        performSegueWithIdentifier(Constants.MemeEditorSegue, sender: nil)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
