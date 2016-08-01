//
//  GithubAPIClient.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


protocol GitHubAPIClientDelegate: class {
    func showAlert(title title: String, message: String, sender: GithubAPIClient)
    func reloadData(sender: GithubAPIClient)
    func disableUserInteraction(sender: GithubAPIClient)
}


class GithubAPIClient {

    weak var delegate: GitHubAPIClientDelegate?
    
    let store = ReposDataStore.sharedInstance
    
    let reposURL = "https://api.github.com/search/repositories"
    let starURL = "https://api.github.com/user/starred/"
    let headers = ["Authorization": Secrets().token]
    
    
    func requestRepos(withName: String) {
        self.store.repositories.removeAll()
        self.delegate?.disableUserInteraction(self)
        
        Alamofire.request(.GET, reposURL, parameters: ["q": withName], headers: headers).responseJSON { data in
            if let result = data.result.value {
                let json = JSON(result)
                if let items = json["items"].array {
                    for item in items {
                        let fullName = item["full_name"].string
                        let language = item["language"].string
                        let repo = GithubRepository.init(fullName: fullName, language: language, starred: false)
                        
                        self.store.repositories.append(repo)
                    }
                }
            } else {
                self.delegate?.showAlert(title: "ERROR", message: "can't get repositories", sender: self)
            }
            
            if self.store.repositories.isEmpty {
                self.delegate?.showAlert(title: "NO RESULTS", message: "no repositories found", sender: self)
            } else {
                self.checkForStars({
                    self.delegate?.reloadData(self)
                })
            }
        }
    }
    
    
    func checkForStars(completion: () -> Void) {
        for (index, repo) in self.store.repositories.enumerate() {
            self.starCheck(repo, completion: { 
                if index == self.store.repositories.count - 1 {
                    completion()
                }
            })
        }
    }
    
    
    func starCheck(repo: GithubRepository, completion: () -> Void) {
        var currentRepoStarURL = starURL
        currentRepoStarURL.appendContentsOf(repo.fullName)
        Alamofire.request(.GET, currentRepoStarURL, headers: headers).responseJSON { data in
            if let statusCode = data.response?.statusCode {
                if statusCode == 404 {
                    repo.starred = false
                } else if statusCode == 204 {
                    repo.starred = true
                }
            }
            completion()
        }
        
    }
    
    
    func addStar(repo: GithubRepository, completion: () -> Void) {
        var currentRepoStarURL = starURL
        currentRepoStarURL.appendContentsOf(repo.fullName)
        Alamofire.request(.PUT, currentRepoStarURL, headers: headers).responseJSON { data in
            if let statusCode = data.response?.statusCode {
                if statusCode == 204 {
                    repo.starred = true
                    self.delegate?.showAlert(title: "SUCCESS", message: "repository is now starred", sender: self)
                } else {
                    self.delegate?.showAlert(title: "ERROR", message: "failed to star repository", sender: self)
                }
            }
            completion()
        }
    }
    
    
    func removeStar(repo: GithubRepository, completion: () -> Void) {
        var currentRepoStarURL = starURL
        currentRepoStarURL.appendContentsOf(repo.fullName)
        Alamofire.request(.DELETE, currentRepoStarURL, headers: headers).responseJSON { data in
            if let statusCode = data.response?.statusCode {
                if statusCode == 204 {
                    repo.starred = false
                    self.delegate?.showAlert(title: "SUCCESS", message: "repository unstarred", sender: self)
                } else {
                    self.delegate?.showAlert(title: "ERROR", message: "failed to remove star", sender: self)
                }
            }
            completion()
        }
    }
    
    
}
