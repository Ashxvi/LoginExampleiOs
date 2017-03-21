//
//  ViewController.swift
//  Login
//
//  Created by MAHHA on 08/03/2017.
//  Copyright © 2017 MAHHA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var _username: UITextField!
    
    @IBOutlet weak var _password: UITextField!
    
    @IBOutlet weak var _sign_in: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let preferences = UserDefaults.standard
        
        
        if preferences.object(forKey: "session") != nil
        {
            LoginDone()
            
        }
        else
        {
            LoginToDo()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func Login(_ sender: Any) {
        
        
        
        if(_sign_in.titleLabel?.text == "Sign out")
        {
            let preferences = UserDefaults.standard
            preferences.removeObject(forKey: "session")
            
            
            LoginToDo()
        }
        else{
            
            let username = _username.text
            let password = _password.text
            
            if(username=="" || password==""){
                return
            }
                
            else{
                CheckSession(username!,password!)
            }
            
        }
        
        
       
    }
    
    
    func CheckSession(_ user:String, _ psw:String){
        
        let url = URL(string: "http://www.kaleidosblog.com/tutorial/login/api/Login")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "username="+user+"&password="+psw
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            
            let json: Any?
            
            do
            {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch
            {
                return
            }
            
            guard let server_response = json as? NSDictionary else
            {
                return
            }
            
            if let response_code = server_response["response_code"] as? Int
                
            {
                if(response_code == 200)
                {
                    DispatchQueue.main.async(execute: self.LoginDone)
                }
                else
                {
                    DispatchQueue.main.async(execute: self.LoginToDo)
                }
            }
            
            
            
        })
        
        task.resume()

    }
    
    
    
    
    func LoginDone()
    {
        _username.isHidden = true
        _password.isHidden = true
        
        _sign_in.isEnabled = true
        
        
        _sign_in.setTitle("Sign out", for: .normal)
    }
    
    func LoginToDo()
    {
        _username.isHidden = false
        _password.isHidden = false
        
        _username.text = ""
        _password.text = ""
        
        _sign_in.isEnabled = true
        
        
        _sign_in.setTitle("Sign in", for: .normal)
    }
}

