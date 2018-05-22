//
//  Test.swift
//  ocdemo
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

 class Test: NSObject {
 
  @objc  var number:Int{
        return 23
    }
  @objc func print(string str:String) -> String {
   let vc:ViewController = ViewController()
    vc.printOc()
        return str;
    }
}
