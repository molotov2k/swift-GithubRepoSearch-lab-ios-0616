//
//  GithubRepository.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import SwiftyJSON

class GithubRepository {
    var fullName: String
    var htmlURL: NSURL
    var repositoryID: String
    
    init(json: JSON) {
        guard let
            name = json["full_name"].string,
            id = json["id"].number?.stringValue,
            urlString = json["html_url"].string,
            url = NSURL(string: urlString)
            else { fatalError("There was an error initializing a repository object from the given data") }
        
        fullName = name
        repositoryID = id
        htmlURL = url
    }

}
