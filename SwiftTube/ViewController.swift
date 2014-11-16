//
//  ViewController.swift
//  SwiftTube
//
//  Created by Pascal Raszyk on 16.11.14.
//  Copyright (c) 2014 Pascal Raszyk. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    @IBOutlet weak var linkField: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBOutlet weak var downloadButton: NSButton!
    @IBOutlet weak var savePlaceButton: NSButton!
    @IBOutlet weak var watchClipboardCheckbox: NSButton!

    
    /**
    * Utilizes YoutubeDL to download a video
    */
    @IBAction func downloadBtnClicked(sender: AnyObject){
        let path = "/usr/local/bin/youtube-dl";
        let fileManager = NSFileManager.defaultManager();
        
        if (!fileManager.fileExistsAtPath(path)){
            println("Oops! Youtube DL is not installed");
            installYoutubeDL();
        } else {
            youtubeDL(linkField.stringValue);
        }
    }
    
    func installYoutubeDL(){
        let task = NSTask();
        task.launchPath = "/usr/bin/curl";
        task.arguments = ["https://yt-dl.org/downloads/2014.11.16/youtube-dl", "-o", "/usr/local/bin/youtube-dl"];
        
        let pipe = NSPipe();
        task.standardOutput = pipe;
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile();
        let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)!;
        
        let chmodTask = NSTask();
        chmodTask.launchPath = "/bin/chmod";
        chmodTask.arguments = ["a+x", "/usr/local/bin/youtube-dl"];
        
        let chmodPipe = NSPipe();
        chmodTask.standardOutput = chmodPipe;
        chmodTask.launch()
        
        let chmodData = chmodPipe.fileHandleForReading.readDataToEndOfFile();
        let chmodOutput: String = NSString(data: chmodData, encoding: NSUTF8StringEncoding)!;
        
        println("YoutubeDL installed!");
    }
    
    func youtubeDL(link : String){
        let task = NSTask();
        let youtubeLink = link.stringByReplacingOccurrencesOfString("http://", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil);
        
        task.launchPath = "/usr/local/bin/youtube-dl";
        task.arguments = [
            "-o",
            "(title)s - %(uploader).%(ext)s",
            youtubeLink,
        ];
        
        let pipe = NSPipe();
        task.standardOutput = pipe;
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile();
        let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)!;
        
        println("Finished");
    }
    
    @IBAction func changeSavePlaceBtnClicked(sender: AnyObject){
        
    }
    
    

}

