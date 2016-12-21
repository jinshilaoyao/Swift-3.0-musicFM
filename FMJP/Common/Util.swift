//
//  Util.swift
//  FMJP
//
//  Created by yesway on 2016/12/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

class Util {

    class func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    }
    
}
