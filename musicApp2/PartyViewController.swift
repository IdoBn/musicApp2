//
//  PartyViewController.swift
//  musicApp2
//
//  Created by Ido Ben-Natan on 12/9/14.
//  Copyright (c) 2014 Ido Ben-Natan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PartyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioSessionDelegate, PTPusherDelegate {

    var requests: [Request] = []
    var request: Request?
    var party: Party?
    let managerT = AFHTTPRequestOperationManager()
    let managerJ = AFHTTPRequestOperationManager()
    var playerController: AVPlayerViewController!
    var moviePlayer: AVPlayer!
    var user : NSDictionary?
    var audioSession: AVAudioSession!
    var pusherClient = PTPusher()//PTPusher.pusherWithKey("27aa526da1424bb735a4", delegate: self, encrypted: false)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        println("party view controller \(self.party)")
        self.title = self.party!.name as NSString
        
        pusherClient = PTPusher.pusherWithKey("27aa526da1424bb735a4", delegate: self, encrypted: false) as PTPusher
        
        var pusherChannel = pusherClient.subscribeToChannelNamed("\(self.party!.id)") as PTPusherChannel
        
        pusherChannel.bindToEventNamed("request_liked", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("liked! \(newRequest)")
            self.loadTableView() {
                self.tableView.reloadData()
            }
        })
        
        pusherChannel.bindToEventNamed("request_unliked", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("unliked! \(newRequest)")
            self.loadTableView() {
                self.tableView.reloadData()
            }
        })
        
        pusherChannel.bindToEventNamed("request_created", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("created! \(newRequest)")
            self.loadTableView() {
                self.tableView.reloadData()
                if self.requests.count == 1 {
                    self.loadPlayer()
                }
            }
        })
        
        pusherChannel.bindToEventNamed("request_played", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("played! \(newRequest)")

            self.loadTableView() {
                self.tableView.reloadData()
                println("check \(newRequest.id) == \(self.request!.id)")
                if self.request!.id == newRequest.id {
                    println("true")
                    self.loadPlayer()
                }
            }
        })
        
        pusherChannel.bindToEventNamed("request_destroyed", handleWithBlock: { channelEvent in
            let newRequest = Request(request: channelEvent.data as NSDictionary)
            println("destroyed! \(newRequest)")
            
            self.loadTableView() {
                self.tableView.reloadData()
                println("check \(newRequest.id) == \(self.request!.id)")
                if self.request!.id == newRequest.id {
                    println("true")
                    self.loadPlayer()
                }
            }
        })
        
        self.pusherClient.connect()
        
        // GET party songs
        self.loadTableView() {
            self.tableView.reloadData()
            println("check movie player \(self.moviePlayer)")
            self.loadPlayer()
        }
        self.title = self.party!.name
        
    }

//    override func viewWillDisappear(animated: Bool) {
//        println("view will disappear")
//        AVAudioSession.sharedInstance().setActive(false, error: nil)
//        self.playerController?.player = nil
//        self.playerController = nil
//        self.moviePlayer = nil
//    }
//
//    override func viewDidDisappear(animated: Bool) {
//        println("view did disappear")
//        self.playerController?.player?.pause()
//        self.playerController = nil
//        self.moviePlayer = nil
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let wantRequest = self.requests[indexPath.row]
            
            self.requests.removeAtIndex(indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView.endUpdates()
            
            managerJ.DELETE("http://music-hasalon-api.herokuapp.com/requests/\(wantRequest.id)", parameters: [
                "user_access_token": self.user!["access_token"] as String,], success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                    println("delete success \(responseObject)")
                }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                    println("delete error \(error)")
            })
            
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "songCell")
        // image
        cell?.imageView?.image = self.requests[indexPath.row].thumbnail
        // title
        cell?.textLabel!.text = self.requests[indexPath.row].title
        return cell!
    }

    
    func loadTableView(closure: Void -> Void) {
        managerJ.GET("http://music-hasalon-api.herokuapp.com/parties/\(self.party!.id)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                if let quote = responseObject?.objectForKey("party")?.objectForKey("requests") as? [NSDictionary] {
                    self.requests = []
                    for req in quote {
                        self.requests.append(Request(request: req))
                    }
                    
                    if self.requests.count > 0 {
                        closure()
                        self.request = self.requests[0]
                    }
                } else {
                    println("no quote")
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    
    // MARK - Player
    
    func loadPlayer() {
        
        var requestUrl = requests.first!.url as String
        let words = requestUrl.componentsSeparatedByString("&feature")
        println(words)
        requestUrl = words[0]
        
        println("http://ec2-54-85-146-44.compute-1.amazonaws.com:8989/api/info?url=\(requestUrl)")
        managerT.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain")

        managerT.GET("http://ec2-54-85-146-44.compute-1.amazonaws.com:8989/api/info?url=\(requestUrl)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                if let quote = responseObject?.objectForKey("direct_url")? as? NSString {
                    
                    var url:NSURL = NSURL(string: quote)!
                    let playerItem = AVPlayerItem(URL: url)
                    
                    if self.moviePlayer == nil {
                        self.moviePlayer = AVPlayer(playerItem: playerItem)
                        println("### moviePlayer nil ###")
                    } else {
                        self.moviePlayer.replaceCurrentItemWithPlayerItem(playerItem)
                        println("### moviePlayer set current ###")
                    }
                    
                    if self.playerController == nil {
                        self.playerController = AVPlayerViewController()
                    }
                    
                    self.playerController.player = self.moviePlayer
                    self.addChildViewController(self.playerController)
                    self.view.addSubview(self.playerController.view)
                    self.playerController.view.frame = CGRectMake(0, 60, self.view.bounds.width, 200)
                    
                    self.moviePlayer.play()
                    
                    self.startBackgroundStreaming()
                    
                    NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
                    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onStop", name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)


                } else {
                    println("no quote")
                }

            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
        
        

        
    }
    
    // MARK: - Background

    
    func startBackgroundStreaming() {
        println("start background streaming")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "RemoteControlEventReceived", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "remoteControlEventNotification:", name:"RemoteControlEventReceived", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UIApplicationWillEnterForegroundNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appEnteredForeGround", name: "UIApplicationWillEnterForegroundNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UIApplicationWillResignActiveNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appEnteredBackground", name: "UIApplicationWillResignActiveNotification", object: nil)
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
        // must have these in order to work!
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
    }
    
    
    func onStop() {
        println("on stop!!!!")
        let parameters = [
            "user_access_token": self.user!["access_token"] as String,
            "latitude": 1.1111111,
            "longitude": 1.1111111
        ]
        println(parameters)
    
        println("http://music-hasalon-api.herokuapp.com/requests/\(self.request!.id)/played")
        
        managerJ.PUT("http://music-hasalon-api.herokuapp.com/requests/\(self.request!.id)/played", parameters:parameters, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println(responseObject)
                println("on stop success")
            }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
                println("on stop failure")
            })
        
    }
    
    func appEnteredForeGround() {
        println("app has entered foreground")
    }
    
    func appEnteredBackground() {
        println("app has entered background")
    }
    
    func remoteControlEventNotification(note: NSNotification) {
        let event: UIEvent = note.object as UIEvent
        println("remote control event")
        if event.type == UIEventType.RemoteControl {
            println("event.type = \(event.type.rawValue)")
            println("event.subtype = \(event.subtype.rawValue)")
            switch event.subtype {
            case UIEventSubtype.RemoteControlPause:
                // Toggle play pause
                println("pause")
                //self.playerLayer.player.pause()
                self.moviePlayer.pause()
                break
            case UIEventSubtype.RemoteControlPlay:
                println("play")
                //self.playerLayer.player.play()
                self.moviePlayer.play()
                break
            case UIEventSubtype.RemoteControlNextTrack:
                println("skip")
                self.playerController.player.pause()
                self.onStop()
                break
            default:
                println("default \(event)")
                break
                
            }
        }
    }
}
