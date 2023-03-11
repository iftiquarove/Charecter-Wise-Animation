//
//  SegmentedTextLayer.swift
//  CharecterWiseAnimation
//
//  Created by Iftiquar Ahmed Ove on 11/3/23.
//

import UIKit

public class SegmentedTextLayer: CALayer, NSLayoutManagerDelegate {
    private let textStorage: NSTextStorage = NSTextStorage()
    private let layoutManager: NSLayoutManager = NSLayoutManager()
    private let textContainer: NSTextContainer = NSTextContainer()
    private var textSize: CGSize = CGSize.zero
    
    //This is the array of CATextLayer where each charecter will be found.
    public private(set) var segmentedTextLayers: [CATextLayer] = []

    public var attributedText: NSAttributedString {
        get {
            return textStorage as NSAttributedString
        }
        set {
            textStorage.setAttributedString(newValue)
        }
    }
    
    public override var bounds: CGRect {
        get {
            super.bounds
        }
        set {
            textContainer.size = newValue.size
            super.bounds = newValue
        }
    }

    public override init() {
        super.init()
        setupTextkit()
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
        setupTextkit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    private func setupTextkit() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        layoutManager.delegate = self
        textContainer.size = CGSize.zero
    }

    private func updateAnimationLayers() {
        if textContainer.size.equalTo(CGSize.zero) || attributedText.length == 0 {
            return
        }

        // Remove old animation layers
        for layer in segmentedTextLayers {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        segmentedTextLayers.removeAll()
        self.removeAllAnimations()
        
        // Split letters or words to generate corresponding layers
        let string = attributedText.string
        string.enumerateSubstrings(in: string.startIndex..<string.endIndex, options: .byComposedCharacterSequences) { [weak self] (subString, substringRange, _, _) in
            guard let self = self else { return }
            
            let glyphRange = NSRange(substringRange, in: string)
            let textRect = self.layoutManager.boundingRect(forGlyphRange: glyphRange, in: self.textContainer)
            let textLayer = CATextLayer()
            textLayer.frame = textRect
            textLayer.string = self.attributedText.attributedSubstring(from: glyphRange)
            self.segmentedTextLayers.append(textLayer)
            self.addSublayer(textLayer)
        }
    }
    
    // MARK: - NSLayoutManagerDelegate
    public func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool){
        guard let _ = textContainer else { return}
        updateAnimationLayers()
    }
}
