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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GithubAPIClient.searchForRepositories("swift") { (json) in
            
        }
        
        store.getRepositoriesWithCompletion {
                self.tableView.reloadData()
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.repositories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        
        let repository:GithubRepository = self.store.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRepo = store.repositories[indexPath.row]
        store.toggleStarStatusForRepository(selectedRepo) { (isStarred) in
            if isStarred {
                dispatch_async(dispatch_get_main_queue(), {
                    self.createAlert("You just starred", repoFullName: selectedRepo.fullName)
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.createAlert("You just unstarred", repoFullName: selectedRepo.fullName)
                })
            }
        }
    }
    
    func createAlert(message: String, repoFullName: String) {
        let alertMessage = "\(message) \(repoFullName)"
        let alertController = UIAlertController(title: "Success!", message: alertMessage, preferredStyle: .Alert)
        alertController.accessibilityLabel = alertMessage
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(ok)
        ok.accessibilityLabel = "OK"
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Search Repos", message: "Enter a search term", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (searchField) in
            searchField.placeholder = NSLocalizedString("Search term", comment: "Search")
        }
        
        let search = UIAlertAction(title: "Search", style: .Default) { (searchAction) in
            if let textFields = alertController.textFields, text = textFields[0].text {
                self.reloadTableWithSearchTerm(text)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(search)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func reloadTableWithSearchTerm(term: String) {
        store.searchRepositories(term) { 
            self.tableView.reloadData()
        }
    }

}
