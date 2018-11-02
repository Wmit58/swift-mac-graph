////
////  Graph.swift
////  ee
////
////  Created by Admin on 11/1/18.
////  Copyright © 2018 Admin. All rights reserved.
////
//
//import Cocoa
//
//class Graph: NSView {
//    //    func debug(){
//    //        if holeRect.count > 0{
//    //            var str = ""
//    //            for i in 0 ..< holeRect.count{
//    //                str = "\(str)\(holeRect[i]),"
//    //            }
//    //            str = "\(str)\(holeRect.first!), \(holeRect.last!)"
//    //            print(str)
//    //        }
//    //    }
//    var mGraphMax = 150
//    
//    var mWindowSize = 640
//    var updateInterval:Double = 30
//    var lineColor: NSColor = NSColor.init(0x3CB878)
//    
//    func setWindowSize(_ size: Int) {
//        mWindowSize = size
//    }
//    
//    func setColor(lineColor: NSColor) {
//        self.lineColor = lineColor
//    }
//    
//    var drawQueue = [Twice]()
//    
//    func simulate() {
//        drawQueue = updateData()
//        setNeedsDisplay(self.bounds)
//    }
//    
//    var timer: Timer = Timer()
//    
//    func startDraw() {
//        //        timer = Timer.scheduledTimer(withTimeInterval: 0.002, repeats: true, block: { _ in
//        timer = Timer.scheduledTimer(withTimeInterval: updateInterval / 1000, repeats: true, block: { _ in
//            self.simulate()
//        })
//        timer.fire()
//    }
//    
//    func stopDraw() {
//        timer.invalidate()
//    }
//    
//    func initChart() {
//        self.layer?.backgroundColor = NSColor.white.cgColor
//        for i in 0..<Plot.count{
//            Plot[i] = 100 - Plot[i]
//        }
//    }
//    
//    override func draw(_ rect: CGRect) {
//        
//        
//        let width: Int = Int(bounds.width)
//        let height: Int = Int(bounds.height)
//        let mapRatio = Double(width) / Double(mWindowSize)
//        
//        var start = drawQueue[0]
//        // Drawing code
//        let aPath = NSBezierPath()
//        aPath.lineWidth = 2
//        
//        aPath.move(to: CGPoint(x: Int(Double(start.x!) * mapRatio), y: -50 + height - Int(start.y! * Double(height) / Double(mGraphMax))))
//        if(drawQueue.count < 2){return}
//        
//        
//        for i in 1 ..< drawQueue.count-1 {
//            if start.y != nil && drawQueue[i+1].y != nil{
//                //                    aPath.move(to: CGPoint(x: Int(Double(start.x!) * mapRatio), y: -50 + height - Int(start.y! * Double(height) / Double(mGraphMax))))
//                aPath.line(to: CGPoint(x: Int((Double(drawQueue[i + 1].x!)) * mapRatio), y: -50 +  height - Int(drawQueue[i+1].y! * Double(height) / Double(mGraphMax))))
//                //                    prev =  -50 +  height - Int(drawQueue[i+1].y! * Double(height) / Double(mGraphMax))
//            }else{
//                //                    aPath.move(to: CGPoint(x: Int((Double(drawQueue[i + 1].x!)) * mapRatio), y: prev ))
//            }
//            
//            start = drawQueue[i]
//        }
//        
//        lineColor.set()
//        aPath.stroke()
//        
//        var holeRect = [Int]()
//        for index in 0 ..< drawQueue.count {
//            if (nCurrentPoint < drawQueue[index].x! && nCurrentPoint + 15 >= drawQueue[index].x!) {
//                //                drawQueue[index].y = nil
//                holeRect.append(index)
//            }
//        }
//        if holeRect.count > 0{
//            let drect = CGRect(x: Int(Double(holeRect.first!) * mapRatio), y: 0, width: Int(Double(holeRect.last! - holeRect.first!) * mapRatio), height: height)
//            let bpath: NSBezierPath = NSBezierPath(rect: drect)
//            NSColor(0x000000).set()
//            bpath.fill()
//            bpath.stroke()
//        }
//    }
//    //    var prev = 0
//    var Plot = [0, 0, 7, 0, 0, 0, -10, 30, 70, -20, 0, 0, 0, 0, 0, 10, 15, 17, 15, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
//                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
//    ]
//    var data = [Twice]()
//    var totalPoints = 640
//    var nCurrentPoint:Double = 0
//    var nAddPoint = 2.857
//    var nPlotPoint = 0
//    var nDataPoint = 0
//    var nPlotSize = 32
//    var nSpace = 10
//    var nAmplitude = 70
//    var fillchart = false
//    
//    
//    func updateData() -> [Twice]{
//        
//        if (fillchart) {
//            var index = 0
//            while (index < data.count){
//                if (nCurrentPoint <= data[index].x! && Double(nCurrentPoint) + nAddPoint >= Double(data[index].x!)) {
//                    //    data.splice(index, 1)
//                    data.remove(at: index)
//                    index = index - 1
//                }
//                index = index + 1
//            }
//            
//            data.insert(Twice(nCurrentPoint, Double(Plot[nPlotPoint])), at:nDataPoint)
//            
//            nDataPoint = nDataPoint + 1
//            holeRect.removeAll()
//            for index in 0 ..< data.count {
//                if (nCurrentPoint < data[index].x! && nCurrentPoint + 15 >= data[index].x!) {
//                    data[index].y = nil
//                    holeRect.append(index)
//                }
//            }
//        } else {
//            data.append(Twice(nCurrentPoint, Double(Plot[nPlotPoint])))
//        }
//        
//        nCurrentPoint = nCurrentPoint + nAddPoint
//        nPlotPoint = nPlotPoint + 1
//        
//        if (nPlotPoint >= nPlotSize) {
//            nPlotPoint = 0
//            let n = nAmplitude / 10
//            nAddPoint = Double(640) / (Double(n) * Double(nPlotSize))
//            updateInterval = Double(200) / Double( n)
//            nSpace = n
//        }
//        
//        if (nCurrentPoint >= Double(totalPoints)){
//            nCurrentPoint = 0
//            nDataPoint = 0
//            fillchart = true
//        }
//        //        print(data.count, Plot.count)
//        return data
//    }
//}
//
//class Twice{
//    var x : Double?
//    var y : Double?
//    init(_ x:Double,_ y: Double){
//        self.x = x
//        self.y = y
//    }
//}
//
//
//
//
//
