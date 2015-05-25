//
//  MailboxViewController.swift
//  Mailbox App
//
//  Created by Amritha Prasad on 5/23/15.
//  Copyright (c) 2015 Amritha Prasad. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
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
    
    var messageOriginalCenter : CGPoint!
    var laterOriginalCenter : CGPoint!
    var contentOriginalCenter : CGPoint!
    var colorState = "gray"

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize.height = CGFloat(feedView.image!.size.height + messageView.image!.size.height)
        
        messageOriginalCenter = messageView.center
        contentOriginalCenter = contentView.center
        // Do any additional setup after loading the view.
        
        
        listView.alpha = 0
        rescheduleView.alpha = 0
        
        //Declare screen edge pan
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        
        
        if sender.state == UIGestureRecognizerState.Began {
            println("Gesture began at: \(point)")
            //messageContainerView.backgroundColor = UIColor.grayColor()
            /*laterIconView.alpha = 0.5
            archiveIconView.alpha = 0.5*/
            
            
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            println("Gesture changed at: \(point)")
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            
            //Set Colors
            if messageView.center.x < messageOriginalCenter.x - 60 && messageView.center.x > messageOriginalCenter.x - 240 {
            messageContainerView.backgroundColor = UIColor.yellowColor()
            colorState = "yellow"
            }
            else if messageView.center.x < messageOriginalCenter.x - 240{
            messageContainerView.backgroundColor = UIColor.brownColor()
            colorState = "brown"
            }
            else if messageView.center.x > messageOriginalCenter.x + 60 && messageView.center.x < messageOriginalCenter.x + 240{
            messageContainerView.backgroundColor = UIColor.greenColor()
            colorState = "green"
            }
            else if messageView.center.x > messageOriginalCenter.x + 240{
            messageContainerView.backgroundColor = UIColor.redColor()
            colorState = "red"
            }
            else
            {
            messageContainerView.backgroundColor = UIColor.grayColor()
            colorState = "gray"
            }
            
            //Rules Based on Colors
            if colorState == "gray"
            {
                
                listIconView.alpha = 0
                deleteIconView.alpha = 0
                
                self.archiveIconView.alpha = (translation.x / 60)
                self.laterIconView.alpha = -(translation.x / 60)
                
                
            }
            else if colorState == "yellow"

            {
                self.listIconView.alpha = 0
                self.laterIconView.alpha = 1
            
            laterIconView.center.x = messageView.center.x + 190
            }
            
            else if colorState == "brown"
            {
            listIconView.center.x = messageView.center.x + 190
                laterIconView.alpha = 0
                UIView.animateWithDuration(0.2, animations: {
                
                self.listIconView.alpha = 1
                })
                
            }
            
            else if colorState == "green"
            {
            deleteIconView.alpha = 0
            archiveIconView.alpha = 1
            laterIconView.alpha = 0
            listIconView.alpha = 0
                
            archiveIconView.center.x = messageView.center.x - 190
            }
            
            else if colorState == "red"
            {
            archiveIconView.alpha = 0
                deleteIconView.center.x = messageView.center.x - 190
                UIView.animateWithDuration(0.2, animations: {
                self.deleteIconView.alpha = 1
                })
            }
            
            
        }
        else if sender.state == UIGestureRecognizerState.Ended{
        println("Gesture ended at: \(point)")
            if colorState == "gray"
            {
                
                UIView.animateWithDuration(0.2, animations: {
                    self.messageView.center = self.messageOriginalCenter
                })
                
                
                
            }
            else if colorState == "green"{
            
            dismissMessage()
                
            }
            
            else if colorState == "red"{
            
            dismissMessage()
            }
            
            else if colorState == "yellow"
            {
                UIView.animateWithDuration(0.2, animations: {self.rescheduleView.alpha = 1})
            }
            
            else if colorState == "brown"
            {
            UIView.animateWithDuration(0.2, animations: {self.listView.alpha = 1})
            }
            
            
            
            
            /*else if colorState =="yellow"
            {
            
            
            
            }*/
            
            

        }


        
    }
    
    @IBAction func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        
        println("hi, I worked")
        
        if sender.state == UIGestureRecognizerState.Changed
        {
            self.contentView.center = CGPoint(x: contentOriginalCenter.x + translation.x, y: contentOriginalCenter.y)
            
            
        }
        
        else if sender.state == UIGestureRecognizerState.Ended{
        
            if (contentView.center.x > contentOriginalCenter.x)
            {
                UIView.animateWithDuration(0.4, animations: {
                self.contentView.center.x = 440
                })
            }
        }
    }
    
    @IBAction func onRescheduleTap(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: {
            self.rescheduleView.alpha = 0
            self.messageView.center = self.messageOriginalCenter
        })

        
    }


    @IBAction func onListTap(sender: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.2, animations: {
        self.listView.alpha = 0
            self.messageView.center = self.messageOriginalCenter
        })
    }
    
    
    
    func dismissMessage(){
        UIView.animateWithDuration(0.4, animations: {self.messageView.center.x = self.messageOriginalCenter.x + 400
            self.archiveIconView.center.x = self.messageView.center.x - 190
            self.deleteIconView.center.x = self.messageView.center.x - 190
            self.feedView.frame = CGRect(x: 0, y: 0, width: 320, height: 1202)
        })
    
        
    }
    @IBAction func onPressUndismiss(sender: AnyObject) {
        UIView.animateWithDuration(0.4, animations: {
        
        self.messageView.center.x = self.messageOriginalCenter.x
            self.archiveIconView.center.x = self.messageView.center.x - 190
            self.deleteIconView.center.x = self.messageView.center.x - 190
            self.feedView.frame = CGRect(x: 0, y: 87, width: 320, height: 1202)
        })
        
    }
    
}
