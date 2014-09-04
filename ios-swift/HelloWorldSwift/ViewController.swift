/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
                            
    @IBOutlet var tableView : UITableView!
    
    // holds the messages received and displayed on tableview
    var messages: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages = ["Registering...."]
        
        // register to notification center to received notifications upon events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "registered", name: "success_registered", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "errorRegistration", name: "error_register", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageReceived:", name: "message_received", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registered() {
        println("registered")
        
        messages.removeAtIndex(0)
        messages.append("Sucessfully registered")
        
        // workaround to get messages when app was not running
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
        if(defaults.objectForKey("message_received") != nil) {
            let msg : String! = defaults.objectForKey("message_received") as String
            defaults.removeObjectForKey("message_received")
            defaults.synchronize()
    
            if(msg != nil) {
                messages.append(msg)
            }
        }
        
        tableView.reloadData()
    }

    func errorRegistration() {
        messages.removeAtIndex(0)
        messages.append("Error during registration")
        tableView.reloadData()
    }
    
    func messageReceived(notification: NSNotification) {
        println("received")

        let msg = notification.userInfo!["aps"]!["alert"] as String
        messages.append(msg)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell

        cell.textLabel?.text = messages[indexPath.row]
        
        return cell
    }
}

