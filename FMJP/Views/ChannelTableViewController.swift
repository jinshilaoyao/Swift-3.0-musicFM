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
//                self.tableView.reloadData()
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
