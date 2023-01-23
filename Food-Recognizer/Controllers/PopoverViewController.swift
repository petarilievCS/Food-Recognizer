//
//  PopoverViewController.swift
//  Food-Recognizer
//
//  Created by Petar Iliev on 23.1.23.
//

import UIKit

class PopoverViewController: UIViewController {
    
    @IBOutlet weak var linkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture for link
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickLabel(sender:)))
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(tap)
        
        // Customize text
        linkLabel.attributedText = NSAttributedString(string: "https://fdc.nal.usda.gov", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    // Open a link when label get's clicked
    @objc func onClickLabel(sender: UITapGestureRecognizer) {
        openUrl(urlString: "https://fdc.nal.usda.gov")
    }

    // Open URL from given urlString
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}



