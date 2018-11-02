//
//  ViewController.swift
//  ee
//
//  Created by Admin on 11/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var graphOutlet: Graph!
    var i = 0.1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        graphOutlet.initChart()
        graphOutlet.startDraw()
        
        Timer.scheduledTimer(withTimeInterval: 0.0001, repeats: true, block: { _ in
            self.graphOutlet.addEcgData(data: 600 + Int(sin(Double(self.i)) * Double(400)))
            self.i = self.i + 0.1
        }).fire()
    }
    
    override func viewWillAppear() {
        self.view.layer?.backgroundColor = NSColor.white.cgColor
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

