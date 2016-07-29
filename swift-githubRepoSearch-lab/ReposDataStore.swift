//
//  ReposDataStore.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    private init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(completion: () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (json) in
            self.repositories.removeAll()
            guard let json = json else { print("error: no data received from API Client"); return }
            for object in json {
                let repo = object.1
                self.repositories.append(GithubRepository(json: repo))
            }
            completion()
        }
    }
    
    func toggleStarStatusForRepository(repository: GithubRepository, toggleCompletion: (Bool) -> ()) {
        GithubAPIClient.checkIfRepositoryIsStarred(repository.fullName) { (isStarred) in
            if isStarred {
                GithubAPIClient.unstarRepository(repository.fullName, completion: {
                    toggleCompletion(false)
                })
            }
            else {
                GithubAPIClient.starRepository(repository.fullName, completion: {
                    toggleCompletion(true)
                })
            }
        }
    }
    
    func searchRepositories(keyword: String, completion: () -> ()) {
        GithubAPIClient.searchForRepositories(keyword) { (json) in
            self.repositories.removeAll()
            guard let json = json else { print("error: no data received from API Client"); return }
            for object in json["items"] {
                let repo = object.1
                self.repositories.append(GithubRepository(json: repo))
            }
            completion()
        }
    }
    
    

}
