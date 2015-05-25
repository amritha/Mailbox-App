
//
//  MailboxViewController.swift
//  Mailbox App
//
//  Created by Amritha Prasad on 5/23/15.
//  Copyright (c) 2015 Amritha Prasad. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIAlertViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var laterIconView: UIImageView!
    @IBOutlet weak var listIconView: UIImageView!
    @IBOutlet weak var archiveIconView: UIImageView!
    @IBOutlet weak var deleteIconView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var composeView: UIView!
    
    //Original Centers
    var messageOriginalCenter : CGPoint!
    var laterOriginalCenter : CGPoint!
    var archiveOriginalCenter : CGPoint!
    var contentOriginalCenter : CGPoint!
    
    //Stores the state of the color based on x coordinate
    var colorState = "gray"
    var originalNavColor : UIColor!
    
    @IBOutlet weak var composeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Scroll View setup
        scrollView.contentSize.height = CGFloat(feedView.image!.size.height + messageView.image!.size.height)
        scrollView.contentSize.width = CGFloat(960)
        scrollView.contentOffset.x = 320
        
        //Setting origins
        messageOriginalCenter = messageView.center
        contentOriginalCenter = contentView.center
        laterOriginalCenter = laterIconView.center
        archiveOriginalCenter = archiveIconView.center
        
        //Pull in that Mailbox blue
        originalNavColor = segmentedControl.tintColor
        
        //Hide list and reschedule views
        listView.alpha = 0
        rescheduleView.alpha = 0
        
        //Hide Compose View
        composeView.alpha = 0
        
        //Declare screen edge pan
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Panning the message function
    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        
        //Declaring pan variables
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        
        //When the pan begins
        if sender.state == UIGestureRecognizerState.Began
        {
            println("Gesture began at: \(point)")
            
            //Set initial icons on left and right to their original centers
            laterIconView.center.x = laterOriginalCenter.x
            archiveIconView.center.x = archiveOriginalCenter.x
        }
         
        //As the pan is changing
        else if sender.state == UIGestureRecognizerState.Changed
        {
            println("Gesture changed at: \(point)")
            //Have message view follow along with finger drag
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            
            //Set Colors for message background and colorState variable
            
            //Later zone
            if messageView.center.x < messageOriginalCenter.x - 60 && messageView.center.x > messageOriginalCenter.x - 240
            {
                messageContainerView.backgroundColor = UIColorFromRGB(0xFECC2F)
                colorState = "yellow"
            }
                
            //Add to List Zone
            else if messageView.center.x < messageOriginalCenter.x - 240
            {
                messageContainerView.backgroundColor = UIColorFromRGB(0xA28672)
                colorState = "brown"
            }
             
            //Archive Zone
            else if messageView.center.x > messageOriginalCenter.x + 60 && messageView.center.x < messageOriginalCenter.x + 240
            {
                messageContainerView.backgroundColor = UIColorFromRGB(0x39CA74)
                colorState = "green"
            }
            
            //Delete Zone
            else if messageView.center.x > messageOriginalCenter.x + 240
            {
                messageContainerView.backgroundColor = UIColorFromRGB(0xE54D42)
                colorState = "red"
            }
                
            //No Action Zone
            else
            {
                messageContainerView.backgroundColor = UIColor.grayColor()
                colorState = "gray"
            }
            
            //Rules Based on Colors
            
            //If in the "No Action Zone" while dragging message
            if colorState == "gray"
            {
                
                //Make sure list and delete icons are invisible
                listIconView.alpha = 0
                deleteIconView.alpha = 0
                
                //Have archive and later icons gradually fade in based on x coordinate
                self.archiveIconView.alpha = (translation.x / 60)
                self.laterIconView.alpha = -(translation.x / 60)
            }
                
            //If in the "Later Zone"
            else if colorState == "yellow"
            {
                //Make sure list icon is invisible and later icon is completely faded in
                self.listIconView.alpha = 0
                self.laterIconView.alpha = 1
                
                //Have the laterIcon trail behind the message view as it drags
                laterIconView.center.x = messageView.center.x + 190
            }
            
            //If in the "List Zone"
            else if colorState == "brown"
            {
                //Later icon should disappear and listIcon should start trailing behind message
                laterIconView.alpha = 0
                listIconView.center.x = messageView.center.x + 190
                
                //Fade in listIcon
                UIView.animateWithDuration(0.2, animations: {
                    self.listIconView.alpha = 1
                })
            }
                
            //If in the "Archive Zone"
            else if colorState == "green"
            {
                //Let's make sure only the archive Icon is completely visible at this time
                deleteIconView.alpha = 0
                archiveIconView.alpha = 1
                laterIconView.alpha = 0
                listIconView.alpha = 0
                
                //Archive icon should start trailing behind message
                archiveIconView.center.x = messageView.center.x - 190
            }
            
            //If in the "Delete Zone"
            else if colorState == "red"
            {
                //Archive icon should disappear and delete should start trailing behind message
                archiveIconView.alpha = 0
                deleteIconView.center.x = messageView.center.x - 190
                
                //Fade in deleteIcon
                UIView.animateWithDuration(0.2, animations: {
                    self.deleteIconView.alpha = 1
                })
            }
        }
            
        //When the pan ends
        else if sender.state == UIGestureRecognizerState.Ended{
            println("Gesture ended at: \(point)")
            
            //If in the "No Action Zone"
            if colorState == "gray"
            {
                //Animate message back to original location
                UIView.animateWithDuration(0.2, animations: {
                    self.messageView.center = self.messageOriginalCenter
                })
            }
                
            //If in the "Archive Zone"
            else if colorState == "green"{
                //Get rid of the message and move it to archived section
                dismissMessage()
            }
            
            //If in the "Delete Zone"
            else if colorState == "red"{
                //Get rid of the message and hide it
                dismissMessage()
                messageView.hidden = true
            }
                
            //If in the "Later Zone"
            else if colorState == "yellow"
            {
                //Fade in the reschedule view
                UIView.animateWithDuration(0.2, animations: {self.rescheduleView.alpha = 1})
            }
            
            //If in the "List Zone"
            else if colorState == "brown"
            {
                //Fade in the list view
                UIView.animateWithDuration(0.2, animations: {self.listView.alpha = 1})
            }
        }
    }
    
    //Screen edge pan gesture
    @IBAction func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        
        //Declaring pan variables
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        
        
        println("hi, I worked")
        
        //While dragging main view
        if sender.state == UIGestureRecognizerState.Changed
        {
            //Main view should drag with finger
            self.contentView.center = CGPoint(x: contentOriginalCenter.x + translation.x, y: contentOriginalCenter.y)
        }
            
        //When pan ends
        else if sender.state == UIGestureRecognizerState.Ended
        {
            //If dragging in the right direction
            if (velocity.x > 1)
            {
                //Transition to Open menu
                UIView.animateWithDuration(0.4, animations: {
                    self.contentView.center.x = 440
                })
            }
            //If dragging in the left direction
            else
            {
                //Transition to Close menu
                UIView.animateWithDuration(0.4, animations: {
                    self.contentView.center.x = self.contentOriginalCenter.x
                    
                })
            }
        }
    }
    
    //Tapping Menu button
    @IBAction func onPressMenu(sender: AnyObject)
    {
        //If the menu is open, close it
        if (contentView.center.x == 440)
        {
            UIView.animateWithDuration(0.4, animations: {
                self.contentView.center.x = self.contentOriginalCenter.x
                
            })
        }
            
        //If the menu is closed, open it
        else
        {
            UIView.animateWithDuration(0.4, animations: {
                self.contentView.center.x = 440
            })
        }
        
    }
    
    //Tapping Reschedule View
    @IBAction func onRescheduleTap(sender: UITapGestureRecognizer)
    {
        //Fade out reschedule view and move message back to its original position
        UIView.animateWithDuration(0.2, animations: {
            self.rescheduleView.alpha = 0
            self.messageView.center = self.messageOriginalCenter
        })
    }
    
    //Tapping List View
    @IBAction func onListTap(sender: UITapGestureRecognizer)
    {
        //Fade out list view and move message back to its original position
        UIView.animateWithDuration(0.2, animations: {
            self.listView.alpha = 0
            self.messageView.center = self.messageOriginalCenter
        })
    }
    
    //A function to dismiss the message and move it to archived view
    func dismissMessage(){
        
        //Have archive and delete icons follow message off the screen and move the feed view up replace original message
        UIView.animateWithDuration(0.4, animations: {
            self.messageView.center.x = self.messageOriginalCenter.x + 320
            self.archiveIconView.center.x = self.archiveIconView.center.x + 320
            self.deleteIconView.center.x = self.deleteIconView.center.x + 320
            self.feedView.frame = CGRect(x: 320, y: 0, width: 320, height: 1202)
        })
    }
    
    //A function to undismiss the message and move it back to the main view
    func undismissMessage(){
        //Make sure the messageView is now visible (in case you deleted)
        messageView.hidden = false
        
        //Move message view back to its original senter along with archive and delete icon, move feed view down to make space
        UIView.animateWithDuration(0.4, animations: {
            self.messageView.center.x = self.messageOriginalCenter.x
            self.archiveIconView.center.x = self.archiveOriginalCenter.x
            self.deleteIconView.center.x = self.archiveOriginalCenter.x
            self.feedView.frame = CGRect(x: 320, y: 87, width: 320, height: 1202)
        })
    }
    
    //A reset button that undsimisses messagefor my own testing purposes
    @IBAction func onPressUndismiss(sender: AnyObject) {
        messageView.hidden = false
        UIView.animateWithDuration(0.4, animations: {
            self.messageView.center.x = self.messageOriginalCenter.x
            self.archiveIconView.center.x = self.archiveOriginalCenter.x
            self.deleteIconView.center.x = self.archiveOriginalCenter.x
            self.feedView.frame = CGRect(x: 320, y: 87, width: 320, height: 1202)
        })
    }
    
    //When the segment controller is changed
    @IBAction func onChangeSegment(sender: AnyObject) {
        
        //If later icon in nav is tapped
        if segmentedControl.selectedSegmentIndex == 0
        {
            //Scroll in later view and fade color of nav items to yellow
            UIView.animateWithDuration(0.4, animations: {
                self.scrollView.contentOffset.x = 0
                self.segmentedControl.tintColor = self.UIColorFromRGB(0xFECC2F)
            })
        }
            
        //If main mailbox in nav is tapped
        else if segmentedControl.selectedSegmentIndex == 1
        {
            //Scroll in main view and fade color of nav items to mailbox blue
            UIView.animateWithDuration(0.4, animations: {self.scrollView.contentOffset.x = 320
                self.segmentedControl.tintColor = self.originalNavColor})
        }
            
        //If archive icon in nav is tapped
        else if segmentedControl.selectedSegmentIndex == 2
        {
            //Scroll in archive view and fade color of nav items to green
            UIView.animateWithDuration(0.4, animations: {self.scrollView.contentOffset.x = 640
                self.segmentedControl.tintColor = self.UIColorFromRGB(0x39CA74)})
        }
    }
    
    //A function to convert to UIColor from RGB
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //On pressing the compose button
    @IBAction func onPressCompose(sender: AnyObject) {
        
        //Fade in the compose view and slide it up
        UIView.animateWithDuration(0.4, animations: {
            self.composeView.alpha = 1
            self.composeView.frame = CGRect(x: 0, y: 0, width: 320, height: 568)
            
        })
        
        //After a slight delay bring up the keyboard
        delay(0.3){
            self.composeField.becomeFirstResponder()
        }
    }
    
    //On pressing cancel button in the compose window
    @IBAction func onPressCancel(sender: AnyObject) {
        
        //Fade out the compose view and slide it down
        UIView.animateWithDuration(0.4, animations: {
            self.composeView.alpha = 0
            self.composeView.frame = CGRect(x: 0, y: 568, width: 320, height: 568)})
        self.view.endEditing(true)
    }
    
    //Function for the shake gesture
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent)
    {
        if(event.subtype == UIEventSubtype.MotionShake)
        {
            //If the user has archived or deleted a message, bring up this alert
            if (self.feedView.frame == CGRect(x: 320, y: 0, width: 320, height: 1202))
            {
                //Alert declaration
                var alert = UIAlertController(title: "Undo last action?", message: "Are you sure you want to undo and move 1 item from Archive back into inbox?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Undo", style: UIAlertActionStyle.Default, handler: {(alertAction) -> Void in
                    self.undismissMessage()
                }))
                //Show alert
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

}
