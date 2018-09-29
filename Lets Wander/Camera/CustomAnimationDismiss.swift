//
//  CustomAnimationDismiss.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/28/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit

//Custom Animation Controller to present the view
class CustomAnimationDismiss: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //My custom animation logic
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        
        guard let toView = transitionContext.view(forKey: .to) else {return}
        containerView.addSubview(toView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            //Animation
            fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
        
    }
}

