//
//  ReposTableViewController.swift
//  swift-githubRepoSearch-lab
//
//  Created by Haaris Muneer on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    let githubAPIClient = GithubAPIClient()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        githubAPIClient.delegate = self
        self.keywordAlert()
    }
    
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        self.keywordAlert()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
        let currentRepo = self.store.repositories[indexPath.row]
        cell.textLabel?.text = currentRepo.fullName
        cell.detailTextLabel?.text = currentRepo.language
        
        if currentRepo.starred {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRepo = self.store.repositories[indexPath.row]
        
        if selectedRepo.starred {
            self.githubAPIClient.removeStar(selectedRepo, completion: { 
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                })
            })
        } else {
            self.githubAPIClient.addStar(selectedRepo, completion: { 
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                })
            })
        }

    }
    
    
    func keywordAlert() {
        let alert = UIAlertController(title: "Enter search keyword", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { textfield in
            textfield.placeholder = "keyword"
        }
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: { action in
            let textField = alert.textFields![0] as UITextField
            let keyword = textField.text!
            self.githubAPIClient.requestRepos(keyword)
        })
        
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
}


extension ReposTableViewController: GitHubAPIClientDelegate {
    
    func showAlert(title title: String, message: String, sender: GithubAPIClient) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func disableUserInteraction(sender: GithubAPIClient) {
        self.tableView.userInteractionEnabled = false
    }
    
    func reloadData(sender: GithubAPIClient) {
        self.tableView.userInteractionEnabled = true
        self.tableView.reloadData()
    }
    
    
}