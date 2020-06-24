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
    
    ///現在時間取得（ロンドン時間）
    let dt = Date()
    /// インスタンス生成
    let dateFormatter = DateFormatter()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        dateGet()
        // Do any additional setup after loading the view.
    }
    
    
    ///現在時間変換関数
    func dateGet(){
        ///ロンドン時間を日本時間に変換
              dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        ///時間だけをdataに指定
               let data = dateFormatter.string(from: dt).suffix(4)
                print(data)
    }
    
    
    
    ///Lottieアニメーション設定
    func Lottienimation() {
           animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: (view.frame.size.height) / 3)
                  animationView.animation = ainamtion
                  animationView.contentMode = .scaleAspectFit
                  animationView.loopMode = .playOnce
                  animationView.backgroundColor = .clear
                  view.addSubview(animationView)
       }
    ///寝るボタンアニメーション
    @IBAction func nightLottieStart(_ sender: Any) {
        Lottienimation()
        animationView.play()
        
    }
    ///起きるボタンアニメーション
    @IBAction func nightLottieStop(_ sender: Any) {
        Lottienimation()
        animationView.play()
        animationView.stop()
        
    }
    
   
    
}

