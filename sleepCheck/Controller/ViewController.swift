//
//  ViewController.swift
//  sleepCheck
//
//  Created by Tatsuki Ikeda on 2020/06/23.
//  Copyright © 2020 tatsuki.ikeda. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    var animationView:AnimationView = AnimationView()

    let ainamtion = Animation.named("night")
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func nightLottieStart(_ sender: Any) {
    
    
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        animationView.animation = ainamtion
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.backgroundColor = .clear
        view.addSubview(animationView)
        animationView.play()
        
    }
    
    @IBAction func nightLottieStop(_ sender: Any) {
        animationView.play()
        animationView.stop()
        
    }
    
    
    
}

