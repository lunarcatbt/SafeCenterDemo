//
//  ViewController.swift
//  SafeCenterDemo
//
//  Created by 龙少 on 2019/6/11.
//  Copyright © 2019 龙少. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var loginBtn: UIButton!
    var context = LAContext()
    var hasShowFlag = false
    
    enum AuthenticationState {
        case loggedin, loggedout
    }
    
    var state = AuthenticationState.loggedout {
        didSet{
            loginBtn.isHighlighted = state == .loggedin
            view.backgroundColor   = state == .loggedin ? .green:.red
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        context.localizedCancelTitle = "取消"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard state == .loggedout else {
            return
        }
        
        guard hasShowFlag == false else {
            return
        }
        
        if let flag = UserDefaults.standard.value(forKey: "canFace") as? Int {
            guard flag == 1 else {
                return;
            }
            
            let vc = WelcomeController()
            vc.didFinishEvaluate = { [weak self] (success) in
                if success == true {
                    self?.state = .loggedin
                }
                
                self?.hasShowFlag = true
            }
            
            vc.title = "登录"
            self.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func touchEvent(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "touchID&faceID" {
            if state == .loggedin {
                state = .loggedout
                return
            }
            
            if AuthenManager.standard.getAuthenState(controller: self) == true{
                AuthenManager.standard.evaluate { [weak self] (success) in
                    if success {
                        DispatchQueue.main.async {
                            self?.state = .loggedin
                            UserDefaults.standard.set(1, forKey: "canFace")
                        }
                    }else{
                        debugPrint("认证失败")
                    }
                }
            }else{
                debugPrint("无法获取认证方式")
            }
        }else{
            let vc = PatternController()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

