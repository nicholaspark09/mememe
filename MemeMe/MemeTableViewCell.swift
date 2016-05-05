//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Nicholas Park on 5/5/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    var meme:Meme?{
        didSet{
            /*
            imageView?.image = meme!.memedImage
            imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            imageView?.layer.masksToBounds = true
            */
            resizeImage()
            topTextView?.text = meme!.topText
            bottomTextView?.text = meme!.bottomText
        }
    }
    
    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var bottomTextView: UILabel!
    @IBOutlet var topTextView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resizeImage(){
        let size = CGSizeMake(160, 120)
        let image = meme!.memedImage!
        let scale = CGFloat(max(size.width/image.size.width,size.height/image.size.height))
        let width:CGFloat = image.size.width * scale
        let height:CGFloat = image.size.height * scale
        let rr:CGRect = CGRectMake( 0, 0, width, height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        meme!.memedImage!.drawInRect(rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        memeImageView?.image = newImage
    }

}
