//
//  ChannelTableViewController.swift
//  FMJP
//
//  Created by yesway on 2016/12/28.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

class ChannelTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if DataCenter.shareDataCenter.channelListInfo.count == 0 {
            HttpRequest.getChannelList(callBack: { (list) in
                guard let templist = list else { return }
                
                DataCenter.shareDataCenter.channelListInfo = templist
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataCenter.shareDataCenter.channelListInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = DataCenter.shareDataCenter.channelListInfo[indexPath.row].name

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = DataCenter.shareDataCenter.channelListInfo[indexPath.row]
        DataCenter.shareDataCenter.currentChannel = channel.id
        DataCenter.shareDataCenter.currentChannelName = channel.name
        DataCenter.shareDataCenter.curChaShowStartIndex = 0
        DataCenter.shareDataCenter.curChaShowEndIndex = 20
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25) { 
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }


}
