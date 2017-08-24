//
//  VodCodeViewController.swift
//  vod
//
//  Created by Tomas Arguinzones on 15/8/17.
//  Copyright © 2017 Tomas Arguinzones. All rights reserved.
//

import UIKit
import Foundation

class CodeViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var codeLabel: UILabel!
    
    //MARK: Global Variables
    var timer = Timer()
    var currentCode = ""
    var UID:String? {
        get{
            return UserDefaults.standard.string(forKey: "UID")
        }
        set{
            UserDefaults.standard.set(newValue,forKey: "UID")
        }
    }
    let API_KEY = "3_rtt42przMxWP4Vl-ny6m7ocXnBskWrpVcTg8cGLLKy7fSmYbRtBaC7Y8wvYQLu8R"
    let DC = "us1"
    let APP_KEY = "AKpApEqQ4MT9"
    let SECRET = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UID==nil{
            updateCounter()
            var payload = [URLQueryItem]()
            payload.append(URLQueryItem(name: "data", value: "{\"pin\":\"\(currentCode)\",\"siteId\":\"appleTV\",\"verified\":false}"))
            payload.append(URLQueryItem(name: "type", value: "registeringDevice"))
            payload.append(URLQueryItem(name: "oid", value: currentCode))
            
            callGigyaAPI(namespace: "ds", endpoint: "store", payLoad: payload)
            
            timer = Timer.scheduledTimer(timeInterval: 30, target:self, selector: #selector(self.checkForVerifiedCode), userInfo: nil, repeats: true)
        }else{
            showVideoView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Private Functions
    
    func checkForVerifiedCode(){
        var payload = [URLQueryItem]()
        payload.append(URLQueryItem(name: "type", value: "registeringDevice"))
        payload.append(URLQueryItem(name: "oid", value: currentCode))
        callGigyaAPI(namespace: "ds", endpoint: "get", payLoad: payload)
    }
    
    func updateCounter() {
        currentCode = String(randomInt(min:0,max:9999))
        codeLabel.text=currentCode
    }
    
    func completionHandler(namespace:String, endpoint:String, response: Data ){
        if endpoint=="get" && namespace=="ds" {
            do {
                let response = try JSONSerialization.jsonObject(with: response) as! [String:Any]
                let data = response["data"] as! [String:Any]
                let verified = data["verified"] as! Bool

                if verified{
                    UID = data["uid"] as? String
                    timer.invalidate()
                    showVideoView()
                }
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
    
    func showVideoView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let videoViewController = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        self.present(videoViewController, animated: true, completion: nil)
    }
    
    func callGigyaAPI(namespace: String, endpoint: String, payLoad: Array<URLQueryItem> = Array()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "\(namespace).\(DC).gigya.com";
        urlComponents.path = "/\(namespace).\(endpoint)";
        
        let apikeyQry = URLQueryItem(name: "apiKey", value: API_KEY)
        let appkeyQry = URLQueryItem(name: "userKey", value: APP_KEY)
        let secretQry = URLQueryItem(name: "secret", value: SECRET)
        //var array = [[apikeyQry,appkeyQry,secretQry],payLoad]
        urlComponents.queryItems = [[apikeyQry,appkeyQry,secretQry],payLoad].flatMap { $0 }
        //urlComponents.queryItems = [apikeyQry,appkeyQry,secretQry]
        
        let urlRequest = URLRequest(url: urlComponents.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, response, error in
            // check for any errors
            guard error == nil else {
                print("error calling GET on \(urlComponents.url!)")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                // now we have the todo
                // let's just print it to prove we can access it
                self.completionHandler(namespace: namespace, endpoint: endpoint, response: responseData)
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }


}
