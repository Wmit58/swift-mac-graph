//
//  Graph.swift
//  ee
//
//  Created by Admin on 11/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Cocoa

class HeartRateGraph1: NSView {
    var mGraphMax = 150
    
    var mWindowSize = 640
    var updateInterval : Double = 30
    var lineColor: NSColor = NSColor.init(0x3CB878)
    
    var Plot = [0, 0, 7, 0, 0, 0, -10, 30, 70, -20, 0, 0, 0, 0, 0, 10, 15, 17, 15, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ]
    
    var data = [Point]()
    var totalPoints = 640
    var nCurrentPoint:Double = 0
    var nAddPoint = 2.857
    var nPlotPoint = 0
    var nDataPoint = 0
    var nPlotSize = 32
    var nSpace = 10
    var nAmplitude:Double = 70
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
        
        if (nPlotPoint >= nPlotSize) {
            nPlotPoint = 0
            let n = nAmplitude / Double(10)
            nAddPoint = Double(640) / (Double(n) * Double(nPlotSize))
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
        repeat {
            if (nAmplitude == 40) {
                nPlotSize = 50;
                break;
            }
            if (nAmplitude <= 50) {
                nPlotSize = 40;
                break;
            }
            if (nAmplitude <= 60) {
                nPlotSize = 35;
                break;
            }
            if (nAmplitude <= 70) {
                nPlotSize = 32;
                break;
            }
            if (nAmplitude <= 120) {
                nPlotSize = Int(32.0 - (nAmplitude - 70.0) / 10.0);
                break;
            }
            if (nAmplitude <= 200) {
                nPlotSize = Int(32.0 - (nAmplitude - 70.0) / 20.0);
                break;
            }
        } while (false);
    }
}

class Point {
    var x : Double = 0
    var y : Double = 0
    init(_ x:Double,_ y: Double){
        self.x = x
        self.y = y
    }
}






