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
    
    let fullName: String
    let language: String
    var starred: Bool
    
    init(fullName: String?, language: String?, starred: Bool ) {
        
        if let fullName = fullName {
            self.fullName = fullName
        } else {
            self.fullName = "Unable to retrieve name"
        }
        
        if let language = language {
            self.language = language
        } else {
            self.language = "Unknown language"
        }
        
        self.starred = starred
        
    }

    
}
