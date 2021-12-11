//
//  ViewController.swift
//  GMCflip
//
//  Created by Matsui Keiji on 2018/09/05.
//  Copyright © 2018年 Matsui Keiji. All rights reserved.
//

import UIKit

extension String{
    mutating func decimal(){
        if self.count == 0{
            self = "0."
        }
        else if self.range(of: ".") == nil{
            self.append(".")
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var A:UITextField!
    @IBOutlet var B:UITextField!
    @IBOutlet var C:UITextField!
    @IBOutlet var D:UITextField!
    @IBOutlet var VY:UITextField!
    @IBOutlet var RUN:UIButton!
    @IBOutlet var Decimal:UIButton!
    @IBOutlet var MinusBar:UIButton!
    @IBOutlet var Doverk:UILabel!
    @IBOutlet var Fugo:UILabel!
    @IBOutlet var Fugo2:UILabel!
    @IBOutlet var initialSlope:UILabel!
    @IBOutlet var kValue:UILabel!
    @IBOutlet var minuskValue:UILabel!
    @IBOutlet var GompExBoundary:UILabel!
    @IBOutlet var Ftx:UILabel!
    @IBOutlet var TimeToY:UILabel!
    @IBOutlet var GMI:UILabel!
    @IBOutlet var minimalValue:UILabel!
    @IBOutlet var secondSlope:UILabel!
    @IBOutlet var Intercept:UILabel!
    @IBOutlet var T0:UITextField!
    @IBOutlet var T1:UITextField!
    @IBOutlet var T2:UITextField!
    @IBOutlet var T3:UITextField!
    @IBOutlet var Tx:UITextField!
    @IBOutlet var clearButton:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        T0.becomeFirstResponder()
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func myActionRUN(){
        var vT0 = 0.0
        if let i = Double(T0.text!){
            vT0 = i
        }
        var vT1 = 0.0
        if let i = Double(T1.text!){
            vT1 = i
        }
        var vT2 = 0.0
        if let i = Double(T2.text!){
            vT2 = i
        }
        var vT3 = 0.0
        if let i = Double(T3.text!){
            vT3 = i
        }
        var vTx = 0.0
        if let i = Double(Tx.text!){
            vTx = i
        }
        var vA = 0.0
        if let i = Double(A.text!){
            vA = i
        }
        var vB = 0.0
        if let i = Double(B.text!){
            vB = i
        }
        var vC = 0.0
        if let i = Double(C.text!){
            vC = i
        }
        var vD = 0.0
        if let i = Double(D.text!){
            vD = i
        }
        var vVY = 0.0
        if let i = Double(VY.text!){
            vVY = i
        }
        let AB = (vB - vA)/(vT1 - vT0)
        let BC = (vC - vB)/(vT2 - vT1)
        let CD = (vD - vC)/(vT3 - vT2)
        var vB2upper = (vA + vC)/2
        var vB2lower = vC
        var vB2 = (vB2upper + vB2lower)/2
        var m = 0.0
        var k = 0.0
        var vBx = 0.0
        if vT1 <= vT0 || vT2 <= vT1 || AB * BC <= 0 || AB >= 0 || BC >= 0 {
            let titleString = "Please change values."
            let messageString = "t0<t1<t2 and A>B>C"
            let alert: UIAlertController = UIAlertController(title:titleString,message: messageString,preferredStyle: UIAlertController.Style.alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK",style: UIAlertAction.Style.default,handler:{(action:UIAlertAction!) -> Void in
            })
            alert.addAction(okAction)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }//if vT1 <= vT0 || vT2 <= vT1 || AB * BC <= 0 || AB >= 0 || BC >= 0
        else if AB >= BC{
            let titleString = "Please change values."
            let messageString = "Slope AB should be steeper than slope BC."
            let alert: UIAlertController = UIAlertController(title:titleString,message: messageString,preferredStyle: UIAlertController.Style.alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK",style: UIAlertAction.Style.default,handler:{(action:UIAlertAction!) -> Void in
            })
            alert.addAction(okAction)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }//else if AB >= BC
        else{
            view.endEditing(true)
            for _ in 0 ..< 100{
                m = (vA * vC - vB2 * vB2)/(vA - 2 * vB2 + vC)
                k = -1.0/((vT2 - vT0)/2) * log((vB2 - vC)/(vA - vB2))
                vBx = m + (vA - m) * exp(-k * (vT1 - vT0))
                if vBx == vB{
                    break
                }
                else if vB > vBx{
                    vB2lower = vB2
                }
                else if vB < vBx{
                    vB2upper = vB2
                }
                vB2 = (vB2upper + vB2lower)/2.0
            }//for _ in 0 ..< 100
            var vA0 = m + (vA - m) * exp(-k * (-vT0))
            var vD0 = k * (vA0 - m)
            var myFlag = 0
            if BC > CD{
                myFlag = 0
            }
            if BC <= CD, CD < -k * (vC - m){
                myFlag = 1
            }
            if CD >= -k * (vC - m), vD <= m + (vA0 - m) * exp(-k * vT3){
                myFlag = 2
            }
            if vD > m+(vA0 - m) * exp(-k * vT3){
                myFlag = 3
            }
            var k2 = 0.0
            var X2 = 0.0
            var Xge = 0.0
            var Yge = 0.0
            var m2 = 0.0
            var gsl = 0.0
            var Ict = 0.0
            if myFlag == 1{
                var vC2lower = m + (vA0 - m) * exp(-k * (2.0 * vT1 - vT0))
                var vC2upper = vB
                var vC2 = (vC2upper + vC2lower) / 2.0
                for _ in 0 ..< 100{
                    m2 = (vA * vC2 - vB * vB)/(vA - 2 * vB + vC2)
                    k2 = -1/(vT1 - vT0) * log((vB - vC2)/(vA - vB))
                    Yge = m2 - CD / k2
                    Xge = -(1 / k2) * log((Yge - m2) / (vA0 - m2))
                    X2 = (Yge * vT2 - Yge * vT3 - vD * vT2 + vC * vT3)/(vC - vD)
                    if Xge == X2 {
                        break
                    }
                    else if Xge < X2{
                        vC2lower = vC2
                    }
                    else if  Xge>X2{
                        vC2upper = vC2
                    }
                    vC2 = (vC2upper + vC2lower) / 2.0
                }//for _ in 0 ..< 100
                k = k2
                m = m2
                vA0 = m2 + (vA - m2) * exp(-k2 * (-vT0))
                vD0 = k2 * (vA0 - m2)
                gsl = -k2 * (Yge - m2)
                Ict = Yge - gsl * Xge
            }//if myFlag == 1
            if myFlag == 2{
                var YgeUpper = vC
                var YgeLower = m + (vA0 - m) * exp(-k * vT3)
                Yge = (YgeUpper + YgeLower) / 2.0
                for _ in 0 ..< 100{
                    Xge = -1 / k * log((Yge - m) / (vA0 - m))
                    gsl = -k * (Yge - m)
                    let YD = -k * (Yge - m) * vT3 + Yge - gsl * Xge
                    if YD == vD {
                        break
                    }
                    else if YD < vD{
                        YgeUpper = Yge
                    }
                    else if  YD > vD{
                        YgeLower = Yge
                    }
                    Yge = (YgeUpper + YgeLower)/2.0
                }//for _ in 0 ..< 100
                gsl = -k * (Yge - m)
                Ict = Yge - gsl * Xge
            }//if myFlag == 2
            var vytime = 0.0
            if myFlag == 1 || myFlag == 2 {
                vytime = (vVY - Ict) / gsl
            }
            if vVY>Yge || D.text?.count == 0 {
                vytime = -1.0 / k * log((vVY - m)/(vA0 - m))
            }
            var ftx = 0.0
            if vTx <= Xge || Xge == 0 {
                ftx = m + (vA0 - m) * exp(-k * vTx)
            }
            if vTx > Xge {
                ftx = gsl * vTx + Ict
            }
            if T3.text?.count == 0 {
                Yge = 0.0
                ftx = m + (vA0 - m) * exp(-k * vTx)
            }
            if Tx.text?.count == 0 {
                ftx = 0.0
            }
            if VY.text?.count == 0{
                vytime = 0.0
            }
            kValue.text = String(format: "%.3f", k)
            initialSlope.text = String(format: "%.3f", -vD0)
            GMI.text = String(format: "%.3f", m)
            minimalValue.text = String(format: "%.3f", m)
            Doverk.text = String(format: "%.3f", fabs(vD0 / k))
            minuskValue.text = String(format: "%.3f", -k)
            secondSlope.text = String(format: "%.3f", gsl)
            Intercept.text = String(format: "%.3f", Ict)
            GompExBoundary.text = String(format: "%.3f", Yge)
            Ftx.text = String(format: "%.3f", ftx)
            TimeToY.text = String(format: "%.3f", vytime)
            if myFlag == 0 || myFlag == 3{
                GompExBoundary.text = "---"
                secondSlope.text = "---"
                Intercept.text = "---"
            }
            if T3.text?.count == 0{
                GompExBoundary.text = ""
                secondSlope.text = ""
                Intercept.text = ""
            }
            if Tx.text?.count == 0{
                Ftx.text = ""
            }
            if VY.text?.count == 0{
                TimeToY.text = ""
            }
            if Ict < 0{
                Fugo2.text = "-"
            }
            else{
                Fugo2.text = "+"
            }
        }//else at 116
    }//@IBAction func myActionRUN()
    
    @IBAction func myActionDecimal(){
        if T0.isEditing{T0.text?.decimal()}
        if T1.isEditing{T1.text?.decimal()}
        if T2.isEditing{T2.text?.decimal()}
        if T3.isEditing{T3.text?.decimal()}
        if Tx.isEditing{Tx.text?.decimal()}
        if A.isEditing{A.text?.decimal()}
        if B.isEditing{B.text?.decimal()}
        if C.isEditing{C.text?.decimal()}
        if D.isEditing{D.text?.decimal()}
        if VY.isEditing{VY.text?.decimal()}
    }//@IBAction func myActionDecimal()
    
    @IBAction func myActionMinus(){
        if VY.isEditing, VY.text?.count == 0{VY.text = "-"}
        else{
            let titleString = "Minus-Button"
            let messageString = "Minus-Button is only available for Value Y."
            let alert: UIAlertController = UIAlertController(title:titleString,message: messageString,preferredStyle: UIAlertController.Style.alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK",style: UIAlertAction.Style.default,handler:{(action:UIAlertAction!) -> Void in
            })
            alert.addAction(okAction)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func myActionClear(){
        A.text = ""
        B.text = ""
        C.text = ""
        D.text = ""
        VY.text = ""
        T0.text = ""
        T1.text = ""
        T2.text = ""
        T3.text = ""
        Tx.text = ""
        Doverk.text = ""
        Fugo2.text = ""
        initialSlope.text = ""
        kValue.text = ""
        minuskValue.text = ""
        GompExBoundary.text = ""
        Ftx.text = ""
        TimeToY.text = ""
        GMI.text = ""
        minimalValue.text = ""
        secondSlope.text = ""
        Intercept.text = ""
        T0.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

