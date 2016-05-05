//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Nicholas Park on 5/5/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

@objc protocol MemesTableProtocol{
    func addMeme()
}

class MemesTableViewController: UITableViewController {

    struct Constants{
        static let CellReuseIdentifier = "MemeTable Cell"
        static let MemeEditorSegue = "MemeEditor Segue"
        static let MemeDetailSegue = "MemeDetail Segue"
    }
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(MemesTableProtocol.addMeme))
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellReuseIdentifier, forIndexPath: indexPath) as! MemeTableViewCell
        cell.meme = memes[indexPath.row]
        return cell
    }
    
    func addMeme(){
        performSegueWithIdentifier(Constants.MemeEditorSegue, sender: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let index = indexPath.row
            //Delete the meme in the app delegate
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(index)
            //Delete the meme in the local copy of the memes array
            memes.removeAtIndex(index)
            //and Bazinga
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.MemeDetailSegue {
            if let mdvc = segue.destinationViewController as? MemeDetailViewController{
                mdvc.meme = memes[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    

}
