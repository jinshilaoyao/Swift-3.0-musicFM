//
//  BaseDB.swift
//  FMJP
//
//  Created by yesway on 2016/12/20.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit
import FMDB
class BaseDB {
    
    var dbPath: String
    var db: FMDatabase
    
    init() {
        let dbDirectory = Util.documentPath().appending("/database")
        
        if !FileManager.default.fileExists(atPath: dbDirectory) {
            try? FileManager.default.createDirectory(atPath: dbDirectory, withIntermediateDirectories: false, attributes: nil)
        }
        dbPath = dbDirectory.appending("/fm.sqlite")
        
        db = FMDatabase(path: dbPath)
        
        if !FileManager.default.fileExists(atPath: dbPath) {
            if db.open() {
                let sql = "CREATE TABLE tbl_song_list (id INTEGER PRIMARY KEY AUTOINCREMENT,sid TEXT UNIQUE,name TEXT,artist TEXT,album TEXT,song_url TEXT,pic_url TEXT,lrc_url TEXT,time INTEGER,is_dl INTEGER DEFAULT 0,dl_file TEXT,is_like INTEGER DEFAULT 0,is_recent INTEGER DEFAULT 1,format TEXT)"
                if !db.executeUpdate(sql, withArgumentsIn: [1]) {
                    print("db Creating a successful")
                }
            }
        }
    }
    
    deinit {
        db.close()
    }
    
    func open() -> Bool {
        return db.open()
    }
    
    func close() -> Bool {
        return db.close()
    }
}
