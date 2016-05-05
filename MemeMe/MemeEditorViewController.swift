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
    func shareMeme()
    func cancelMeme()
}

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    struct Constants{
        static let TopText = "TOP"
        static let BottomText = "BOTTOM"
        static let Title = "New Meme"
    }

    
    let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -1.0
    ]
    var currentMeme:Meme?
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var galleryButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var navigationBar: UINavigationBar!
    var navItem: UINavigationItem?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        setup()
        
        //SET THE NAVBAR ITEMS
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(MemeProtocol.shareMeme))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(MemeProtocol.cancelMeme))
        navigationItem.leftBarButtonItem?.enabled = false
        navigationBar.items = [navigationItem]
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func getImageButtonClicked(sender: UIBarButtonItem) {
        if sender.tag == 0{
            pickAnImage(UIImagePickerControllerSourceType.Camera)
        }else{
            pickAnImage(UIImagePickerControllerSourceType.PhotoLibrary)
        }
    }
    
/*
     ** Redundant Methods
            - Keeping these to remind myself what not to do later
     
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
*/
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
            self.navigationItem.leftBarButtonItem?.enabled = true
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
    
    /*
        Stylistic Setup Arguments
 
     */
    func setup(){
        titleTextField.text = Constants.TopText
        titleTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = Constants.BottomText
        titleTextField.delegate = self
        bottomTextField.delegate = self
        titleTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    /*
            MEME Methods
     */
    
    func shareMeme(){
        let generatedImage = generateMemedImage()
        let objectsToShare = [generatedImage]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if success{
                let meme = Meme(topText: self.titleTextField!.text!, image: self.imagePickerView!.image, bottomText: self.bottomTextField!.text!, memedImage: generatedImage)
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
            }
        }
        presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage{
        
        //HIDE the navigation bar first
        navigationBar.hidden = true
        toolBar.hidden = true
        //Save Shtuff
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        memedImage.drawAtPoint(CGPointMake(0, 50))
        UIGraphicsEndImageContext()
        
        //Show the Navigation Bar again
        navigationBar.hidden = false
        toolBar.hidden = false
        return memedImage
    }
    

    func cancelMeme(){
        /*
        imagePickerView.image = nil
        titleTextField.text = Constants.TopText
        bottomTextField.text = Constants.BottomText
        if titleTextField.isFirstResponder() {
            titleTextField.resignFirstResponder()
        }else if bottomTextField.isFirstResponder(){
            bottomTextField.resignFirstResponder()
        }
        self.navigationItem.leftBarButtonItem?.enabled = false
 */
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}

