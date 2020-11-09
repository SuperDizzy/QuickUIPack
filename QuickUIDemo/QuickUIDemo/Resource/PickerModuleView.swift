//
//  PickerModuleView.swift
//  bantang
//
//  Created by Wanzi on 2020/8/25.
//  Copyright © 2020 SQKB. All rights reserved.
//

import UIKit

enum PickeModuleType {
    case bottomTop
    case topBottom
    case leftRight
    case rightLeft
    case center
}
enum PickeModuleStatus {
    case none
    case hiding
    case showing
    case animating
}

class PickerModuleView: UIView {
    private var type: PickeModuleType = .bottomTop
    private var status: PickeModuleStatus = .none
    private lazy var contentView: UIView = {
        let content = UIView()
        return content
    }()
    private var headerView: UIView?
    private var contentItemView: UIView?
    private var showedBlock: (() -> Void)?
    private var hidedBlock: (() -> Void)?
    
    init(moduleType: PickeModuleType, showSuccessBlock:(() -> Void)?, hideSuccessBlock:(() -> Void)?) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        type = moduleType
        contentView.becomeFirstResponder()
        addSubview(contentView)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(defaultHide))
//        addGestureRecognizer(tapGesture)
        showedBlock = showSuccessBlock
        hidedBlock = hideSuccessBlock
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func defaultHide() {
        hide(with: nil)
    }
    
    func bindContentView(header: UIView?, itemView: UIView, staticSize: CGSize?) {
        headerView = header
        contentItemView = itemView
        var targetPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: frame.size.height)
        switch type {
        case .bottomTop:
            targetPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: frame.size.height)
        default:
            break
        }
        status = .hiding
        var headHeight: CGFloat = 0
        if let head = headerView {
            contentView.addSubview(head)
            headHeight = head.frame.size.height
        }
        contentView.addSubview(itemView)
        contentView.frame.origin = targetPoint
        if let contentSize = staticSize {
            configStaticSize(size: contentSize)
        } else {
            contentView.frame.size = CGSize(width: itemView.frame.size.width, height: itemView.frame.size.height + headHeight)
        }
    }
    
    func configStaticSize(size: CGSize) {
        contentView.frame.size = size
        var headHeight: CGFloat = 0
        if let head = headerView {
            headHeight = head.frame.size.height
        }
        guard let itemView = contentItemView else { return }
        itemView.frame = CGRect(x: 0, y: headHeight, width: size.width, height: size.height)
    }
    
    func show(with animationTime: TimeInterval?, force: Bool) {
        guard (force || status == .hiding) else {
            return
        }
        status = .animating
        var targetPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: frame.size.height - contentView.frame.size.height)
        var beginPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: frame.size.height)
        switch type {
        case .bottomTop:
            targetPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: frame.size.height - contentView.frame.size.height)
            beginPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: frame.size.height)
        case .center:
            targetPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: (frame.size.height - contentView.frame.size.height)/2)
            beginPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: frame.size.height)
        default:
            break
        }
        contentView.frame.origin = beginPoint
        var time: TimeInterval = 0.6
        if let trulyTime = animationTime {
            time = trulyTime
        }
        
        let animateFinished: (Bool) -> Void = { [weak self] finished in
            guard let weakself = self else { return }
            weakself.status = .showing
            if let showed = weakself.showedBlock {
                showed()
            }
        }
        UIView.animate(withDuration: time, animations: { [weak self] in
            guard let weakself = self else { return }
            weakself.contentView.frame.origin = targetPoint
            weakself.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        }, completion: animateFinished)
    }
    
    func hide(with animationTime: TimeInterval?) {
        guard status == .showing else {
            return
        }
        status = .animating
        var targetPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: frame.size.height)
        switch type {
        case .bottomTop:
            targetPoint = CGPoint(x: (frame.size.width - contentView.frame.size.width)/2, y: frame.size.height)
        default:
            break
        }
        var time: TimeInterval = 0.6
        if let trulyTime = animationTime {
            time = trulyTime
        }
        let animateFinished: (Bool) -> Void = { finished in
            self.status = .showing
            if let showed = self.showedBlock {
                showed()
            }
        }
        UIView.animate(withDuration: time, animations: {[weak self] in
            guard let weakself = self else { return }
            weakself.contentView.frame.origin = targetPoint
            weakself.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }, completion: animateFinished)
    }
}
