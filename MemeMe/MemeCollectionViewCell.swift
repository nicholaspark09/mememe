//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Nicholas Park on 5/5/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
  
    var meme: Meme?{
        didSet{
            imageView?.image = meme!.memedImage
            imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
}
