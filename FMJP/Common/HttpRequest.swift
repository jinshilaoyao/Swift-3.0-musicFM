//
//  HttpRequest.swift
//  FMJP
//
//  Created by yesway on 2016/12/24.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HttpRequest {
    
    class func getChannelList(callBack: @escaping ([Channel]?) -> Void) -> Void {
        
        var channelList: [Channel]? = nil
        
        Alamofire.request(http_channel_list_url).responseJSON { (response) in
            guard let data = response.data else {
                callBack(nil)
                return
            }
            channelList = []
            let json = JSON(data: data)
            let list = json["channel_list"]
            for (_, subJson) in list {
                let channel = Channel(subJson: subJson)
                channelList?.append(channel)
            }
            callBack(channelList)
        }
    }
    
    class func getSongList(ch_name: String, callback: @escaping ([String]?) -> Void) -> Void {
        
        var songList: [String]? = nil
        let url = http_song_list_url + ch_name
        
        Alamofire.request(url, method: .get).responseJSON { (response: DataResponse) in
            
            guard let data = response.data else {
                callback(nil)
                return
            }
            let json = JSON(data: data)
            let list = json["list"]
            songList = []
            for (_,subJson) in list {
                let id = subJson["id"].stringValue
                songList?.append(id)
            }
            callback(songList)
        }
    }
    
    class func getSongInfoList(chidArray: [String], callBack: @escaping ([SongInfo]?) ->Void) {
        let chids = chidArray.joined(separator: ",")
        let params = ["songIds": chids]
        
        Alamofire.request(http_song_info, parameters: params).response { (response) in
            
            guard let data = response.data else {
                callBack(nil)
                return
            }
            let json = JSON(data: data)
            let lists = json["data"]["songList"]
            var ret: [SongInfo] = []
            for (_,list) in lists {
                let songInfo = SongInfo(list: list)
                ret.append(songInfo)
            }
            callBack(ret)
        }
    }
    
    class func getSongLinkList(chidArray: [String], callBack: @escaping ([SongLink]?) ->Void) {
        let chids = chidArray.joined(separator: ",")
        let params = ["songIds": chids]
        
        Alamofire.request(http_song_link, parameters: params).response { (response) in
            
            guard let data = response.data else {
                callBack(nil)
                return
            }
            let json = JSON(data: data)
            let lists = json["data"]["songList"]
            
            var ret: [SongLink] = []
            for (_, list) in lists {
                let songLink = SongLink(list: list)
                ret.append(songLink)
            }
            callBack(ret)
        }
    }
    
    class func getLrc(lrc: String, callBack: @escaping (String?) -> Void) {
        Alamofire.request(lrc).responseString { (response) in
            let lrc = String(data: response.data!, encoding: String.Encoding.utf8)
            callBack(lrc)
        }
    }
    
    class func downloadFile(songUrl: String, musicPath: String,filePath: @escaping () -> Void) {
        let canPlaySongUrl = Common.getCanPlaySongUrl(songUrl)
        let fileURL = URL(fileURLWithPath: musicPath)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(URL(string: canPlaySongUrl)!, method: .get, to: destination).response { (response) in
            filePath()
        }
        
    }
    
}
