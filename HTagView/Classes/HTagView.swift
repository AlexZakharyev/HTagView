//
//  HTagView.swift
//  Pods
//
//  Created by Chang, Hao on 5/16/16.
//
//

import UIKit

@IBDesignable
public class HTagView: UIScrollView, HTagDelegate {
    @IBInspectable
    public var type : HTagViewType = .MultiSelect{
        didSet{
            switch type{
            case .Cancel:
                for tag in tags{
                    tag.withCancelButton = true
                    tag.selected = true
                }
            case .MultiSelect:
                for tag in tags{
                    tag.withCancelButton = false
                }
            }
        }
    }
    
//    @IBInspectable
//    public var line : Int = 0
    @IBInspectable
    public var marg : CGFloat = 20
    @IBInspectable
    public var btwTags : CGFloat = 8
    @IBInspectable
    public var btwLines : CGFloat = 8
    @IBInspectable
    public var tagMainBackColor : UIColor = UIColor(colorLiteralRed: 100/255, green: 200/255, blue: 205/255, alpha: 1)
    @IBInspectable
    public var tagMainTextColor : UIColor = UIColor.whiteColor()
    @IBInspectable
    public var tagSecondBackColor : UIColor = UIColor.lightGrayColor()
    @IBInspectable
    public var tagSecondTextColor : UIColor = UIColor.darkTextColor()
    @IBInspectable
    public var tagCornerRadiusToHeightRatio :CGFloat = CGFloat(0.2){
        didSet{
            for tag in tags{
                tag.layer.cornerRadius = tag.frame.height * tagCornerRadiusToHeightRatio
            }
            layoutIfNeeded()
        }
    }
    
    
    var tags : [HTag] = []{
        didSet{
            layoutSubviews()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Set Tags
//    public func setTags(tags : [HTag]){
//        self.tags = tags
//    }
    
//    public func addTags(tags: [HTag]){
//        self.tags.appendContentsOf(tags)
//        for tag in tags{
//            self.addSubview(tag)
//            tag.delegate = self
//        }
//        layoutIfNeeded()
//    }

    public func addTagsWithTitle(titles: [String]){
        for title in titles{
            let tag = HTag()
            tag.delegate = self
            switch type {
            case .Cancel:
                tag.withCancelButton = true
                tag.selected = false
            case .MultiSelect:
                tag.withCancelButton = false
                tag.selected = true
            }
            tag.setBackColors(tagMainBackColor, secondColor: tagSecondBackColor)
            tag.setTextColors(tagMainTextColor, secondColor: tagSecondTextColor)
            tag.layer.cornerRadius = tag.frame.height * tagCornerRadiusToHeightRatio
            tag.tagString = title
            addSubview(tag)
            tags.append(tag)
        }
        layoutIfNeeded()
    }
    
    override public func layoutSubviews() {
        var x = marg
        var y = marg
        for index in 0..<tags.count{
            if tags[index].frame.width + x > frame.width - marg{
                y += tags[index].frame.height + btwLines
                x = marg
            }
            tags[index].frame.origin = CGPoint(x: x, y: y)
            x += tags[index].frame.width + btwTags
        }
        self.contentSize = CGSize(width: self.frame.width, height: y + (tags.last?.frame.height ?? 0) + marg )
    }

    
    // MARK: - Tag Delegate
    func tagCancelled(sender: HTag) {
        if let index = tags.indexOf(sender){
            tags.removeAtIndex(index)
            sender.removeFromSuperview()
        }
    }
    func tagClicked(sender: HTag){
        print("\(tags.indexOf(sender))CLICKED")
        if type == .MultiSelect{
            sender.selected = !sender.selected
        }
    }

}

public enum HTagViewType{
    case Cancel, MultiSelect
}