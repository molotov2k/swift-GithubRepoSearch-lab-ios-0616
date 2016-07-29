# Github Repo Search - Swift

## Demo

This is roughly what your app should look like after you've completed the tasks described in these instructions:

<iframe width="560" height="315" src="https://www.youtube.com/embed/08vCCBNpQi0?rel=0&modestbranding=1" frameborder="0" allowfullscreen></iframe><p><a href="https://www.youtube.com/watch?v=08vCCBNpQi0">GitHub Search Demo</a></p>


## Goal

The goal is to search for repositories on Github and display the results in your tableview. The user will tap a `UIBarButtonItem` such as `Search` to display a `UIAlertController` containing a `UITextField` prompting the user to enter a query. The controller should include two `UIAlertAction`s - one to initiate the search and one to cancel (i.e. dismiss the `UIAlertController`). After the search is complete, the alert controller should be dismissed and the tableview should be reloaded with the search results. Use Alamofire instead of NSURLSession to make your network calls.

## API Calls With Alamofire and SwiftyJSON


###### 1. Declare a variable to hold a URL string connecting us to Github (use appropriate path and access token)
```
let githubURL = [NSString stringWithFormat:<githubURL>];
```
###### 2. Use appropriate HTTP verb method in your request
```
//GET data
Alamofire.request(.GET, url).responseJSON { (response) in
   //you can create a JSON object by using its initializer: JSON(data: response.data)
   //response.result will give you a success enum that you can work with (will either be .Success or .Failure)
}
```

```
// GET data with parameters

let params = [name : keyword]

Alamofire.request(.GET, url, parameters: params, encoding: .URL, headers: nil).validate().responseJSON { (response) 
	//pass data back here
}
```

```
// PUT data
Alamofire.request(.PUT, url).responseJSON { (response) in
   //you can create a JSON object by using its initializer: JSON(data: response.data)
   //response.result will give you a success enum that you can work with (will either be .Success or .Failure)
}
```

```
// DELETE data
Alamofire.request(.DELETE, url).responseJSON { (response) in
   //you can create a JSON object by using its initializer: JSON(data: response.data)
   //response.result will give you a success enum that you can work with (will either be .Success or .Failure)
}
```

## Instructions

1. Bring over your code from the github-repo-starring lab.

2. Write a method in `GithubAPIClient` that searches a repo from the text provided in the alert controller (which you will create). Take a look at the [repo search documentation](https://developer.github.com/v3/search/#search-repositories) and implement the appropriate method to do a search for repositories.

3. Add a `UIBarButtonItem` (with to your TableViewController in Storyboard. When a user taps the button, it should display a `UIAlertController` that prompts the user to enter a search query. Add a `UIAlertAction` to initiate the search. [This](http://useyourloaf.com/blog/2014/09/05/uialertcontroller-changes-in-ios-8.html) is my favorite resource on `UIAlertController`.

4. Re-implement the getRepositories and star/unstar methods using Alamofire instead of NSURLSession. If you didn't complete the Github Repo Starring lab, reference those instructions implementing the methods using Alamofire.

**Hint**: The JSON object that you serialize in your API Client contains more JSON objects. In you data store, iff you iterate through the JSON object that you receive back from the API client, you will be able to access those sub-objects. Assuming that the sub-objects are named json, each sub-object contains an index (which can be accessed by `json.0`) and the actual value (which can be accessed by `json.1` - in the case of this lab, `json.1` will give you a dictionary).

When you have the dictionary that you need, you can access the values in those dictionaries like this: `dictionary["full_name"].string` (substituting the correct value type for string`. 

