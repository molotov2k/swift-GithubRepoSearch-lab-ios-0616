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

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (JSON?) -> ()) {
        let url = "\(githubAPIURL)/repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
        
        Alamofire.request(.GET, url).responseJSON { (response) in
            if let data = response.data {
                completion(JSON(data: data))
            }
        }
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: (Bool) -> ()) {
        let url = "\(githubAPIURL)/user/starred/\(fullName)?client_id=\(githubClientID)&client_secret=\(githubClientSecret)&access_token=\(githubAccessToken)"
        
        Alamofire.request(.GET, url).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                completion(true)
            case .Failure:
                completion(false)
            }
        }
    }
    
    class func starRepository(fullName: String, completion: () -> ()) {
        let url = "\(githubAPIURL)/user/starred/\(fullName)?client_id=\(githubClientID)&client_secret=\(githubClientSecret)&access_token=\(githubAccessToken)"
        
        Alamofire.request(.PUT, url).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                completion()
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    class func unstarRepository(fullName: String, completion: () -> ()) {
        let url = "\(githubAPIURL)/user/starred/\(fullName)?client_id=\(githubClientID)&client_secret=\(githubClientSecret)&access_token=\(githubAccessToken)"
        
        Alamofire.request(.DELETE, url).validate().responseJSON { (response) in
            switch response.result {
            case .Success:
                completion()
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    class func searchForRepositories(keyword: String, completion: (JSON?) -> ()) {
        let params = ["q": keyword]
        let url = "https://api.github.com/search/repositories"
        Alamofire.request(.GET, url, parameters: params, encoding: .URL, headers: nil).validate().responseJSON { (response) in
            print(response)
            if let data = response.data {
                completion(JSON(data: data))
            }
        }
    }

    
    

}
