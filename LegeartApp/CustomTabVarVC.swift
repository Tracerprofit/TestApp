//
//  CustomTabVarVC.swift
//  LegeartApp
//
//  Created by PRGR on 24.01.2022.
//

import Foundation
import UIKit

class CustomTabBarvc: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var logo: UIBarButtonItem!
    @IBOutlet weak var messageButton: UIBarButtonItem!
    @IBOutlet weak var logoButton: UIBarButtonItem!
    let NotificationImage = [UIImage(named: "Anna")]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 1
        setupMiddleButton()
        logo.setBackgroundImage(UIImage(named: "logoBlackNew"), for: .normal, barMetrics: .default)
        logoButton.setBackgroundImage(NotificationImage[0], for: .normal, barMetrics: .default)
        
        
    }
    
    func setupMiddleButton(){
        let middleButton = UIButton(frame: CGRect(x: self.view.bounds.width - 84, y: 5, width: 44, height: 44))
        middleButton.setBackgroundImage(UIImage(named: "NewTask"), for: .normal)
        middleButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        self.tabBar.addSubview(middleButton)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func menuButtonAction(sender: UIButton){
        self.selectedIndex = 3
    }
    @IBAction func MessageTapped(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: "ShowMessager", sender: nil)
        print("tap in notifications")
    }
    @IBAction func NotificationsTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "VhodUved", sender: nil)
    }
    @IBAction func tapOnImage(_ sender: UIBarButtonItem) {
        print("tap on image in nav bar")
//        performSegue(withIdentifier: "VhodUved", sender: nil)
    }
    
}

extension UINavigationBar {
    //hide border line of nav bar
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
