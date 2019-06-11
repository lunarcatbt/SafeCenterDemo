//
//  PatternController.swift
//  SafeCenterDemo
//
//  Created by 龙少 on 2019/6/11.
//  Copyright © 2019 龙少. All rights reserved.
//

import Foundation
import UIKit

class PatternController: UIViewController {
    enum PatternState {
        case none
        case firstDraw
        case secondDraw
    }
    
    var state = PatternState.firstDraw {
        didSet{
            if state == .secondDraw {
                
                if self.validPattern() == false {
                    noticeLabel.textColor = .red
                    noticeLabel.text = "两次绘图不一致"
                }else{
                    noticeLabel.textColor = .blue
                    noticeLabel.text = "设置解锁图案成功"
                }
            }
            
            if state == .firstDraw {
                noticeLabel.text = "请再次绘制解锁图案"
            }
            
            if state == .none {
                noticeLabel.text = ""
            }
        }
    }
    
    var patternResult: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(patternView)
        patternView.center = self.view.center
        
        let cancel = UIButton()
        cancel.setTitle("cancel", for: .normal)
        cancel.setTitleColor(.blue, for: .normal)
        cancel.frame = CGRect.init(x: 10, y: 40, width: 60, height: 30)
        cancel.addTarget(self, action: #selector(back), for: .touchUpInside)
        cancel.titleLabel?.adjustsFontSizeToFitWidth = true
        self.view.addSubview(cancel)
        
        self.view.addSubview(noticeLabel)
        var noticeCenter = patternView.center
        noticeCenter.y -= 200
        noticeLabel.center = noticeCenter
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var patternView: LockScreen = {
        var config = LockScreen.Config()
        config.lineColor = UIColor.lightGray
        let lockScreen = LockScreen(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400), size: 3, allowClosedPattern: false, config: config, handler: { [weak self] (numberList, cellIndex)  in
            debugPrint("index:\(cellIndex.description)")
            debugPrint("numberList:\(numberList)")
            self?.patternResult.append(numberList)
            if self?.patternResult.count == 1 {
                self?.state = .firstDraw
            }else {
                self?.state = .secondDraw
            }
        })
        
        return lockScreen
    }()
    
    lazy var noticeLabel: UILabel = {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        
        return label
    }()
}

extension PatternController {
    func validPattern() -> Bool {
        guard patternResult.count > 1 else {
            return false
        }
        
        let originPattern = patternResult.first
        let latestPattern = patternResult.last
        
        return latestPattern == originPattern ? true : false
    }
}
