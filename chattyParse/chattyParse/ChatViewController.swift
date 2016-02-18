//
//  ChatViewController.swift
//  chattyParse
//
//  Created by Jennifer Lee on 2/17/16.
//  Copyright © 2016 Jennifer Lee. All rights reserved.
//

//import Cocoa
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var chatTableView: UITableView!

    @IBOutlet weak var messageTextField: UITextField!
    
    var chats: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        chatTableView.estimatedRowHeight = 100
        chatTableView.rowHeight = UITableViewAutomaticDimension
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "loadChats", userInfo: nil, repeats: true)
    }
    
    func loadChats() {

        let query = PFQuery(className: "Message_iOSFeb2016")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                self.chats = objects!.sort{
                    (left: PFObject, right: PFObject) -> Bool in
                    return left.createdAt?.compare(right.createdAt!).rawValue == 1
                }
            } else {
                NSLog("\(error)")
            }
        }
        
        chatTableView.reloadData()
    }
    
    @IBAction func onSend(sender: AnyObject) {
        let message = PFObject(className: "Message_iOSFeb2016")
        message["text"] = messageTextField.text
        message["user"] = PFUser.currentUser()
        messageTextField.text = ""
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if success {
                NSLog("success")
            } else {
                NSLog("error")
                
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ChatCell = tableView.dequeueReusableCellWithIdentifier("chatCell")! as! ChatCell
        cell.messageLabel.text = chats[indexPath.row]["text"] as? String
        
        if chats[indexPath.row]["user"] != nil {
            let user = chats[indexPath.row]["user"] as? PFUser
            cell.emailLabel.text = user?.username
            
        } else {
            cell.emailLabel.hidden = true
        }
        
        return cell
    }
}
