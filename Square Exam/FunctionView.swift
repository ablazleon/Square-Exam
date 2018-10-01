//
//  FunctionView.swift
//  Square Exam
//
//  Created by Adrian on 01/10/2018.
//  Copyright © 2018 Adrián Blázquez León. All rights reserved.
//

import UIKit

@IBDesignable
class FunctionView: UIView {

    // Point
    struct Point {
        var x = 0.0
        var y = 0.0
    }
    

    @IBInspectable
    var color: UIColor = .red
    
    @IBInspectable
    var lw : Double = 1.0
    
    //Number of points per unit represented
    @IBInspectable
    var scaleX: Double = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scaleY: Double = 1.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var textX: String = "x"
    
    @IBInspectable
    var textY: String = "y"
    
    @IBInspectable
    lazy var side: Double = (0.9)*Double(min(xmax, ymax))
    // So it can be seen in all the window
    
    // It is created an atribute, so to use the functions that matchees.
//    weak var dataSource: FunctionViewDataSource!
    
    
    // Bounds defined as atribute
    lazy var xmax = bounds.size.width
    lazy var ymax = bounds.size.height
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawAxis()
        drawSquare()
        drawTicks()
        drawText()
    }
    /** Draw the axis in the UIView
     */
    
    private func drawAxis(){
        
        // let xmax = bounds.size.width
        // let ymax = bounds.size.height
        
        let xaxis = UIBezierPath()
        let yaxis = UIBezierPath()
        
        xaxis.move(to: CGPoint(x:0, y:(ymax/2)))
        xaxis.addLine(to: CGPoint(x:xmax, y:(ymax/2)))
        
        yaxis.move(to: CGPoint(x:(xmax/2), y:0))
        yaxis.addLine(to: CGPoint(x:(xmax/2), y:ymax))
        
        UIColor.black.setStroke()
        xaxis.lineWidth = CGFloat(lw)
        xaxis.stroke()
        
        UIColor.black.setStroke()
        yaxis.lineWidth = CGFloat(lw)
        yaxis.stroke()
    }
    /** Draw ticks
     */
    private func drawTicks() {
        
        let numberOfTicks = 8.0
        
        UIColor.black.set()
        
        let ptsYByTick = Double(bounds.size.height) / numberOfTicks
        let unitsYByTick = (ptsYByTick / scaleY).roundedOneDigit
        for y in stride(from: -numberOfTicks * unitsYByTick, to: numberOfTicks * unitsYByTick, by: unitsYByTick){
            let px = centerX(0)
            let py = centerY(y)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px - 2, y: py))
            path.addLine(to: CGPoint(x: px+2, y: py))
            
            path.stroke()
        }
        
        let ptsXByTick = Double(bounds.size.width) / numberOfTicks
        let unitsXByTick = (ptsXByTick / scaleX).roundedOneDigit
        for x in stride(from: -numberOfTicks * unitsXByTick, to: numberOfTicks * unitsXByTick, by: unitsXByTick){
            let px = centerX(x)
            let py = centerY(0)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: px , y: py-2))
            path.addLine(to: CGPoint(x: px, y: py+2))
            
            path.stroke()
        }
    }
    /** Draw the text */
    private func drawText() {
        //Is not seen
        // let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)]
        
        let attrs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        
        let offset: CGFloat = 4 // Separation from the text to teh bounds
        
        // It is chosen the texts according to the type of dataSOurce
        
        
        let asX = NSAttributedString(string: textX, attributes: attrs)
        let sizeX = asX.size()
        let posX = CGPoint(x: xmax - sizeX.width - offset, y: ymax/2 + offset)
        asX.draw(at: posX)
        
        
        
        let asY = NSAttributedString(string: textY, attributes: attrs)
        let posY = CGPoint(x: xmax - offset, y: ymax/2 + offset)
        asY.draw(at: posY)
        
    }
    
    /** Draw Square */
    func drawSquare() {
        
        let squarePath = UIBezierPath()
        let startX = Double(xmax/2) - side/2
        let startY = Double(ymax/2) - side/2
        squarePath.move(to: CGPoint(x: startX, y: startY))
        
        // squarePath.addLine(to: squarePath.currentPoint)
        squarePath.addLine(to: CGPoint(x: startX + side, y: startY))
        squarePath.addLine(to: CGPoint(x: startX + side, y: startY + side))
        squarePath.addLine(to: CGPoint(x: startX, y: startY + side))
        squarePath.close()
        color.set()
        squarePath.stroke()
        
    }
    
    
    // It must be translated the coordinates found by the CubeModel to teh UIView: just centering in the point (xmax/2, ymax/2)
    private func centerX(_ x: Double) -> Double {
        return (Double(x) + Double(xmax/2))
    }
    private func centerY(_ y: Double) -> Double {
        return (Double(y) + Double(ymax/2))
    }
    
}

extension Double{
    var roundedOneDigit: Double {
        get {
            var d = self
            var by = 1.0
            
            while d > 10 {
                d /= 10
                by = by * 10
            }
            while d < 1{
                d *= 10
                by = by / 10
            }
            return d.rounded() * by
        }
    }
}
