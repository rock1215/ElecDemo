//
//  ViewController.swift
//  ElecDemo
//
//  Created by Yansong Wang on 2022/6/10.
//  Copyright © 2022 GST.PID. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelHeartSampleCount: UILabel!
    var sampleCount = 0
    
    @IBOutlet weak var labelCurrentHeartBeat: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeartBeat(notification:)), name: NotificationUpdateHeartRate, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        WorkoutTracking.shared.authorizeHealthKit()
        WorkoutTracking.shared.observerHeartRateSamples()
        WatchKitConnection.shared.delegate = self
    }
    
    @objc func updateHeartBeat(notification: Notification) {
        if let userInfo = notification.userInfo, let heartRate = userInfo["heartBeat"] as? Double {
            self.sampleCount += 1
            DispatchQueue.main.async {
                self.labelHeartSampleCount.text = "\(self.sampleCount)"
                self.labelCurrentHeartBeat.text = "\(heartRate)"
            }
        }
        
    }
}

extension ViewController: WatchKitConnectionDelegate {
    func didFinishedActiveSession() {
        WatchKitConnection.shared.sendMessage(message: ["username" : "nhathm" as AnyObject])
    }
}
