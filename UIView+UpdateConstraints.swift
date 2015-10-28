
import UIKit

extension UIView
{
    func setConstraintConstant(constant: CGFloat,
        forAttribute attribute: NSLayoutAttribute) -> Bool
    {
        if let constraint = constraintForAttribute(attribute) {
            constraint.constant = constant
            return true
        }
        else {
            superview?.addConstraint(NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: .Equal,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1.0, constant: constant))
            return false
        }
    }
    
    func constraintConstantforAttribute(attribute: NSLayoutAttribute) -> CGFloat?
    {
        if let constraint = constraintForAttribute(attribute) {
            return constraint.constant
        }
        else {
            return nil
        }
    }
    
    func constraintForAttribute(attribute: NSLayoutAttribute) -> NSLayoutConstraint?
    {
        return superview?.constraints.filter({
            $0.firstAttribute == attribute && ($0.firstItem as! UIView) == self
        }).first
    }
    
    func hideView(hidden:Bool, byAttribute attribute: NSLayoutAttribute)
    {
        if self.hidden != hidden {
            let constraintConstant = constraintConstantforAttribute(attribute)
            
            if (hidden)
            {
                if let constant = constraintConstant {
                    self.alpha = constant;
                }
                else {
                    let size = getSize()
                    self.alpha = (attribute == .Height) ? size.height : size.width;
                }
                
                setConstraintConstant(0, forAttribute: attribute)
                self.hidden = true
            }
            else
            {
                if constraintConstant != nil {
                    self.hidden = false
                    setConstraintConstant(alpha, forAttribute: attribute)
                    alpha = 1
                }
            }
        }
    }
    
    func hideByHeight(hidden: Bool)
    {
        hideView(hidden, byAttribute: NSLayoutAttribute.Height)
    }
    
    func hideByWidth(hidden: Bool)
    {
        hideView(hidden, byAttribute: NSLayoutAttribute.Width)
    }
    
    func getSize() -> CGSize
    {
        updateSizes()
        return CGSizeMake(bounds.size.width, bounds.size.height)
    }
    
    func sizeToSubviews()
    {
        updateSizes()
        let fittingSize = self.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        self.frame = CGRectMake(0, 0, 320, fittingSize.height)
    }
    
    func updateSizes()
    {
        setNeedsLayout()
        layoutIfNeeded()
    }
}
