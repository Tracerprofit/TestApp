//
//  StorageManager.swift
//  LegeartApp
//
//  Created by PRGR on 29.04.2022.
//

import UIKit
import Firebase

final class StorageManager {
    
    static let shared = StorageManager()
    let database = Database.database().reference()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void){
        self.database.child("\(path)").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    //upload picture to firebase storage and return completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else{
                //failed
                print("Ошибка загрузки даты в БД как картинки")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Ошибка получения url загрузки")
                    completion(.failure(StorageErrors.failedToGetDownloadURl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    //upload image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else{
                //failed
                print("Ошибка загрузки даты в БД как картинки")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Ошибка получения url загрузки")
                    completion(.failure(StorageErrors.failedToGetDownloadURl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    //upload video that will be sent in a conversation message
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureCompletion){
        storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else{
                //failed
                print("Ошибка загрузки даты в БД как видео")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Ошибка получения url загрузки")
                    completion(.failure(StorageErrors.failedToGetDownloadURl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    
    
    
    func getAllUsers(completion: @escaping (Result<[[String : String]], Error>) -> Void) {
        
        database.child("Users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURl
    }
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
}
