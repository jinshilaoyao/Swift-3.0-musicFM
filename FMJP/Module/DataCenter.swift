//
//  DataCenter.swift
//  FMJP
//
//  Created by yesway on 2016/12/23.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import MediaPlayer

class DataCenter {
    
    private struct Static {
        static var onceToken: Int = 0
        static var instance: DataCenter? = nil
    }
    
    class var shareDataCenter: DataCenter {
        
        _ = DataCenter.__once
        return Static.instance!
    }
    
    private static var __once: () = { () -> Void in
        Static.instance = DataCenter()
    }()
    
    var mp: MPMoviePlayerController = MPMoviePlayerController()
    
    //歌曲分类列表
    var channelListInfo: [Channel] = []
    var currentChannel: String = "public_tuijian_zhongguohaoshengyin" {
        didSet {
            UserDefaults.standard.setValue(currentChannel, forKey: "LAST_PLAY_CHANNELID")
            UserDefaults.standard.synchronize()
        }
    }
    var currentChannelName: String = "中国好声音" {
        didSet {
            UserDefaults.standard.setValue(currentChannelName, forKey: "LAST_PLAY_CHANNEL_NAME")
            UserDefaults.standard.synchronize()
        }
    }
    
    //当前频道信息
    var currentChannelAllSongId: [String] = []
    var curChaShowStartIndex = 0
    var curChaShowEndIndex = 20
    var curChaShowAllSongId: [String] {
        get {
            if curChaShowEndIndex > currentChannelAllSongId.count {
                curChaShowEndIndex = currentChannelAllSongId.count
                curChaShowStartIndex = curChaShowEndIndex - 20
            }
            
            curChaShowStartIndex = curChaShowStartIndex < 0 ? 0 : curChaShowStartIndex
            return [] + currentChannelAllSongId[curChaShowStartIndex ..< curChaShowEndIndex]
        }
    }
    
    //当前歌曲信息
    var curShowAllSongInfo: [SongInfo] = []
    var curShowAllSongLink: [SongLink] = []
    var curPlaySongIndex: Int = 0 {
        didSet {
            if curPlaySongIndex < curShowAllSongInfo.count {
                curPlaySongInfo = curShowAllSongInfo[curPlaySongIndex]
            }
            if curPlaySongIndex < curShowAllSongLink.count {
                curPlaySongLink = curShowAllSongLink[curPlaySongIndex]
            }
        }
    }
    
    var curPlaySongInfo: SongInfo? = nil
    var curPlaySongLink: SongLink? = nil
    var curPlaySong: Song? = nil
    var curPlaySongStatus: SongPlayStatus = .defaul
    
    enum SongPlayStatus {
        case defaul, play, pause, stop
    }
    
    var dbSongList: SongList = SongList()
}
