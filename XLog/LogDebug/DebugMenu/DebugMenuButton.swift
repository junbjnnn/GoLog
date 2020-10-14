//
//  DebugMenuButton.swift
//  XLog
//
//  Created by NamDV on 8/25/20.
//  Copyright © 2020 ER. All rights reserved.
//

import UIKit

class DebugMenuButton: UIControl {

    static let devButtonTag = 696969
    
    var label: UILabel?
    var tappable = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tag = DebugMenuButton.devButtonTag
        backgroundColor = UIColor.systemYellow
        
        label = DebugMenuButton.label()
        if let label = label {
            addSubview(label)
        }
        
        setNeedsLayout()
        addTarget(self, action: #selector(move(withSender:event:)), for: .touchDragInside)
        addTarget(self, action: #selector(move(withSender:event:)), for: .touchDragOutside)
        addTarget(self, action: #selector(stopDragging(_:event:)), for: .touchDown)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(frame: DebugMenuButton.devButtonFrame())
    }
    
    class func devButton() -> DebugMenuButton? {
        return DebugMenuButton(frame: self.devButtonFrame())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label?.frame = DebugMenuButton.frame(withBounds: bounds, padding: 8)
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 1.0
    }
    
    @objc
    func move(withSender sender: Any?, event: UIEvent?) {
        let control = sender as? UIControl
        
        let touch = event?.allTouches?.first
        if let prevPoint = touch?.previousLocation(in: control),
            let point = touch?.location(in: control),
            var center = control?.center {
            center.x += point.x - prevPoint.x
            center.y += point.y - prevPoint.y
            control?.center = center
        }
        tappable = false
    }
    
    @objc
    func stopDragging(_ sender: Any?, event: UIEvent?) {
        tappable = true
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = self.isHighlighted ? 0.3 : 1.0
        }
    }
    
    class func label() -> UILabel? {
        let label = UILabel(frame: CGRect.zero)
        label.text = "🐞"
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.isUserInteractionEnabled = false
        return label
    }
    
    class func frame(withBounds bounds: CGRect, padding: CGFloat) -> CGRect {
        let x = bounds.origin.x + padding
        let y = bounds.origin.y + padding
        let width = bounds.size.width - padding * 2
        let height = bounds.size.height - padding * 2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    class func devButtonFrame() -> CGRect {
        let x: CGFloat = 10
        let y: CGFloat = UIScreen.main.bounds.size.height - 69
        let size: CGFloat = 48
        return CGRect(x: x, y: y, width: size, height: size)
    }
    
}
