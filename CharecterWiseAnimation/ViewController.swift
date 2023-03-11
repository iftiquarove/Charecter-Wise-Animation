//
//  ViewController.swift
//  CharecterWiseAnimation
//
//  Created by Iftiquar Ahmed Ove on 11/3/23.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var animatedView: UIView!    
    var textLayer = SegmentedTextLayer()

    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        var attributedString = NSAttributedString(string:"Hello Devs", attributes:
                                                    [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                     NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30),
                                                     NSAttributedString.Key.paragraphStyle: style as Any])
        textLayer.attributedText = attributedString
        animatedView.layer.addSublayer(textLayer)
        
        let layerWidth = attributedString.size().width + 20
        let layerHeight = attributedString.size().height + 20
        
        let posX = animatedView.frame.width/2 - layerWidth/2
        let posY = animatedView.frame.height/2 - layerHeight/2
        
        textLayer.frame = CGRect(x: posX, y: posY, width: layerWidth, height: layerHeight)
    }
    
    func addAnimation(){
        var beginTime = CACurrentMediaTime() + 0.1
        textLayer.segmentedTextLayers.forEach { layer in
            
            // To make each layer scaled to zero initially
            layer.removeAllAnimations()
            layer.transform = CATransform3DMakeScale(0, 0, 1.0)
            
            //apply animation to each layer seperately with a separate begin time, each animation will start after the prev ends
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.beginTime = beginTime
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 0.1
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            layer.add(animation, forKey: UUID().uuidString)
            beginTime = beginTime + animation.duration
        }
    }

    //MARK: -Button Actions
    @IBAction func startAnimationTapped(_ sender: Any) {
        addAnimation()
    }
}

