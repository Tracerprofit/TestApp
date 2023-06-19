//
//  AnyTaskView.swift
//  LegeartApp
//
//  Created by PRGR on 10.03.2022.
//

import UIKit
import Firebase

class AnyTaskView: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    let NotificationImage = [UIImage(named: "Anna")]
    var HeaderOfTaskText = ["Подготовить 3 поста к 14 февраля для соц.сетей Бутикета"]
    var DescriptionOfTaskText = ["Посты должны содержать не более 800 символов. Не стоит забывать про хэштеги. Указываем место. В сторис добавляем геолокацию. Если делаем сторис в Canve скидываем Ренату на проверку."]
    var AllCheckList = ["Подготовить фотографии (обработать если это нужно)"]
    var AllCompletedTasks = ["Подготовить сторис"]
    var calendarDate = ["10 апреля в 10:00"]
    var statusWork = ["В работе", "Просрочена", "Ждет подтверждения", "Завершено"]
    
    let colorsOfStatus = [UIColor(red: 0.52, green: 0.71, blue: 0.37, alpha: 1.00), UIColor(red: 1.00, green: 0.77, blue: 0.34, alpha: 1.00), UIColor(red: 0.66, green: 0.64, blue: 0.64, alpha: 1.00), UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00) ,UIColor(red: 0.90, green: 0.15, blue: 0.07, alpha: 1.00)/*green[0],yellow[1],gray[2],blue[3],red[4]*/]
    var imagesForStatus = [UIImage(named: "denis"), UIImage(named: "AnnaBig"), UIImage(named: "alex")]
    var dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 12))
    let newTaskOnCheck = UITextField(frame: CGRect(x: 60, y: 400, width: 260, height: 24))
    var HeaderOfTaskLabel = UILabel(frame: CGRect(x: 32, y: 55, width: 260, height: 80))
    var DescriptionOfTaskLabel = UILabel(frame: CGRect(x: 32, y: 138, width: 300, height: 100))
    let statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 15))
    let confirmRename = UIButton(type: .custom)
    let renameTextFieldHeader = UITextView(frame: CGRect(x: 27, y: 51, width: 260, height: 80))
    let renameTextFieldDescription = UITextView(frame: CGRect(x: 27, y: 138, width: 310, height: 100))
    let tbView = UITableView(frame: CGRect(x: 32, y: 345, width: 150, height: 100))
    let dropDownList = UIButton(frame: CGRect(x: 32, y: 310, width: 150, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewNavBar()
        addNavBarButtonItems()
        addLabels()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.isHidden = true
        tbView.layer.cornerRadius = 10
        tbView.showsVerticalScrollIndicator = false
        tbView.separatorInset = UIEdgeInsets.zero
        tbView.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        
        let nib = UINib(nibName: "SetsStatusOfTasks", bundle: nil)
        tbView.register(nib, forCellReuseIdentifier: "SetsStatusOfTasks")
        
        view.addSubview(tbView)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newTaskOnCheck.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusWork.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownList.setTitle(statusWork[indexPath.row], for: .normal)
        tbView.deselectRow(at: indexPath, animated: true)
        tbView.isHidden = true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetsStatusOfTasks", for: indexPath) as! SetsStatusOfTasks
        cell.status.text = statusWork[indexPath.row]
        cell.status.font = UIFont.systemFont(ofSize: 10)
        cell.status.textColor = .white
        cell.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        return cell
    }
    func addLabels(){
        
//        HeaderOfTaskLabel.text = HeaderOfTaskText[0]
        HeaderOfTaskLabel.textColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        HeaderOfTaskLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        HeaderOfTaskLabel.numberOfLines = 3
        
        DescriptionOfTaskLabel.numberOfLines = 7
        DescriptionOfTaskLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        DescriptionOfTaskLabel.textColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        DescriptionOfTaskLabel.text = DescriptionOfTaskText[0]
        
        let imageCalendar = UIImageView(frame: CGRect(x: 32, y: DescriptionOfTaskLabel.frame.maxY + 10, width: 20, height: 20))
        imageCalendar.image = UIImage(named: "calendar")
        view.addSubview(imageCalendar)
        
//        dateLabel.text = calendarDate[0]
        dateLabel.center.x = imageCalendar.frame.maxX + 59
        dateLabel.center.y = imageCalendar.center.y
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        view.addSubview(dateLabel)
        
        let renameTask = UIButton(frame: CGRect(x: view.frame.maxX - 52, y: 74, width: 20, height: 20))
        renameTask.setBackgroundImage(UIImage(named: "pencil"), for: .normal)
        renameTask.addTarget(self, action: #selector(renameTaskTapped), for: .touchUpInside)
        
        confirmRename.frame = CGRect(x: view.frame.maxX - 52, y: 110, width: 20, height: 20)
        confirmRename.setImage(UIImage(named: "ok"), for: .normal)
        confirmRename.addTarget(self, action: #selector(confirmRenamePressed), for: .touchUpInside)
        confirmRename.alpha = 0.5
        view.addSubview(confirmRename)
        confirmRename.isHidden = true
        
        renameTextFieldHeader.font = UIFont(name: "Roboto-Medium", size: 20)
        renameTextFieldHeader.textColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        view.addSubview(renameTextFieldHeader)
        renameTextFieldHeader.isHidden = true
        
        renameTextFieldDescription.font = UIFont(name: "Roboto-Regular", size: 14)
        renameTextFieldDescription.textColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        view.addSubview(renameTextFieldDescription)
        renameTextFieldDescription.isHidden = true
        
        let line = UIView(frame: CGRect(x: 32, y: imageCalendar.frame.maxY + 12, width: view.frame.size.width - 64, height: 1))
        line.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
        
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = UIColor(red: 0.52, green: 0.71, blue: 0.37, alpha: 1.00)
        statusLabel.center.x = imageCalendar.center.x + 70
        
        if statusLabel.text == "Принято" || statusLabel.text == "В работе"{
            statusLabel.textColor = self.colorsOfStatus[0]
        } else if statusLabel.text == "Срок изменен"{
            statusLabel.textColor = self.colorsOfStatus[1]
        } else if statusLabel.text == "Завершена"{
            statusLabel.textColor = self.colorsOfStatus[2]
        } else{
            statusLabel.textColor = UIColor.red
        }
        
        view.addSubview(statusLabel)
        statusLabel.isHidden = true
        
        
        dropDownList.setTitle("Начать выполнение", for: .normal)
        dropDownList.setImage(UIImage(named: "arrowDown"), for: .normal)
        dropDownList.titleLabel!.textAlignment = .left
        dropDownList.titleLabel!.font = UIFont(name: "Roboto-Medium", size: 10)
        
        dropDownList.imageEdgeInsets.left = 130
        dropDownList.titleEdgeInsets.left = -20
//        dropDownList.titleLabel!.font = UIFont.systemFont(ofSize: 10)
        dropDownList.tintColor = .white
        dropDownList.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.86, alpha: 1.00)
        dropDownList.layer.cornerRadius = 10
        dropDownList.addTarget(self, action: #selector(dropDownMenu), for: .touchUpInside)
        view.addSubview(dropDownList)
        dropDownList.isHidden = true
        
        //check for admin
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snap, err) in
            if let err = err{
                print(err)
            } else {
                for doc in snap!.documents {
                    if Auth.auth().currentUser?.uid == doc.documentID {
                        if (doc.data()["admin"] as? String) == "true"{
                            self.dropDownList.isHidden = false
                        } else {
                            self.statusLabel.isHidden = false
                        }
                    }
                }
            }
        }
        
        let image1 = UIImageView(frame: CGRect(x: view.frame.maxX - 130, y: line.frame.maxY + 25, width: 33, height: 33))
        image1.image = imagesForStatus[0]
        image1.layer.zPosition = 3
        statusLabel.center.y = image1.center.y
        let image2 = UIImageView(frame: CGRect(x: image1.frame.minX + 25, y: line.frame.maxY + 25, width: 33, height: 33))
        image2.image = imagesForStatus[1]
        image2.layer.zPosition = 2
        let image3 = UIImageView(frame: CGRect(x: image2.frame.minX + 25, y: line.frame.maxY + 25, width: 33, height: 33))
        image3.image = imagesForStatus[2]
        image3.layer.zPosition = 1
        
        for images in [image1, image2, image3]{
            images.layer.cornerRadius = 15
            images.layer.borderWidth = 2
            images.layer.borderColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
            view.addSubview(images)
        }
        
        let checkList = UILabel(frame: CGRect(x: 32, y: line.frame.maxY + 90, width: 70, height: 20))
        checkList.font = UIFont(name: "Roboto-Medium", size: 14)
        checkList.text = "Чек-лист"
        
        let checkButtonOne = UIButton(frame: CGRect(x: 32, y: 0, width: 20, height: 20))
        checkButtonOne.setBackgroundImage(UIImage(named: "buttonAdd"), for: .normal)
        checkButtonOne.addTarget(self, action: #selector(test), for: .touchUpInside)
        checkButtonOne.center.y = newTaskOnCheck.center.y
        
        let checkButtonTwo = UIButton(frame: CGRect(x: 32, y: 420, width: 20, height: 20))
        checkButtonTwo.setBackgroundImage(UIImage(named: "buttonSelect"), for: .normal)
        checkButtonTwo.addTarget(self, action: #selector(test), for: .touchUpInside)
        
        let checkButtonThree = UIButton(frame: CGRect(x: 32, y: 460, width: 20, height: 20))
        checkButtonThree.setBackgroundImage(UIImage(named: "buttonGreen"), for: .normal)
        checkButtonThree.addTarget(self, action: #selector(test), for: .touchUpInside)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: newTaskOnCheck.frame.height, width: newTaskOnCheck.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor
        
        newTaskOnCheck.layer.addSublayer(bottomLine)
        newTaskOnCheck.font = UIFont.systemFont(ofSize: 12)
        newTaskOnCheck.borderStyle = .none
        newTaskOnCheck.delegate = self
        newTaskOnCheck.resignFirstResponder()
        newTaskOnCheck.addTarget(self, action: #selector(editingBegan(_:)), for: .editingDidBegin)
        newTaskOnCheck.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
        self.view.endEditing(true)
        
        let labelTaskCheckList = UILabel(frame: CGRect(x: 60, y: newTaskOnCheck.frame.maxY + 15, width: 260, height: 30))
        labelTaskCheckList.text = AllCheckList[0]
        labelTaskCheckList.textColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        labelTaskCheckList.numberOfLines = 2
        labelTaskCheckList.font = UIFont(name: "Roboto-Regular", size: 12)
        checkButtonTwo.center.y = labelTaskCheckList.center.y
        
        let completedTask = UILabel(frame: CGRect(x: 60, y: labelTaskCheckList.frame.maxY + 15, width: 260, height: 30))
        completedTask.text = AllCompletedTasks[0]
        completedTask.numberOfLines = 2
        completedTask.font = UIFont(name: "Roboto-Regular", size: 12)
        completedTask.textColor = UIColor(red: 0.52, green: 0.71, blue: 0.37, alpha: 1.00)
        completedTask.attributedText = NSMutableAttributedString(string: AllCompletedTasks[0], attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        checkButtonThree.center.y = completedTask.center.y
        
        let lineFooter = UIView(frame: CGRect(x: 32, y: checkButtonThree.frame.maxY + 15, width: view.frame.size.width - 64, height: 1))
        lineFooter.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.00)
        
        view.addSubview(HeaderOfTaskLabel)
        view.addSubview(DescriptionOfTaskLabel)
        view.addSubview(renameTask)
        view.addSubview(line)
        view.addSubview(checkList)
        view.addSubview(checkButtonOne)
        view.addSubview(checkButtonTwo)
        view.addSubview(checkButtonThree)
        view.addSubview(lineFooter)
        view.addSubview(newTaskOnCheck)
        view.addSubview(labelTaskCheckList)
        view.addSubview(completedTask)
        
    }
    @objc func editingBegan(_ textField: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: newTaskOnCheck.frame.height, width: newTaskOnCheck.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    @objc func editingEnded(_ textField: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: newTaskOnCheck.frame.height, width: newTaskOnCheck.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 236/255, green: 239/255, blue: 245/255, alpha: 1).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    @objc func dropDownMenu(){
        tbView.isHidden = !tbView.isHidden
    }
    @objc func test(){
        print("test this button")
    }
    @objc func renameTaskTapped(){
        HeaderOfTaskLabel.isHidden = !HeaderOfTaskLabel.isHidden
        DescriptionOfTaskLabel.isHidden = !DescriptionOfTaskLabel.isHidden
        confirmRename.isHidden = !confirmRename.isHidden
        renameTextFieldHeader.isHidden = !renameTextFieldHeader.isHidden
        renameTextFieldDescription.isHidden = !renameTextFieldDescription.isHidden
        renameTextFieldHeader.text = HeaderOfTaskLabel.text
        renameTextFieldDescription.text = DescriptionOfTaskLabel.text
        
    }
    @objc func confirmRenamePressed(){
        HeaderOfTaskLabel.text = renameTextFieldHeader.text
        DescriptionOfTaskLabel.text = renameTextFieldDescription.text
        confirmRename.isHidden = !confirmRename.isHidden
        renameTextFieldHeader.isHidden = !renameTextFieldHeader.isHidden
        renameTextFieldDescription.isHidden = !renameTextFieldDescription.isHidden
        HeaderOfTaskLabel.isHidden = !HeaderOfTaskLabel.isHidden
        DescriptionOfTaskLabel.isHidden = !DescriptionOfTaskLabel.isHidden
    }
    func addViewNavBar(){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 38))
        mainView.backgroundColor = UIColor(red: 0.13, green: 0.18, blue: 0.28, alpha: 1.00)
        
        let labelInView = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 38))
        labelInView.center = mainView.center
        labelInView.text = "Задача"
        labelInView.font = UIFont(name: "Roboto-Medium", size: 14)
        labelInView.textAlignment = .center
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
    func addNavBarButtonItems(){
        
        let logo = UIImageView(image: UIImage(named: "logoBlackNew"))
        let viewForLogo = UIView(frame: CGRect(x: 0, y: 0, width: Int(logo.frame.width), height: Int(logo.frame.height)))
        viewForLogo.bounds = viewForLogo.bounds.offsetBy(dx: 3, dy: 0)
        viewForLogo.addSubview(logo)
        
        let MainLogoView = UIBarButtonItem(customView: viewForLogo)
        self.navigationItem.setLeftBarButton(MainLogoView, animated: true)
        
        let but1 = UIButton(type: .custom)
        but1.setTitle(" ", for: .normal)
        but1.setBackgroundImage(NotificationImage[0], for: .normal)
        but1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let but2 = UIButton(type: .custom)
        but2.setTitle(" ", for: .normal)
        but2.setBackgroundImage(UIImage(named: "notiifcations"), for: .normal)
        but2.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        but2.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        
        let viewForBut1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        viewForBut1.bounds = viewForBut1.bounds.offsetBy(dx: 8, dy: 0)
        viewForBut1.addSubview(but1)
        
        let viewForBut2 = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        viewForBut2.bounds = viewForBut2.bounds.offsetBy(dx: 0, dy: 0.5)
        viewForBut2.addSubview(but2)
        
        let item1 = UIBarButtonItem(customView: viewForBut1)
        let item2 = UIBarButtonItem(customView: viewForBut2)
        
        self.navigationItem.setRightBarButtonItems([item2, item1], animated: true)
    }
    @objc func notificationTapped(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "Notifications") as! NotificationsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
