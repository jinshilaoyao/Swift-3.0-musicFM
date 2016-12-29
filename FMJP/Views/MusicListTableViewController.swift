//
//  MusicListTableViewController.swift
//  FMJP
//
//  Created by yesway on 2016/12/28.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import MJRefresh

class MusicListTableViewController: UITableViewController {

    var channel: String = "public_tuijian_zhongguohaoshengyin"
    var curChannelList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        channel = DataCenter.shareDataCenter.currentChannel
        
        HttpRequest.getSongList(ch_name: channel) { (list) in
            if list == nil {return}
            
            DataCenter.shareDataCenter.currentChannelAllSongId = list!
            self.loadSongData()
        }
        tableView.mj_header = MJRefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_footer = MJRefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
    }

    func loadSongData() {
        curChannelList = DataCenter.shareDataCenter.curChaShowAllSongId
        
        HttpRequest.getSongInfoList(chidArray: curChannelList) { (info) in
            
            if info == nil {return}
            DataCenter.shareDataCenter.curShowAllSongInfo = info!
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }
        
        HttpRequest.getSongLinkList(chidArray: self.curChannelList) { (link) in
            DataCenter.shareDataCenter.curShowAllSongLink = link!
        }
        
    }
    
    func refreshList() {
        DataCenter.shareDataCenter.curChaShowStartIndex += 20
        DataCenter.shareDataCenter.curChaShowEndIndex += 20
        
        if DataCenter.shareDataCenter.curChaShowEndIndex > DataCenter.shareDataCenter.currentChannelAllSongId.count {
            DataCenter.shareDataCenter.curChaShowStartIndex = DataCenter.shareDataCenter.curChaShowEndIndex-20
        }
        
        loadSongData()
    }
    
    func loadMore() {
        DataCenter.shareDataCenter.curChaShowEndIndex += 20
        
        if DataCenter.shareDataCenter.curChaShowEndIndex > DataCenter.shareDataCenter.currentChannelAllSongId.count{
            DataCenter.shareDataCenter.curChaShowEndIndex = DataCenter.shareDataCenter.currentChannelAllSongId.count
            DataCenter.shareDataCenter.curChaShowStartIndex = DataCenter.shareDataCenter.curChaShowEndIndex-20
        }
        
        loadSongData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.curChannelList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath)

        let info = DataCenter.shareDataCenter.curShowAllSongInfo[indexPath.row]
        cell.textLabel?.text = info.name
        cell.detailTextLabel?.text = info.artistName
        
        guard let imgUrl = URL(string: info.songPicSmall), let data = try? Data(contentsOf: imgUrl),let img = UIImage(data: data) else {
            return cell
        }
        cell.imageView?.image = img
        cell.imageView?.layer.cornerRadius = 22
        cell.imageView?.layer.masksToBounds = true
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataCenter.shareDataCenter.curPlaySongIndex = indexPath.row
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:CHANNEL_MUSIC_LIST_CLICK_NOTIFICATION), object: nil)
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
