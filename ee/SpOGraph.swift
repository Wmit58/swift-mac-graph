//
//  Graph.swift
//  ee
//
//  Created by Admin on 11/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Cocoa

class HeartRateGraph: NSView {
    var mGraphMax = 6000
    
    var updateInterval : Double = 30
    var lineColor: NSColor = NSColor.init(0x3CB878)
    
    var Plot = [0, 2, 5, 8, 13, 19, 27, 31, 33, 32, 30, 27, 24, 20, 17, 16, 16.5, 17.5, 18.5, 19, 18, 16, 13, 9, 4, 2, 1, 0.5, 0]
    
    var data = [Point]()
    var totalPoints = 203
    var nCurrentPoint:Int = 0

    var nPlotPoint = 0
    var nSpace = 10
    var nAmplitude:Double = 100
    var n:Double = 100
    
    func setColor(lineColor: NSColor) {
        self.lineColor = lineColor
    }
    
    var drawQueue = [Point]()
    
    func simulate() {
        drawQueue = updateData()
        setNeedsDisplay(self.bounds)
    }
    
    override func viewWillDraw() {
        layer?.backgroundColor = NSColor.white.cgColor
    }
    
    var timer: Timer = Timer()
    
    func startDraw() {
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval / 1000, repeats: true, block: { _ in
            self.simulate()
        })
        timer.fire()
    }
    
    func stopDraw() {
        timer.invalidate()
    }
    
    func initChart() {
        self.layer?.backgroundColor = NSColor.white.cgColor
        for i in 0..<Plot.count{
            Plot[i] = 100 - Plot[i]
        }
        for i in 0..<totalPoints{
            data.append(Point(Double(i), -1))
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if(drawQueue.count < 2){ return }

        let width: Int = Int(bounds.width)
        let height: Int = Int(bounds.height)
        let mapRatio = Double(width) / Double(totalPoints)
        
        // Drawing code
        let aPath = NSBezierPath()
        aPath.lineWidth = 2
        
        for i in 0 ..< drawQueue.count-1 {
            if drawQueue[i].y == -1 || drawQueue[i+1].y == -1 {
                continue
            }
            let fromX = Int(Double(drawQueue[i].x) * mapRatio)
            let toX   = Int(Double(drawQueue[i+1].x) * mapRatio)
            
            let fromY =  -50 + height - Int(drawQueue[i].y * Double(height) / Double(mGraphMax))
            let toY   =  -50 + height - Int(drawQueue[i+1].y * Double(height) / Double(mGraphMax))
            
            aPath.move(to: CGPoint(x: fromX, y: fromY))
            aPath.line(to: CGPoint(x: toX  , y: toY))
            
        }
        
        lineColor.set()
        aPath.stroke()
    }
    
    private func updateData() -> [Point]{
//        if(data.count < nCurrentPoint + 1){
//            data.append(Point(Double(nCurrentPoint), Plot[nPlotPoint] * n))
//        }else{
        data[nCurrentPoint] = Point(Double(nCurrentPoint), Plot[nPlotPoint] * n)
//        }
        
        
        for i in 1..<5 {
            var nPont = nCurrentPoint + i
            if (nPont >= totalPoints) {nPont = nPont - totalPoints}
            data[nPont].y = -1
        }
       
        nCurrentPoint = nCurrentPoint + 1
        nPlotPoint = nPlotPoint + 1
        
        if (nPlotPoint == 29) {
            nPlotPoint = 0
            n = nAmplitude
        }
        if (nCurrentPoint == totalPoints) { nCurrentPoint = 0 }
        print(data.count)
        return data
    }
    
    func setAmplitude(_ hr:Double){
        nAmplitude = hr
    }
}

