//
//  ViewController.swift
//  MemeMe
//
//  Created by Nicholas Park on 5/3/16.
//  Copyright © 2016 Nicholas Park. All rights reserved.
//

import UIKit

@objc protocol MemeProtocol{
    func keyboardWillShow(sender: NSNotification)
    func keybaordWillHide(sender: NSNotification)
    func uploadMeme()
    func cancelMeme()
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    struct Constants{
        static let TopText = "TOP"
        static let BottomText = "BOTTOM"
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1.0
    ]
    
    var currentMeme:Meme?{
        didSet{
            print("The meme was saved")
        }
    }
    
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        setup()
        
        //SET THE NAVBAR ITEMS  
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(MemeProtocol.uploadMeme))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(MemeProtocol.cancelMeme))
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
        }
    }
    
    
    /*
        KEYBOARD shtuff
    */
    
    func keyboardWillShow(sender: NSNotification){
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(sender)
        }
    }
    
    func keybaordWillHide(sender: NSNotification){
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(sender)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // MARK: TextField Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    // MARK: Notification Methods
    //Add an observer for the keyboard both on attachment and detachment
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeProtocol.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeProtocol.keybaordWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func setup(){
        titleTextField.text = Constants.TopText
        titleTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = Constants.BottomText
        titleTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    /*
            MEME Methods
                Please don't be meme...
     */
    
    func saveMeme(){
        currentMeme = Meme(topText: titleTextField.text!, image: imagePickerView.image, bottomText: bottomTextField.text!, memedImage: generateMemedImage())
        
    }
    
    func generateMemedImage() -> UIImage{
        
        //HIDE the navigation bar first
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //Show the Navigation Bar again
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        return memedImage
    }
    
    func uploadMeme(){
        saveMeme()
        
    }
    
    func cancelMeme(){
        imagePickerView.image = nil
        titleTextField.text = Constants.TopText
        bottomTextField.text = Constants.BottomText
        if titleTextField.isFirstResponder() {
            titleTextField.resignFirstResponder()
        }else if bottomTextField.isFirstResponder(){
            bottomTextField.resignFirstResponder()
        }
    }
}

