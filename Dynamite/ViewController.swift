//
//  ViewController.swift
//  Dynamite
//
//  Created by Jonathan Amato on 4/13/15.
//  Copyright (c) 2015 Jonathan Amato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayTimeLabel: UILabel!
    
    @IBOutlet weak var displayHighScore: UILabel!
    
    @IBOutlet weak var explosionSequence: UIImageView!
    
    var startTime = NSTimeInterval()
    
    var timer:NSTimer = NSTimer()
    
    var imgListArray :NSMutableArray = []
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//                let heightOfView = self.view.frame.height
//                let distanceFromTop = CGFloat(heightOfView * 0.575)
//        
//                let frame = displayTimeLabel.frame
//                displayTimeLabel.frame = CGRect(x: frame.minX, y: distanceFromTop, width: frame.width, height: frame.height)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for countValue in 0...58
        {
            if countValue < 10 {
                var strImageName : String = "0\(countValue).png"
                var image  = UIImage(named:strImageName)
                imgListArray .addObject(image!)
            } else {
                var strImageName : String = "\(countValue).png"
                var image  = UIImage(named:strImageName)
                imgListArray .addObject(image!)
            }
        }
        explosionSequence.animationImages = imgListArray as [AnyObject];
        explosionSequence.animationRepeatCount = 1
        
        //show saved high score as displayHighScore string
        var scoreNew = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        var scoreString = toString(scoreNew)
        var newString = ""
        var newString2 = ""
        var length = count(scoreString)
        
        for i in 1...(8-length) {
            newString = "0" + scoreString
            scoreString = newString
        }
        
        for i in 1...count(newString) {
            if i != 1 {
                if i%2 != 0 {
                    newString2 += ":"
                }
            }
            
            var index = advance(newString.startIndex, i-1)
            newString2 += toString(newString[index])
        }
        
        displayHighScore.text = newString2
        
        //stop timer when closing app helpers
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        //UIApplicationDidEnterBackgroundNotification & UIApplicationWillEnterForegroundNotification shouldn't be quoted
        notificationCenter.addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    
    @IBAction func resetHighScore(sender: AnyObject) {
        
        //alert controller
        let alertController: UIAlertController = UIAlertController(title: "Reset High Score", message: "Are you sure you want to reset your high score?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //don't do anything
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.displayHighScore.text = "00:00:00:00"
            self.displayTimeLabel.text = "00:00:00:00"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func startHold(sender: AnyObject) {
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
    @IBAction func endHold(sender: AnyObject) {
        timer.invalidate()
        
        //animation every end click
        //explosionSequence.startAnimating()
        
        //get time score
        var text1 = displayTimeLabel.text
        
        //remove ":"
        var text2 = text1?.stringByReplacingOccurrencesOfString(":", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        //convert to integer
        var score = text2?.toInt()
        
        NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        
        //Check if score is higher than NSUserDefaults stored value and change NSUserDefaults stored value if it's true
        if score > NSUserDefaults.standardUserDefaults().integerForKey("highscore") {
            NSUserDefaults.standardUserDefaults().setInteger(score!, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            displayHighScore.text = displayTimeLabel.text
            //animation only if highscore
            explosionSequence.startAnimating()
            
        }
        
        NSUserDefaults.standardUserDefaults().integerForKey("highscore")
    }
    
    func updateTime() {
        
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the hours in elapsed time.
        let hours = UInt8(elapsedTime / 3600.0)
        elapsedTime -= (NSTimeInterval(hours) * 3600)
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strHours = hours > 9 ? String(hours):"0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        displayTimeLabel.text = "\(strHours):\(strMinutes):\(strSeconds):\(strFraction)"
        
    }
    
    //stop timer if user leaves app
    func didEnterBackground() {
        timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
