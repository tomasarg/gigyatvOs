//
//  WelcomeViewController.swift
//  vod
//
//  Created by Tomas Arguinzones on 23/8/17.
//  Copyright © 2017 Tomas Arguinzones. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    //MARK: Private variables
    var timer = Timer()
    var UID:String? {
        get{
            return UserDefaults.standard.string(forKey: "UID")
        }
        set{
            UserDefaults.standard.set(newValue,forKey: "UID")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 5, target:self, selector: #selector(self.selectNextView), userInfo: nil, repeats: true)
    }

    //MARK: - Navigation
    func selectNextView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if UID==nil{
            let viewController = storyBoard.instantiateViewController(withIdentifier: "CodeViewController") as! CodeViewController
            self.present(viewController, animated: true, completion: nil)
        }else{
            let videoViewController = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            self.present(videoViewController, animated: true, completion: nil)
        }
        timer.invalidate()
    }
}
