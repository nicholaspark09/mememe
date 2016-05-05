//
//  PreviewViewController.swift
//  MemeMe
//
//  Created by Nicholas Park on 5/5/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    var meme: Meme?
    
    @IBOutlet var memeImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Preview / Share"
        
        if meme != nil{
            memeImageView.image = meme?.memedImage
            memeImageView.contentMode = UIViewContentMode.ScaleAspectFit
        }else{
            print("You don't have a meme...wtf")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareClicked(sender: UIButton) {
        
        let objectsToShare = [meme!.memedImage!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityTypeCopyToPasteboard,UIActivityTypeAirDrop,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypePostToWeibo]
        self.presentViewController(activityVC, animated: true, completion: nil)
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
