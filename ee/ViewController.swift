//
//  ViewController.swift
//  ee
//
//  Created by Admin on 11/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var graphOutlet: HeartRateGraph!
    
    @IBOutlet weak var tvHrOutlet: NSTextField!
    
    @IBAction func onEnter(_ sender: NSTextField) {
        guard let num = Double(tvHrOutlet.stringValue) else {
            return
        }
        if num < 40 {
            self.tvHrOutlet.stringValue = "40"
        }
        if num > 200 {
            self.tvHrOutlet.stringValue = "200"
        }
        guard let hrNum = Double(tvHrOutlet.stringValue) else {
            return
        }
        graphOutlet.setAmplitude(hrNum)
    }
    
    var i = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        graphOutlet.initChart()
        graphOutlet.startDraw()
        let onlyIntFormatter = OnlyIntegerValueFormatter()
        tvHrOutlet.formatter = onlyIntFormatter
        tvHrOutlet.delegate = self
    }

    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

extension ViewController:NSTextFieldDelegate {
    //    func controlTextDidChange(_ obj: Notification) {
    //        if let textField = obj.object as? NSTextField, self.tvHrOutlet.identifier == textField.identifier {
    //            guard let num = Float(textField.stringValue) else {
    //                return
    //            }
    //        }
    //    }
}
import Foundation

class OnlyIntegerValueFormatter: NumberFormatter {
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        if partialString.isEmpty {
            return true
        }
        return  Double(partialString) != nil
    }
}
