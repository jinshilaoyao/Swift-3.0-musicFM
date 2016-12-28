//
//  Song.swift
//  FMJP
//
//  Created by yesway on 2016/12/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import Foundation
import SwiftyJSON

class Song:NSObject{
    var sid:String
    var name:String
    var artist:String
    var album:String
    var song_url:String
    var pic_url:String
    var lrc_url:String
    var time:Int
    var is_dl:Int
    var dl_file:String
    var is_like:Int
    var is_recent:Int
    var format:String
    
    init(sid:String,name:String,artist:String,album:String,song_url:String,pic_url:String,lrc_url:String,time:Int,is_dl:Int,dl_file:String,is_like:Int,is_recent:Int,format:String) {
        
        self.sid = sid
        self.name = name
        self.artist = artist
        self.album = album
        self.song_url = song_url
        self.pic_url = pic_url
        self.lrc_url = lrc_url
        self.time = time
        self.is_dl = is_dl
        self.dl_file = dl_file
        self.is_like = is_like
        self.is_recent = is_recent
        self.format = format
        
        super.init()
    }
    
    override var description: String {
        return "a"
    }
}

struct SongInfo {
    var id:String
    var name:String
    var artistId:String
    var artistName:String
    var albumId:Int
    var albumName:String
    var songPicSmall:String
    var songPicBig:String
    var songPicRadio:String
    var allRate:String
    
    init(list: JSON) {
        id = list["songId"].stringValue
        name = list["songName"].stringValue
        artistId = list["artistId"].stringValue
        artistName = list["artistName"].stringValue
        albumId = list["albumId"].intValue
        albumName = list["albumName"].stringValue
        songPicSmall = list["songPicSmall"].stringValue
        songPicBig = list["songPicBig"].stringValue
        songPicRadio = list["songPicRadio"].stringValue
        allRate = list["allRate"].stringValue
    }
    
    init(dic: [String: Any]) {
        id = dic["songId"] as! String
        name = dic["songName"] as! String
        artistId = dic["artistId"] as! String
        artistName = dic["artistName"] as! String
        albumId = dic["albumId"] as! Int
        albumName = dic["albumName"] as! String
        songPicSmall = dic["songPicSmall"] as! String
        songPicBig = dic["songPicBig"] as! String
        songPicRadio = dic["songPicRadio"] as! String
        allRate = dic["allRate"] as! String
    }
}

struct SongLink {
    var id:String
    var name:String
    var lrcLink:String
    var linkCode:Int
    var songLink:String
    var format:String
    var time:Int
    var size:Int
    var rate:Int
    
    init(list: JSON) {
         id = list["songId"].stringValue
         name = list["songName"].stringValue
         lrcLink = list["lrcLink"].stringValue
         linkCode = list["linkCode"].intValue
         songLink = list["songLink"].stringValue
         format = list["format"].stringValue
         time = list["time"].intValue
         size = list["size"].intValue
         rate = list["rate"].intValue

    }
}
