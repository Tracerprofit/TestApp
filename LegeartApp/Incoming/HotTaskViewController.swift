//
//  HotTaskViewController.swift
//  LegeartApp
//
//  Created by PRGR on 31.01.2022.
//

import UIKit
import Firebase

class HotTaskViewController: UIViewController{
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var logo: UIBarButtonItem!

    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        CallDataInFirebase()
        addViewNavBar()
        logo.setBackgroundImage(UIImage(named: "logonavBar"), for: .normal, barMetrics: .default)
        logo.title = " "
        
        
        
        
    }
    
    func CallDataInFirebase(){
        ref.child("Incomings").observeSingleEvent(of: .value) { (snapshot) in
            let info = snapshot.value as? [String: Any]
            if (!info!.isEmpty){
                self.TitleLabel.text = ""
                for item in info!/*.reversed()*/{
                    let one = item.value as! String
                    //let two = item.key
                    self.TitleLabel.text! += one + "\n"
                }
            }
            else {
                self.TitleLabel.text = "Возникла ошибка с БД"
            }
        }
    }
    
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 130, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Горящие задачи"
        labelInView.textColor = .white
        mainView.addSubview(labelInView)
        
        let buttonBack = UIButton(frame: CGRect(x: 19, y: 0, width: 10, height: 15))
        buttonBack.setBackgroundImage(UIImage(named: "backVector"), for: .normal)
        buttonBack.center.y = mainView.center.y
        buttonBack.addTarget(self, action: #selector(back), for: .touchUpInside)
        mainView.addSubview(buttonBack)
        
        let bigBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        bigBackButton.center.y = mainView.center.y
        bigBackButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        mainView.addSubview(bigBackButton)
        
        view.addSubview(mainView)
        
    }
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func MessageTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowMessager", sender: nil)
    }
    
    
    
}
