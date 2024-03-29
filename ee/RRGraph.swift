//
//  Graph.swift
//  ee
//
//  Created by Admin on 11/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Cocoa

class RRGraph: NSView {
    var mGraphMax = 150
    
    var mWindowSize = 640
    var updateInterval : Double = 20
    var lineColor: NSColor = NSColor.init(0x3CB878)
    
    var Plot = [13, 22.5, 30.5, 37, 43, 47, 50, 51.5, 51, 49, 46, 43, 39, 33, 24, 15.5, 12, 10, 8, 6, 4.5, 3.5, 3, 2.5, 2, 1.5, 1, 0.5, 0, 0, 2.5, 7]
    
    var data = [Point]()
    var totalPoints = 640
    var nCurrentPoint:Double = 0
    var nAddPoint:Double = 1
    var nPlotPoint = 0
    var nDataPoint = 0
    
    var nSpace = 10
    var nAmplitude:Double = 50
    var fillchart = false
    
    func setWindowSize(_ size: Int) {
        mWindowSize = size
    }
    
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
    }
    
    override func draw(_ rect: CGRect) {
        
        if(drawQueue.count < 2){ return }
        
        let width: Int = Int(bounds.width)
        let height: Int = Int(bounds.height)
        let mapRatio = Double(width) / Double(mWindowSize)
        
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
        
        if (fillchart) {
            var index = 0
            while (index < data.count){
                if (nCurrentPoint <= data[index].x && Double(nCurrentPoint) + nAddPoint >= Double(data[index].x)) {
                    data.remove(at: index)
                    index = index - 1
                }
                index = index + 1
            }
            
            data.insert(Point(nCurrentPoint, Double(Plot[nPlotPoint])), at:nDataPoint)
            
            nDataPoint = nDataPoint + 1
            
            for index in 0 ..< data.count {
                if (nCurrentPoint < data[index].x && nCurrentPoint + 15 >= data[index].x) {
                    data[index].y = -1
                }
            }
        } else {
            data.append(Point(nCurrentPoint, Double(Plot[nPlotPoint])))
        }
        
        nCurrentPoint = nCurrentPoint + nAddPoint
        nPlotPoint = nPlotPoint + 1
        
        if (nPlotPoint == 32) {
            nPlotPoint = 0
            let n = nAmplitude / Double(10)
            nAddPoint = 640 / (nAmplitude / 2.5 * 32);
            updateInterval = Double(200) / Double( n)
            nSpace = Int(n)
        }
        
        if (nCurrentPoint >= Double(totalPoints)){
            nCurrentPoint = 0
            nDataPoint = 0
            fillchart = true
        }
        print(data.count)
        return data
    }
    
    func setAmplitude(_ hr:Double){
        nAmplitude = hr
    }
}
