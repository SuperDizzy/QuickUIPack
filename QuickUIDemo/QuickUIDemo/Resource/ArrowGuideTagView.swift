//
//  ArrowGuideTagView.swift
//  QuickUIDemo
//
//  Created by Wanzi on 2020/10/27.
//

import Foundation
import UIKit

enum ArrowGuideTagDirectionType: Int {
    case top = 0
    case bottom = 1
    case left = 2
    case right = 3
}

struct ArrowGuideTagConfig {
    /// 视图箭头所指向的方向
     var directionType = ArrowGuideTagDirectionType.bottom
    /// 视图箭头的高度
     public var arrowHeight: CGFloat = 6
    /// 视图箭头的宽度
     public var arrowWidth: CGFloat = 4
    /// 视图矩形的圆角大小
     public var cornerRadius: CGFloat = 6
    /// 视图的背景色
     public var mainBackgroundColor = UIColor.gray
    /// 视图箭头相对于矩形中部的偏移量
     public var arrowOffset: CGFloat = 0
    /// 边框宽度
     public var boardWidth: CGFloat = 0
    /// 边框颜色
     public var boardColor: UIColor?
}

class ArrowGuideTagView: UIView {
    var _config = ArrowGuideTagConfig()
  
    public init(frame: CGRect, arrowConfig: ArrowGuideTagConfig?) {
        if arrowConfig != nil {
            _config = arrowConfig!
        }
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        backgroundColor = UIColor.clear
        drawPath(bounds)
    }
    
    func drawPath(_ rect: CGRect) {
        var triangleFirstPoint: CGPoint
        var triangleArrowPoint: CGPoint
        var triangleEndPoint: CGPoint
        
        var verticalOffset = CGFloat(0)
        var horizontalOffset = CGFloat(0)
        var rangeRectWidth = rect.width
        var rangeRectHeight = rect.height
        var needDrawTriangleIndex = 1
        
        switch _config.directionType {
        case .top:
            verticalOffset = 0
            horizontalOffset = _config.arrowHeight
            rangeRectHeight -= _config.arrowHeight
            needDrawTriangleIndex = 1
            
            triangleFirstPoint = CGPoint(x: rect.size.width/2 - _config.arrowWidth/2 + _config.arrowOffset, y: _config.arrowHeight)
            triangleArrowPoint = CGPoint(x: rect.size.width/2 + _config.arrowOffset, y: 0)
            triangleEndPoint = CGPoint(x: rect.size.width/2 + _config.arrowWidth/2 + _config.arrowOffset, y: _config.arrowHeight)
        case .bottom:
            verticalOffset = 0
            horizontalOffset = 0
            needDrawTriangleIndex = 5
            rangeRectHeight -= _config.arrowHeight
            
            triangleFirstPoint = CGPoint(x: rect.size.width/2 + _config.arrowWidth/2 + _config.arrowOffset, y: rangeRectHeight)
            triangleArrowPoint = CGPoint(x: rect.size.width/2 + _config.arrowOffset, y: rect.size.height)
            triangleEndPoint = CGPoint(x: rect.size.width/2 - _config.arrowWidth/2 + _config.arrowOffset, y: rangeRectHeight)
        case .left:
            verticalOffset = _config.arrowHeight
            horizontalOffset = 0
            needDrawTriangleIndex = 7
            rangeRectWidth -= _config.arrowHeight
            
            triangleFirstPoint = CGPoint(x: _config.arrowHeight, y: (rect.size.height + _config.arrowWidth)/2 + _config.arrowOffset)
            triangleArrowPoint = CGPoint(x: 0, y: rect.size.height/2 + _config.arrowOffset)
            triangleEndPoint = CGPoint(x: _config.arrowHeight, y: (rect.size.height - _config.arrowWidth)/2 + _config.arrowOffset)
        case .right:
            verticalOffset = 0
            horizontalOffset = 0
            needDrawTriangleIndex = 3
            rangeRectWidth -= _config.arrowHeight
            
            triangleFirstPoint = CGPoint(x: rangeRectWidth, y: (rect.size.height - _config.arrowWidth)/2 + _config.arrowOffset)
            triangleArrowPoint = CGPoint(x: rect.size.width, y: rect.size.height/2 + _config.arrowOffset)
            triangleEndPoint = CGPoint(x: rangeRectWidth, y: (rect.size.height + _config.arrowWidth)/2 + _config.arrowOffset)
        }
        
        // 左上角，圆角结束后的点
        let firstPoint = CGPoint(x: _config.cornerRadius + verticalOffset, y: 0 + horizontalOffset)
        // 右上角，圆角开始前的点
        let secondPoint = CGPoint(x: rangeRectWidth - _config.cornerRadius + verticalOffset, y: 0 + horizontalOffset)
        // 右上角，圆角结束后的点
        let thirdPoint = CGPoint(x: rangeRectWidth + verticalOffset, y: _config.cornerRadius + horizontalOffset)
        // 右下角，圆角开始前的点
        let fourthPoint = CGPoint(x: rangeRectWidth + verticalOffset, y: rangeRectHeight - _config.cornerRadius + horizontalOffset)
        // 右下角，圆角开始前的点
        let fifthPoint = CGPoint(x: rangeRectWidth - _config.cornerRadius + verticalOffset, y: rangeRectHeight + horizontalOffset)
        // 左下角，圆角开始前的点
        let sixthPoint = CGPoint(x: _config.cornerRadius + verticalOffset, y: rangeRectHeight + horizontalOffset)
        // 左下角，圆角结束后的点
        let seventhPoint = CGPoint(x: 0 + verticalOffset, y: rangeRectHeight - _config.cornerRadius + horizontalOffset)
        // 左上角，圆角开始前的点
        let eighthPoint = CGPoint(x: 0 + verticalOffset, y: _config.cornerRadius + horizontalOffset)
        // 矩形点位置
        let pointList = [firstPoint, secondPoint, thirdPoint, fourthPoint, fifthPoint, sixthPoint, seventhPoint, eighthPoint, firstPoint]
        // 圆角点位置
        var radiusIndexList = [Int]()
        if _config.cornerRadius > 0 {
            radiusIndexList = [2, 4, 6, 8]
        }
        
        // 绘制
        let trianglePath :UIBezierPath = UIBezierPath()
        trianglePath.lineWidth = _config.boardWidth
        for (index, point) in pointList.enumerated() {
            if index == 0 {
                trianglePath.move(to: point)
            }
            if index == needDrawTriangleIndex {
                // 绘制三角形
                trianglePath.addLine(to: triangleFirstPoint)
                trianglePath.addLine(to: triangleArrowPoint)
                trianglePath.addLine(to: triangleEndPoint)
                trianglePath.addLine(to: point)
            } else if radiusIndexList.contains(index) && index > 1 {
                // 绘制圆角区域
                let beforePoint = pointList[index - 1]
                var arcCenterX = min(beforePoint.x, point.x)
                if index == 6 || index == 8 {
                    arcCenterX = max(beforePoint.x, point.x)
                }
                var arcCenterY = min(beforePoint.y, point.y)
                if index == 2 || index == 8 {
                    arcCenterY = max(beforePoint.y, point.y)
                }
                let finalIndex = index - 4
                let startAngle: CGFloat = CGFloat(finalIndex)*1/4 * CGFloat(Double.pi)
                let endAngle: CGFloat = (CGFloat(finalIndex)*1/4 + 1/2) * CGFloat(Double.pi)
                
                trianglePath.addArc(withCenter: CGPoint(x: arcCenterX, y: arcCenterY), radius: _config.cornerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            } else {
                trianglePath.addLine(to: point)
            }
        }
        trianglePath.close()
        
        //创建一个CAShapelayer  用于显示这些路径
        let shPl: CAShapeLayer = CAShapeLayer.init()
        shPl.path = trianglePath.cgPath
        shPl.lineWidth = _config.boardWidth
        shPl.fillColor = _config.mainBackgroundColor.cgColor  //填充路径
        if let boardColor = _config.boardColor {
            shPl.strokeColor = boardColor.cgColor   //描绘路径
        }
        layer.addSublayer(shPl)
    }
}

