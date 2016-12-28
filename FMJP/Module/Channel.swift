//
//  Channel.swift
//  FMJP
//
//  Created by yesway on 2016/12/24.
//  Copyright © 2016年 joker. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Channel {
    var id:String
    var name:String
    var order:Int
    var cate_id:String
    var cate:String
    var cate_order:Int
    var pv_order:Int
    
    init(subJson: JSON) {
        id = subJson["channel_id"].stringValue
        name = subJson["channel_name"].stringValue
        order = subJson["channel_order"].intValue
        cate_id = subJson["cate_id"].stringValue
        cate = subJson["cate"].stringValue
        cate_order = subJson["cate_order"].intValue
        pv_order = subJson["pv_order"].intValue
    }
}
