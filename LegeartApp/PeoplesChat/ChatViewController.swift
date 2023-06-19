//
//  ChatViewController.swift
//  LegeartApp
//
//  Created by PRGR on 01.02.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import SDWebImage
import AVFoundation
import AVKit

struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}
struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
extension MessageKind{
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    public var completion: (([String: String]) -> (Void))?
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
    var array = [[String: String]]()
    
    let database = Database.database().reference()
    let NotificationImage = [UIImage(named: "Anna")]
    
    public var isNewConversation = false
    public let otherUserEmail: String
    private let conversationId: String?
    
    var messages = [Message]()
    
    var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = ChatViewController.safeEmail(emailAddress: email)
        
        return Sender(photoURL: "", senderId: safeEmail, displayName: "Я")
    }
    
    init(with email: String, id: String?) {
        self.conversationId = id
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarButtonItems()
        view.backgroundColor = .cyan
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
        
        print(UserDefaults.standard.value(forKey: "email") as! String)
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
    
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    private func presentInputActionSheet(){
        let actionSheet = UIAlertController(title: "Прикрепить файл",
                                            message: "Что вы хотите прикрепить?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Фото", style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Видео", style: .default, handler: { [weak self] _ in
            self?.presentVideoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Аудио", style: .default, handler: {  _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    private func presentPhotoInputActionsheet(){
        let actionSheet = UIAlertController(title: "Прикрепить фото",
                                            message: "Откуда вы хотите прикрепить фото?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func presentVideoInputActionsheet(){
        let actionSheet = UIAlertController(title: "Прикрепить видео",
                                            message: "Откуда вы хотите прикрепить видео?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        MessagerViewController.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
            switch result {
            case .success(let messages):
//                print("success to get message \(messages)")
                guard !messages.isEmpty else {
                    return
                }
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToLastItem()
                    }
                }
                
            case .failure(let error):
                print("failed to get messages \(error)")
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = conversationId {
            listenForMessages(id: conversationId, shouldScrollToBottom: true)
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageId = createMessageId() else {
            print("failed")
            return
        }
        
        print("Sending \(text)")
        
        
        
        
        
        
        let mmessage = Message(sender: selfSender,
                              messageId: messageId,
                              sentDate: Date(),
                              kind: .text(text))
        //send message
        if isNewConversation{
            createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: mmessage, completion: { [weak self] success in
                if success{
                    print("message send")
                    self?.isNewConversation = false
                }else{
                    print("failed to send")
                }
            })
        }else{
            guard let conversationId = conversationId, let name = self.title else {
                return
            }
            
            self.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: mmessage, completion: { success in
                if success{
                    print("message sent")
                }
                else {
                    print("failed to send")
                }
            })
        }
    }
    
    func createMessageId() -> String? {
        
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return "no-user-email"
        }
        
        let safeCurrentEmail = ChatViewController.safeEmail(emailAddress: currentUserEmail)
        
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        
        print("created message id: \(newIdentifier)")
        
        return newIdentifier
    }
    
    func currentSender() -> SenderType {
        if let sender = selfSender{
            return sender
        }
        fatalError("Self Sender is nil")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func addNavBarButtonItems(){
        
//        let logo = UIImageView(image: UIImage(named: "logoBlackNew"))
//        let viewForLogo = UIView(frame: CGRect(x: 0, y: 0, width: Int(logo.frame.width), height: Int(logo.frame.height)))
//        viewForLogo.bounds = viewForLogo.bounds.offsetBy(dx: 3, dy: 0)
//        viewForLogo.addSubview(logo)
//
//        let MainLogoView = UIBarButtonItem(customView: viewForLogo)
//        self.navigationItem.setLeftBarButton(MainLogoView, animated: true)
        
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
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    //create a new conversation with target user and first message sent
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void){
        
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
            return
        }
        
        let safeEmail = ChatViewController.safeEmail(emailAddress: currentEmail)
        
        let ref = database.child("\(safeEmail)")
        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }
            
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            switch firstMessage.kind {
            
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let conversationId = "conversation_\(firstMessage.messageId)"
            
            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            let recipient_newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": safeEmail,
                "name": currentName,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            self?.database.child("\(otherUserEmail)/conversation").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                if var conversations = snapshot.value as? [[String: Any]] {
                    conversations.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversation").setValue(conversationId)
                } else {
                    self?.database.child("\(otherUserEmail)/conversation").setValue([recipient_newConversationData])
                }
            })
            
            if var conversation = userNode["conversations"] as? [[String: Any]] {
                
                conversation.append(newConversationData)
                userNode["conversation"] = conversation
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                })
                
            } else{
                userNode["conversation"] = [
                    newConversationData
                ]
                
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                })
            }
            
        })
        
    }
    
    func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        
        let messageData = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageData)
        
        var message = ""
        switch firstMessage.kind {
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let currentUserEmail = ChatViewController.safeEmail(emailAddress: myEmail)
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false,
            "name": name
        ]
        
        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        
        print("adding conve: \(conversationID)")
        
        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    
    //sends a message with target conversation and message
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void){
        //add new message
        //update sender latest message
        //update recipient latest message
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        let currentEmail = ChatViewController.safeEmail(emailAddress: myEmail)
        
        database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            let messageData = newMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageData)
            
            var message = ""
            switch newMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    message = targetUrlString
                }
                break
            case .video(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    message = targetUrlString
                }
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                return
            }
            
            let currentUserEmail = ChatViewController.safeEmail(emailAddress: myEmail)
            
            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_email": currentUserEmail,
                "is_read": false,
                "name": name
            ]
            currentMessages.append(newMessageEntry)
            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                
                strongSelf.database.child("\(currentEmail)/conversation").observeSingleEvent(of: .value, with: { snapshot in
                    guard var currentUserConversations = snapshot.value as? [[String: Any]] else {
                        completion(false)
                        return
                    }
                    
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": message
                    ]
                    var targetConversation: [String: Any]?
                    
                    var position = 0
                    
                    for conversationDictionary in currentUserConversations {
                        if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                            targetConversation = conversationDictionary
                            break
                        }
                        position += 1
                    }
                    targetConversation?["latest_message"] = updatedValue
                    
                    guard let finalConversation = targetConversation else {
                        completion(false)
                        return
                    }
                    
                    currentUserConversations[position] = finalConversation
                    strongSelf.database.child("\(currentEmail)/conversation").setValue(currentUserConversations, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        //update latest message for recipient user
                        
                        strongSelf.database.child("\(otherUserEmail)/conversation").observeSingleEvent(of: .value, with: { snapshot in
                            guard var otherUserConversations = snapshot.value as? [[String: Any]] else {
                                completion(false)
                                return
                            }
                            
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message": message
                            ]
                            var targetConversation: [String: Any]?
                            
                            var position = 0
                            
                            for conversationDictionary in otherUserConversations {
                                if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                    targetConversation = conversationDictionary
                                    break
                                }
                                position += 1
                            }
                            targetConversation?["latest_message"] = updatedValue
                            
                            guard let finalConversation = targetConversation else {
                                completion(false)
                                return
                            }
                            
                            otherUserConversations[position] = finalConversation
                            strongSelf.database.child("\(otherUserEmail)/conversation").setValue(otherUserConversations, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }
                                completion(true)
                            })
                        })
                    })
                })
            }
        })
        
    }
    
    
    @objc func notificationTapped(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "Notifications") as! NotificationsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func back(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let messageId = createMessageId(),
              let conversationId = conversationId,
              let name = self.title,
              let selfSender = selfSender else {
            return
        }
        
        if let image = info[.editedImage] as? UIImage, let imageData = image.pngData(){
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
            
            //upload image
            
            StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let urlString):
                    //ready to send photo
                    print("Uploaded message photo: \(urlString)")
                    
                    guard let url = URL(string: urlString),
                          let placeholder = UIImage(systemName: "plus") else {
                        return
                    }
                    
                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)
                    
                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
                                          kind: .photo(media))
                    
                    self?.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
                        
                        if success{
                            print("sent photo message")
                        } else {
                            print("failed to send photo message")
                        }
                        
                    })
                    
                    
                case .failure(let error):
                    print("message photo upload error \(error)")
                }
            })
        }else if let videoUrl = info[.mediaURL] as? URL {
            let fileName = "video_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".mov"
            
            StorageManager.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let urlString):
                    //ready to send photo
                    print("Uploaded message video: \(urlString)")
                    
                    guard let url = URL(string: urlString),
                          let placeholder = UIImage(systemName: "plus") else {
                        return
                    }
                    
                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)
                    
                    let message = Message(sender: selfSender,
                                          messageId: messageId,
                                          sentDate: Date(),
                                          kind: .video(media))
                    
                    self?.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message, completion: { success in
                        
                        if success{
                            print("sent photo message")
                        } else {
                            print("failed to send photo message")
                        }
                        
                    })
                    
                    
                case .failure(let error):
                    print("message photo upload error \(error)")
                }
            })
            
        }
        
        
        
        //send image
        
    }
}
extension ChatViewController: MessageCellDelegate{
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        let message = messages[indexPath.section]
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewerViewController(with: imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        case .video(let media):
            guard let videoUrl = media.url else {
                return
            }
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: videoUrl)
            present(vc, animated: true)
            
            
        default:
            break
        }
    }
}
