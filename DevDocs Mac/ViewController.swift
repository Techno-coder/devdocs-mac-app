//
//  ViewController.swift
//  DevDocs Mac
//

import Cocoa
import WebKit

class ViewController: NSViewController, NSWindowDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidAppear()
        
        let window = self.view.window
        if let screen = window?.screen ?? NSScreen.main() {
            window?.setFrame(screen.visibleFrame, display: true)
        }
        
        
        let docsUrl = URL(string: "https://devdocs.io")
        let urlRequest = URLRequest(url: docsUrl!)
        webView.load(urlRequest)
        
        let opts = NSDictionary(object: kCFBooleanTrue, forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString) as CFDictionary
        guard AXIsProcessTrustedWithOptions(opts) == true else { return }
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: self.globalHandler)
        NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: self.localHandler)
        
    }
    
    func globalHandler(event: NSEvent) {
        if(event.modifierFlags.contains(NSEventModifierFlags.control) && event.modifierFlags.contains(NSEventModifierFlags.option)) {
            let spaceKeyCode: UInt16 = 49
            if(event.keyCode == spaceKeyCode) {
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    func localHandler(event: NSEvent) -> NSEvent? {
        if(event.modifierFlags.contains(NSEventModifierFlags.control) && event.modifierFlags.contains(NSEventModifierFlags.option)) {
            let spaceKeyCode: UInt16 = 49
            if(event.keyCode == spaceKeyCode) {
                NSApp.hide(nil)
                return nil
            }
        }
        return event
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.window?.delegate = self
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        NSApp.hide(nil)
        return false
    }
}
