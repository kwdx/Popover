//
//  PopoverAnimator.swift
//  WeiBo
//
//  Created by duoduo on 2016/10/22.
//  Copyright © 2016 CorJi. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    // MARK:- 对外提供的属性
    var isPresented : Bool = false
    // 按钮的frame
    var senderFrame : CGRect = CGRect.zero
    // 展示的大小
    var presentedSize : CGSize = CGSize.zero
    
    // 
    fileprivate var presentedFrame : CGRect = CGRect.zero
    fileprivate var arrowFrame : CGRect = CGRect.zero
    
    // MARK: - 私有属性
    fileprivate var arrowBg : ArrowView = ArrowView(frame: CGRect.zero, arrowBgColor: UIColor.clear)
    
    var callBack : ((_ presented : Bool) -> ())?
    
    // MARK:- 自定义构造函数
    // 注意:如果自定义了一个构造函数,但是没有对默认构造函数init()进行重写,那么自定义的构造函数会覆盖默认的init()构造函数
    init(callBack : @escaping (_ presented : Bool) -> ()) {
        self.callBack = callBack
    }
}

// MARK: - 自定义转场代理的方法
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    // 目的:改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = WDPresentationController(presentedViewController: presented, presenting: presenting)
        // 创建背景箭头
        arrowBg = ArrowView(frame: CGRect.zero, arrowBgColor: (presented.view.backgroundColor)!)
        presentation.arrow = arrowBg
        calFrame()
        presentation.arrowFrame = arrowFrame
        presentation.presentedFrame = presentedFrame
        return presentation
    }
    
    // 目的:自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        callBack!(isPresented)
        
        return self
    }
    
    // 目的:自定义消失的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        callBack!(isPresented)
        
        return self
    }

}

// MARK: - 弹出和消失动画代理的方法
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    
    // 动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /// 获取`转场的上下文`:可以通过转场上下文获取弹出的View和消失的View
    // UITransitionContextViewKey.from : 获取消失的View
    // UITransitionContextViewKey.to : 获取弹出的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissedView(transitionContext: transitionContext)
    }
    
    /// 自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // 2.将弹出的View添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        transitionContext.containerView.insertSubview(arrowBg, belowSubview: presentedView)

        // 3.执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        switch arrowBg.direction {
        case .up:
            presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            arrowBg.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            arrowBg.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        case .down:
            presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            arrowBg.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            arrowBg.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        }

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform.identity
            self.arrowBg.transform = CGAffineTransform.identity
        }) { (_) in
            // 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    
    /// 自定义消失动画
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取消失的View
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        // 2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0000001)
            self.arrowBg.transform = CGAffineTransform(scaleX: 1.0, y: 0.0000001)
        }) { (_) in
            dismissView?.removeFromSuperview()
            // 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
        
    }
}

extension PopoverAnimator {
    fileprivate func calFrame() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        /// arrow的frame
        var frame = CGRect(x: 0, y: 0, width: presentedSize.width + 8, height: presentedSize.height + 14)
        arrowBg.arrowLoc = frame.midX
        
        /// 处理上下方向问题
        if senderFrame.maxY + frame.height > height {
            // 反转箭头
            frame.origin.y = senderFrame.minY - frame.height - 5
            arrowBg.direction = .down
        } else {
            frame.origin.y = senderFrame.maxY + 5
        }
        
        let a = (frame.width - senderFrame.width) / 2
        if a - senderFrame.minX > 0 {
            frame.origin.x = 0
            arrowBg.arrowLoc = arrowBg.arrowLoc - (a - senderFrame.minX)
        } else if a + senderFrame.maxX > width
        {
            frame.origin.x = senderFrame.minX - a - (a + senderFrame.maxX - width)
            arrowBg.arrowLoc = senderFrame.midX - frame.minX
        } else {
            frame.origin.x = senderFrame.minX - a
        }
        
        self.arrowFrame = frame
        presentedFrame = arrowFrame.insetBy(dx: 4, dy: 9)
        
    }
}
