//
//  ViewController.swift
//  TransSqlClient
//
//  Created by kai on 2017/11/26.
//  Copyright © 2017年 kai. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var tvEnName: NSTextView!
    @IBOutlet var tvZhName: NSTextView!
    @IBOutlet var tvEnSteps: NSTextView!
    @IBOutlet var tvZhSteps: NSTextView!
    @IBOutlet weak var lblLog: NSTextField!
    
    let dbManager = DBManager()
    var currentItem :PowerMoon?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nextItem()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func nextItem() {
        if  let item = dbManager.next() {
            self.currentItem = item
            tvEnName.string = item.name
            tvZhName.string = item.zhName
            tvEnSteps.string = item.enSteps
            tvZhSteps.string = item.zhSteps
        }
    }
    
    func previousItem() {
        if  let item = dbManager.previous() {
            self.currentItem = item
            tvEnName.string = item.name
            tvZhName.string = item.zhName
            tvEnSteps.string = item.enSteps
            tvZhSteps.string = item.zhSteps
        }
    }

    @IBAction func next(_ sender: Any) {
       nextItem()
    }
    
    @IBAction func previous(_ sender: Any) {
        previousItem()
    }
    
    @IBAction func saveChange(_ sender: Any) {
        if let item = currentItem {
            do {
             try dbManager.updateItem(row: item, name: tvZhName.string, steps: tvZhSteps.string)
             lblLog.stringValue = "保存成功"
            }
            catch {
                lblLog.stringValue = error.localizedDescription
            }
        }
    }
}

