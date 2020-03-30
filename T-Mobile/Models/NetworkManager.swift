//
//  NetworkManager.swift
//  T-Mobile
//
//  Created by Kevin Tanner on 3/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var searchUsers: [SearchUser] = []
    var users: [User] = []
    var userRepos: [UserRepo] = []
    
    func getUsers(for username: String, complete: @escaping ([SearchUser]?) -> Void) {
        guard let baseURL = URL(string: "https://api.github.com/search/users") else { complete(nil); return }
        
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { return }
        let searchQuery = URLQueryItem(name: "q", value: username)
        urlComponents.queryItems = [searchQuery]
        
        guard let finalURL = urlComponents.url else { return }
        print(finalURL)
        let dataTask = URLSession.shared.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { complete(nil); return }
            
            if let error = error {
                print("\nThere was an error in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
                complete(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { complete(nil); return }

            guard let data = data else {
                print("There was an error getting data in \(#function). There was no data.")
                complete(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let topLevel = try decoder.decode(TopLevel.self, from: data)
                self.searchUsers = topLevel.items
                complete(topLevel.items)
                
            } catch {
                print("\nThere was an error decoding JSON in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
                complete(nil)
                return
            }
        }
        dataTask.resume()
    }

    
    
    
    func getUserInfo(for username: String, complete: @escaping (User?) -> Void) {
        guard let baseURL = URL(string: "https://api.github.com/users/") else { complete(nil); return }
        
        var finalURL = baseURL
        finalURL.appendPathComponent(username)
        
        print(finalURL)
        
        let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("\nThere was an error in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
                complete(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { complete(nil); return }

            guard let data = data else {
                print("There was an error getting data in \(#function). There was no data.")
                complete(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                complete(user)
                
            } catch {
                print("\nThere was an error decoding JSON in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
                complete(nil)
                return
            }
        }
        dataTask.resume()
    }
    
    func getUserRepos(for username: String, complete: @escaping ([UserRepo]?) -> Void) {
        guard let baseURL = URL(string: "https://api.github.com/users/") else { complete(nil); return }
        
        var finalURL = baseURL
        finalURL.appendPathComponent(username)
        finalURL.appendPathComponent("repos")
        
        print(finalURL)
        
        let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("\nThere was an error in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
                complete(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { complete(nil); return }

            guard let data = data else {
                print("There was an error getting data in \(#function). There was no data.")
                complete(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userRepos = try decoder.decode([UserRepo].self, from: data)
                self.userRepos = userRepos
                print(userRepos)
                complete(userRepos)
                
            } catch {
                print("\nThere was an error decoding JSON in \(#function)\nError: \(error)\nError.localizedDescription: \(error.localizedDescription)\n")
                complete(nil)
                return
            }
        }
        dataTask.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: urlString) else { completed(nil); return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else { completed(nil); return }
            
            completed(image)
        }
        dataTask.resume()
    }
}
