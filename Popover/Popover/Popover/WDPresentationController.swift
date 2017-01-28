//
//  WDPresentationController.swift
//  Popover
//
//  Created by duoduo on 2016/10/22.
//  Copyright © 2016年 CorJi. All rights reserved.
//

import UIKit

class WDPresentationController: UIPresentationController {
    
    // MARK:- 对外提供属性
    var arrowFrame : CGRect = CGRect.zero
    var presentedFrame : CGRect = CGRect.zero
    
    var arrow : ArrowView?
    
    // MARK:- 懒加载属性
    fileprivate lazy var coverView : UIView = UIView()
    
    // MARK: - 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        /// 改变弹出view的大小
        presentedView?.frame = presentedFrame
        
        /// 改变箭头View的大小
        arrow?.frame = arrowFrame

        /// 添加蒙版
        setupCoverView()
    }
}

// MARK: - 设置UI相关
extension WDPresentationController {
    fileprivate func setupCoverView() {
        // 1.添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        
        // 2.设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        // 3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }}

// MARK: - 事件监听
extension WDPresentationController {
    @objc fileprivate func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
