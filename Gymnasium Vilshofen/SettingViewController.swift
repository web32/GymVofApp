//
//  AppDelegate.swift
//  Gymnasium Vilshofen
//
//  Created by Michael Mayerhofer on 14.10.2014.
//  Copyright (c) 2014 4mayerhofers. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Klasse: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Name.delegate = self
        Klasse.delegate = self
        self.Name.text = NSUserDefaults.standardUserDefaults().objectForKey("Name") as? String
        self.Klasse.text = NSUserDefaults.standardUserDefaults().objectForKey("Klasse") as? String
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        NSUserDefaults.standardUserDefaults().setObject(self.Klasse.text.uppercaseString, forKey: "Klasse")
        NSUserDefaults.standardUserDefaults().setObject(self.Name.text, forKey: "Name")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func textFieldShouldReturn(Klasse: UITextField!) -> Bool {
        Name.resignFirstResponder()
        Klasse.resignFirstResponder()
        return true
    }
}