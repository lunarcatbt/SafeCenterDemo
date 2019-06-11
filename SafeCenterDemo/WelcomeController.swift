//
//  GestureView.swift
//  SafeCenterDemo
//
//  Created by 龙少 on 2019/6/11.
//  Copyright © 2019 龙少. All rights reserved.
//

import Foundation
import UIKit

class WelcomeController: UIViewController {
    var didFinishEvaluate: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "登录"
        
        self.view.addSubview(welcomeLabel)
        welcomeLabel.center = self.view.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AuthenManager.standard.evaluate { [weak self] (success) in
            self?.dismiss(animated: true, completion: nil)
            if let complete = self?.didFinishEvaluate {
                complete(success)
            }
        }
    }
    
    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome back!"
        label.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .blue
        
        return label
    }()
}

