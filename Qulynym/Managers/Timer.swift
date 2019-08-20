//
/*
* Kulynym
* Timer.swift
*
* Created by: Metah on 5/10/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import Foundation

protocol TimerControllerDelegate: class {
    var duration: TimeInterval { get }
    
    func notifyOfTimepoints()
    func notifyTimerEnded()
}

class TimerController {
    // MARK:- Properties
    var timer: Timer?
    var delegate: TimerControllerDelegate!
    
    var seconds = 0
    
    // MARK:- Timer
    func nullifyData() {
        timer?.invalidate()
        timer = nil
        seconds = 0 
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkState), userInfo: nil, repeats: true)
    }
    
    @objc private func checkState() {
        seconds += 1
        
        delegate.notifyOfTimepoints()
        
        if seconds == Int(delegate.duration) {
            timer?.invalidate()
            timer = nil
            delegate.notifyTimerEnded()
        }
    }
}
