//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Nicholas Park on 5/5/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    
    /**
        Not really necessary, but just in case this needs to be expanded
    **/
    struct Constants{
        static let Title = "Meme"
    }
    
    @IBOutlet var memeImageView: UIImageView!
    var meme:Meme?{
        didSet{
            print("You received the meme")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Constants.Title
        if meme != nil{
            memeImageView.image = meme!.memedImage
            memeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
