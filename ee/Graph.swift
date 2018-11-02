//
//  Graph.swift
//  ee
//
//  Created by Admin on 11/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Cocoa

class Graph: NSView {
    // max graph value
    var mGraphMax = 2500
    var mRedrawInterval = 50
    var mRedrawPoints = 0
    
    var mWindowSize = 500
    var ONEWINDOW = 240
    
    var mInputBuf = [Int]()
    var mDrawingBuf = [Int]()
    var isFirst = true
    var mDrawPosition = 0
    
    var isConnected = true
    var lineColor: NSColor = NSColor.green
    func setWindowSize(_ size: Int) {
        mWindowSize = size
        ONEWINDOW = size / 4
    }
    
    func setColor(lineColor: NSColor) {
        self.lineColor = lineColor
    }
    
    func simulate() {
        if !isConnected {
            return
        }
        
        if mInputBuf.count < ONEWINDOW {
            return
        }
        
        if mInputBuf.count > ONEWINDOW {
            mRedrawPoints = mRedrawPoints + 1
        }
        
        if mInputBuf.count <= ONEWINDOW {
            mRedrawPoints = ONEWINDOW / (1000 / mRedrawInterval)
        }
        
        for _ in 0 ..< mRedrawPoints {
            let val = mInputBuf.first
            if mInputBuf.count > 0 {
                mInputBuf.remove(at: 0)
            }
            if mDrawingBuf.count > mDrawPosition {
                mDrawingBuf.remove(at: mDrawPosition)
            }
            if val != nil {
                mDrawingBuf.insert(val!, at: mDrawPosition)
            }
            
            mDrawPosition += 1
            
            if mDrawPosition >= mWindowSize {
                mDrawPosition = 0
            }
        }
        setNeedsDisplay(self.bounds)
        print(self.bounds)
    }
    
    var timer: Timer = Timer()
    func startDraw() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.002, repeats: true, block: { _ in
            self.simulate()
        })
        timer.fire()
    }
    
    func stopDraw() {
        timer.invalidate()
    }
    
    func initChart() {
        mRedrawPoints = ONEWINDOW / (1000 / mRedrawInterval)
        
        for _ in 0 ..< mWindowSize {
            mDrawingBuf.append(1250)
        }
    }
    
    func setPoint(arr: [Int]) {
        mDrawingBuf = arr
        setNeedsDisplay(self.bounds)
    }
    
    func addEcgData(data: Int) {
        mInputBuf.append(data)
        //        print("datasize", mInputBuf.count, mDrawingBuf.count)
        //        if(mInputBuf.count > 1000){
        //            mInputBuf.removeAll()
        //        }
    }
    
    var isStart = true
    func serVertical() {
        isVertical = true
    }
    
    var isVertical = false
    override func draw(_ rect: CGRect) {
        if mDrawingBuf.count < mWindowSize {
            return
        }
        if isVertical {
            drawVertical(rect)
            return
        }
        
        let width: Int = Int(bounds.width)
        let height: Int = Int(bounds.height)
        let mapRatio = Double(width) / Double(mWindowSize)
        
        var start: Int = mDrawingBuf[0]
        // Drawing code
        let aPath = NSBezierPath()
        aPath.lineWidth = 2
        //        aPath.move(to: CGPoint(x:0, y:0))
        
        for i in 1 ..< mWindowSize {
            aPath.move(to: CGPoint(x: Int(Double(i) * mapRatio), y: height - Int(start * height / mGraphMax)))
            aPath.line(to: CGPoint(x: Int((Double(i + 1)) * mapRatio), y: height - Int(mDrawingBuf[i] * height / mGraphMax)))
            start = mDrawingBuf[i]
        }
        
        aPath.close()
        
        lineColor.set()
        aPath.stroke()
        
        //        aPath.fill()
        if isStart {
            isStart = false
        } else {
            let drect = CGRect(x: Int(Double(mDrawPosition - 10) * mapRatio), y: 0, width: 19, height: height)
            let bpath: NSBezierPath = NSBezierPath(rect: drect)
            NSColor.white.set()
            bpath.fill()
            bpath.stroke()
        }
    }
    
    func drawVertical(_: CGRect) {
        if mDrawingBuf.count < mWindowSize {
            return
        }
        
        let width: Int = Int(bounds.width)
        let height: Int = Int(bounds.height)
        let mapRatio = Double(height) / Double(mWindowSize)
        
        var start: Int = mDrawingBuf[0]
        // Drawing code
        let aPath = NSBezierPath()
        aPath.lineWidth = 2
        //        aPath.move(to: CGPoint(x:0, y:0))
        
        for i in 1 ..< mWindowSize {
            aPath.move(to: CGPoint(x: Int(start * width / mGraphMax), y: Int(Double(i) * mapRatio)))
            aPath.line(to: CGPoint(x: Int(mDrawingBuf[i] * width / mGraphMax), y: Int((Double(i + 1)) * mapRatio)))
            start = mDrawingBuf[i]
        }
        
        aPath.close()
        
        lineColor.set()
        aPath.stroke()
        
        if isStart {
            isStart = false
        } else {
            let drect = CGRect(x: 0, y: Int(Double(mDrawPosition - 10) * mapRatio), width: height, height: 15)
            let bpath: NSBezierPath = NSBezierPath(rect: drect)
            NSColor.black.set()
            bpath.fill()
            bpath.stroke()
        }
    }
}

