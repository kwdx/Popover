//
//  ArrowView.swift
//  Popover
//
//  Created by duoduo on 2016/10/21.
//  Copyright © 2016年 CorJi. All rights reserved.
//

import UIKit

private let kArrowWidth : CGFloat = 15
private let kArrowHeight : CGFloat = 8

// 边框外边距
private let kArrowMargin : CGFloat = 2
private let kArrowCornerRadius : CGFloat = 5

public enum WDArrowDirection : Int {
    case up
    case down
}


class ArrowView: UIView {
    
    // MARK: - 箭头属性
    /// 箭头边框背景颜色
    var arrowBgColor : UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    /// 箭头位置
    var arrowLoc : CGFloat = 0
    /// 箭头方向
    var direction : WDArrowDirection = .up
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arrowBgColor = .gray
        backgroundColor = .clear
        layer.anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    
    // MARK:- 自定义构造函数
    // 注意:如果自定义了一个构造函数,但是没有对默认构造函数init()进行重写,那么自定义的构造函数会覆盖默认的init()构造函数
    init(frame: CGRect, arrowBgColor : UIColor) {
        self.arrowBgColor = arrowBgColor
        super.init(frame: frame)
        backgroundColor = .clear
        layer.anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.arrowBgColor = .gray
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 绘制图形
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 获取图形上下文
        let context = UIGraphicsGetCurrentContext()!
        // 设置边框的宽度
        context.setLineWidth(1)
        // 设置边框的颜色
        context.setStrokeColor(UIColor.gray.cgColor)
        // 设置填充颜色
        context.setFillColor(arrowBgColor.cgColor)
        
        // 绘制三角
        context.beginPath()
        
        //
        let minX = kArrowMargin
        let maxX = rect.width - kArrowMargin
        let minY = kArrowHeight
        let maxY = rect.height - kArrowHeight
        
        // 起点
        // 左上角圆弧
        var centerPoint = CGPoint(x: minX + kArrowCornerRadius, y: minY + kArrowCornerRadius)
        context.addArc(center: centerPoint, radius: kArrowCornerRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(-M_PI_2), clockwise: false)
        
        
        // 箭头
        if direction == .up {
            context.addLine(to: CGPoint(x: arrowLoc - kArrowWidth / 2, y: minY))
            context.addLine(to: CGPoint(x: arrowLoc, y: 0))
            context.addLine(to: CGPoint(x: arrowLoc + kArrowWidth / 2, y: minY))
        }
        context.addLine(to: CGPoint(x: maxX - kArrowCornerRadius, y: minY))

        
        // 右上角圆弧
        centerPoint = CGPoint(x: maxX - kArrowCornerRadius, y:minY + kArrowCornerRadius)
        context.addArc(center: centerPoint, radius: kArrowCornerRadius, startAngle: -(CGFloat)(M_PI_2), endAngle: 0, clockwise: false)
        
        // 右边线
        context.addLine(to: CGPoint(x: maxX, y: maxY - kArrowCornerRadius))
        
        // 右下角圆弧
        centerPoint = CGPoint(x: maxX - kArrowCornerRadius, y: maxY - kArrowCornerRadius)
        context.addArc(center: centerPoint, radius: kArrowCornerRadius, startAngle: 0, endAngle: CGFloat(M_PI_2), clockwise: false)
        
        // 下边线
        if direction == .down {
            context.addLine(to: CGPoint(x: arrowLoc + kArrowWidth / 2, y: maxY))
            context.addLine(to: CGPoint(x: arrowLoc, y: maxY + minY))
            context.addLine(to: CGPoint(x: arrowLoc - kArrowWidth / 2, y: maxY))
        }
        context.addLine(to: CGPoint(x: minX + kArrowCornerRadius, y: maxY))
        
        // 右下角圆弧
        centerPoint = CGPoint(x: minX + kArrowCornerRadius, y: maxY - kArrowCornerRadius)
        context.addArc(center: centerPoint, radius: kArrowCornerRadius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: false)
        // 关闭起点和终点
        context.closePath()
        context.drawPath(using: .fillStroke)
    }
}
