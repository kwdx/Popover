//
//  ViewController.swift
//  Popover
//
//  Created by duoduo on 2016/10/22.
//  Copyright © 2016年 CorJi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let animator = PopoverAnimator { (_) in
//        print("click")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var btn: UIButton!
    @IBAction func btnClick(_ sender: AnyObject) {
        
        let modal = ModalViewController()
        modal.transitioningDelegate = animator
        modal.modalPresentationStyle = .custom
//        animator.presentedFrame = CGRect(x: 100, y: 64, width: 150, height: 300)
        animator.senderFrame = sender.frame
        animator.presentedSize = CGSize(width: 150, height: 300)
        present(modal, animated: true, completion: nil)
        
    }

}

