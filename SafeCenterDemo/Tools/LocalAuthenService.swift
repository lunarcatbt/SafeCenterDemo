//
//  LocalAuthenService.swift
//  SafeCenterDemo
//
//  Created by 龙少 on 2019/6/11.
//  Copyright © 2019 龙少. All rights reserved.
//

import Foundation
import LocalAuthentication
import UIKit

class AuthenManager {
    static let standard = AuthenManager()
    let context = LAContext()

    private init() {
    }
    
    func getAuthenState(controller: UIViewController) -> Bool {
        var error: NSError?
        let success = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        
        self.dealError(error)
    
        return success
    }
    
    func evaluate(_ handler: @escaping((Bool) -> Void)) {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "需要验证您的指纹来验证身份信息") { (success, error) in
            DispatchQueue.main.async {
                handler(success)
            }
            
        }
    }
    
    func dealError(_ error: NSError?) {
        if error != nil {
            var message = ""
            
            switch error?.code {
            case Int(kLAErrorPasscodeNotSet):
                message = "您没有设置密码"
            default:
                message = "未知错误"
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
}
