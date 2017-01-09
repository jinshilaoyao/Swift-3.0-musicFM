//
//  ViewController.swift
//  FMJP
//
//  Created by yesway on 2016/12/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import LTMorphingLabel
import Kingfisher
import MediaPlayer
import Async

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: LTMorphingLabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var imgView: RoundImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet weak var songTimeLengthLabel: UILabel!
    
    @IBOutlet weak var songTimePlayLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var timer: Timer? = nil
    var currentChannel = ""
    var dbSong: Song? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let FPSLab = FPSLabel(frame: CGRect(x: 40, y: 20, width: 80, height: 40))
        UIApplication.shared.keyWindow!.addSubview(FPSLab)
        
        self.nameLabel.morphingEffect = .fall
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.size.width, height: view.frame.height)
        self.bgImageView.addSubview(blurView)
        
        currentChannel = DataCenter.shareDataCenter.currentChannel
        
        if let storeChannel = UserDefaults.standard.value(forKey: "LAST_PLAY_CHANNEL_ID") as? String {
            currentChannel = storeChannel
        }
        if let channelName = UserDefaults.standard.value(forKey: "LAST_PLAY_CHANNEL_NAME") as? String {
            DataCenter.shareDataCenter.currentChannelName = channelName
        }
        if DataCenter.shareDataCenter.currentChannelAllSongId.count == 0 {
            HttpRequest.getSongList(ch_name: self.currentChannel, callback: { (songList) in
                if let list = songList {
                    DataCenter.shareDataCenter.currentChannelAllSongId = list
                    self.loadSongData()
                } else {
                    let alert = UIAlertController(title: "提示", message: "请连接网络", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.progressTimer(_:)), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appDidBecomeAction), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.musicListClick), name: NSNotification.Name(rawValue: CHANNEL_MUSIC_LIST_CLICK_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.otherMusicListClick(_:)), name: NSNotification.Name(rawValue: OTHER_MUSIC_LIST_CLICK_NOTIFICATION), object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notification
    
    func appDidBecomeAction() {
        if !imgView.isAnimating && DataCenter.shareDataCenter.curPlaySongStatus == .play {
            imgView.rotation()
        }
    }
    
    func musicListClick() {
        start(index: DataCenter.shareDataCenter.curPlaySongIndex)
    }
    
    func otherMusicListClick(_ notification: Notification) {
        guard let info = (notification as NSNotification).userInfo as? [String: Any], let song = info["song"] as? Song else {
            return
        }
        print("\(song.name)")
        show(showImg: song.pic_url, name: song.name, artistName: song.artist, albumName: song.album, songlink: song.song_url, time: song.time, lrclink: song.lrc_url, songId: song.sid, format: song.format)
    }
    
    // MARK: - tools
    
    func progressTimer(_ timer: Timer) {
        if let link = DataCenter.shareDataCenter.curPlaySongLink {
            
            let currentPlayBackTime = DataCenter.shareDataCenter.mp.currentPlaybackTime
            if currentPlayBackTime.isNaN { return }
            
            progressView.progress = Float(currentPlayBackTime/Double(link.time))
            songTimePlayLabel.text = Common.getMinuteDisplay(Int(currentPlayBackTime))
            
            if progressView.progress == 1.0 {
                progressView.progress = 0
                next()
            }
        }
    }
    
    func prev() {
        DataCenter.shareDataCenter.curPlaySongIndex -= 1
        if DataCenter.shareDataCenter.curPlaySongIndex < 0 {
            DataCenter.shareDataCenter.curPlaySongIndex = DataCenter.shareDataCenter.curChaShowAllSongId.count - 1
        }
        start(index: DataCenter.shareDataCenter.curPlaySongIndex)
    }
    func next() {
        DataCenter.shareDataCenter.curPlaySongIndex += 1
        if DataCenter.shareDataCenter.curPlaySongIndex > DataCenter.shareDataCenter.curChaShowAllSongId.count {
            DataCenter.shareDataCenter.curPlaySongIndex = 0
        }
        start(index: DataCenter.shareDataCenter.curPlaySongIndex)
    }
    
    private func loadSongData() {
        if DataCenter.shareDataCenter.curShowAllSongInfo.count == 0 {
            HttpRequest.getSongInfoList(chidArray: DataCenter.shareDataCenter.curChaShowAllSongId, callBack: { (songInfos) in
                if songInfos == nil {return}
                DataCenter.shareDataCenter.curShowAllSongInfo = songInfos!
                HttpRequest.getSongLinkList(chidArray: DataCenter.shareDataCenter.curChaShowAllSongId, callBack: { (songLinks) in
                    DataCenter.shareDataCenter.curShowAllSongLink = songLinks!
                    self.start(index: 0)
                })
            })
        } else {
            self.start(index: DataCenter.shareDataCenter.curPlaySongIndex)
        }
    }
    
    func start(index: Int) {
        DataCenter.shareDataCenter.curPlaySongIndex = index
        
        DispatchQueue.main.async {
            if index == 0 {
                self.prevButton.isEnabled = false
            } else {
                self.prevButton.isEnabled = true
            }
            
            if index == DataCenter.shareDataCenter.curChaShowAllSongId.count - 1 {
                self.nextButton.isEnabled = false
            } else {
                self.nextButton.isEnabled = true
            }
            
            guard let info = DataCenter.shareDataCenter.curPlaySongInfo, let link = DataCenter.shareDataCenter.curPlaySongLink else {
                return
            }
            
            let showImg = Common.getIndexPageImage(info)
            
            self.show(showImg: showImg, name: info.name, artistName: info.artistName, albumName: info.albumName, songlink: link.songLink, time: link.time, lrclink: link.lrcLink, songId: link.id, format: link.format)
        }
    }
    private func show(showImg: String, name: String, artistName: String, albumName: String, songlink: String, time: Int, lrclink: String, songId: String, format: String) {
        
        resetUI()
        
        navigationController?.title = DataCenter.shareDataCenter.currentChannelName
        
        imgView.kf.setImage(with: ImageResource(downloadURL: URL(string: showImg)!, cacheKey: showImg))
        nameLabel.text = name
        artistLabel.text = "-" + artistName + "-"

        bgImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: showImg)!, cacheKey: showImg))
        imgView.rotation()
        
        showNowPlay(showImg, name: name, artistName: artistName, albumName: albumName)
        
        DataCenter.shareDataCenter.mp.stop()
        let songUrl = Common.getCanPlaySongUrl(songlink)
        
        let musicFile = Common.musicLocalPath(songId, format: format)
        if Common.fileIsExist(musicFile) {
            print("播放本地音乐")
            DataCenter.shareDataCenter.mp.contentURL = URL(fileURLWithPath: musicFile)
        } else {
            DataCenter.shareDataCenter.mp.contentURL = URL(string: songUrl)
        }
        
        DataCenter.shareDataCenter.mp.prepareToPlay()
        DataCenter.shareDataCenter.mp.play()
        DataCenter.shareDataCenter.curPlaySongStatus = .play
        
        playButton.setImage(UIImage(named: "player_btn_pause_normal"), for: .normal)
        songTimeLengthLabel.text = Common.getMinuteDisplay(time)
        
        HttpRequest.getLrc(lrc: lrclink) { (lrc) in
            let lrcAfter: String? = Common.replaceString(pattern: "\\[[\\w|\\.|\\:|\\-]*\\]", replace: lrc!, place: "")
            if lrcAfter != nil {
                self.txtView.text = lrcAfter
            }
        }
        
        addRecentSong()
        
        _ = DataCenter.shareDataCenter.dbSongList.updateSongDownloadUrl(sid: songId, newUrl: songUrl)
        
        guard let song = DataCenter.shareDataCenter.dbSongList.get(sid: songId) else {
            return
        }
        self.dbSong = song
        if song.is_dl == 1 {
            downloadButton.setImage(UIImage(named: "Downloaded"), for: .normal)
        } else {
            downloadButton.setImage(UIImage(named: "Download"), for: .normal)
        }
        
        if song.is_like == 1 {
            likeButton.setImage(UIImage(named: "Like"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "Unlike"), for: .normal)
        }
    }
    
    private func addRecentSong() {
        guard let info = DataCenter.shareDataCenter.curPlaySongInfo,let link = DataCenter.shareDataCenter.curPlaySongLink else {
            return
        }
        
        if DataCenter.shareDataCenter.dbSongList.insert(info: info, link: link) {
            print("\(info.id)，添加最近播放成功")
        } else {
            print("\(info.id)，添加最近播放四百")
        }
    }
    
    private func resetUI() {
        progressView.progress = 0
        songTimePlayLabel.text = "00:00"
        songTimeLengthLabel.text = "00:00"
        txtView.text = ""
    }
    
    private func showNowPlay(_ songPic: String, name: String, artistName: String, albumName: String) {
        guard let url = URL(string: songPic), let data = try? Data(contentsOf: url), let img = UIImage(data: data) else {
            return
        }

        let item = MPMediaItemArtwork(image: img)
        
        var dic: [String: Any] = [:]
        dic[MPMediaItemPropertyTitle] = name
        dic[MPMediaItemPropertyArtist] = artistName
        dic[MPMediaItemPropertyAlbumTitle] = albumName
        dic[MPMediaItemPropertyArtwork] = item
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = dic
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        if event?.type == UIEventType.remoteControl {
            switch event?.subtype {
                
//            case .remoteControlPlay:
//                DataCenter.shareDataCenter.mp.play()
//            case .remoteControlPause:
//                DataCenter.shareDataCenter.mp.pause()
//            case .remoteControlTogglePlayPause:
////                togglePlayPause()
//            case .remoteControlPreviousTrack:
//                prev()
//            case .remoteControlNextTrack:
//                next()
            default:
                break
            }
        }
        
    }
    
    // MARK: - Action
    
    @IBAction func prevSong(_ sender: UIButton) {
        Async.background {
            self.prev()
        }
    }
    @IBAction func nextSong(_ sender: UIButton) {
        Async.background {
            self.next()
        }
    }
    @IBAction func changePlayStatus(_ sender: UIButton) {
        if DataCenter.shareDataCenter.curPlaySongStatus == .play {
            DataCenter.shareDataCenter.curPlaySongStatus = .pause
            DataCenter.shareDataCenter.mp.pause()
            playButton.setImage(UIImage(named: "player_btn_play_normal"), for: .normal)
            imgView.layer.removeAllAnimations()
        } else {
            DataCenter.shareDataCenter.curPlaySongStatus = .play
            DataCenter.shareDataCenter.mp.play()
            playButton.setImage(UIImage(named: "player_btn_pause_normal"), for: .normal)
            imgView.rotation()
        }
    }
    @IBAction func downloadSong(_ sender: UIButton) {
        if let dbSong = self.dbSong {
            if dbSong.is_dl == 1 {
                if Common.deleteSong(dbSong.sid, format: dbSong.format) {
                    var ret2 = DataCenter.shareDataCenter.dbSongList.updateDownloadStatus(dbSong.sid, status: 0)
                    
                    self.dbSong?.is_dl = 0
                    downloadButton.setImage(UIImage(named: "Download"), for: .normal)
                }
            } else {
                let musicPath = Common.musicLocalPath(dbSong.sid, format: dbSong.format)
                if Common.fileIsExist(musicPath) {
                    print("文件已经保存")
                    return
                } else {
                    HttpRequest.downloadFile(songUrl: dbSong.song_url, musicPath: musicPath, filePath: { 
                        
                        if Common.fileIsExist(musicPath) {
                            if DataCenter.shareDataCenter.dbSongList.updateDownloadStatus(dbSong.sid, status: 1) {
                                Async.main{
                                    dbSong.is_dl = 1
                                    self.downloadButton.setImage(UIImage(named: "Downloaded"), for: .normal)
                                }
                            } else {
                                print("DB upload fail")
                            }
                        } else {
                            print("\(musicPath) 文件不存在")
                        }
                        
                    })
                }
            }
        }
    }
    @IBAction func likeSong(_ sender: UIButton) {
        guard let dbsong = self.dbSong else {
            return
        }
        if dbsong.is_like == 1 {
            if DataCenter.shareDataCenter.dbSongList.updateLikeStatus(dbsong.sid, status: 0) {
                self.dbSong?.is_like = 0
                likeButton.setImage(UIImage(named: "Unlike"), for: .normal)
            }
        } else {
            if DataCenter.shareDataCenter.dbSongList.updateLikeStatus(dbsong.sid, status: 1) {
                self.dbSong?.is_like = 1
                likeButton.setImage(UIImage(named: "Like"), for: .normal)
            }
        }
    }
    
}

