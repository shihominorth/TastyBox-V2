//
//  userPageTableViewController.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-07.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Crashlytics

class MyPageViewController: UIViewController {
    
    @IBOutlet var profileTableView: UITableView!
    
    let dataManager = MyPageDataManager()
    
    let uid = Auth.auth().currentUser?.uid
    
    var recipeList = [RecipeDetail]()
    var imageList = [UIImage]()
    var urlList = [String]()
    var ridList = [String]()
    var followers:[String] = []
    var following:[String] = []
    var user: User?
    var userImage: UIImage?
    var numberSavedRecipes = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange ]
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.allowsSelection = false
        
        dataManager.delegate = self
        dataManager.getUserDetail(id: uid!)
        let db = Firestore.firestore()
        let queryRef = db.collection("recipe").whereField("userID", isEqualTo: uid as Any).order(by: "time", descending: true)
        recipeList = dataManager.Data(queryRef: queryRef)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.followers.removeAll()
        self.following.removeAll()
        
        dataManager.findFollowerFollowing(id: uid)
        dataManager.getUserImage(uid: uid!)
        dataManager.getSavedRecipes()
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(identifier: "settingPage")
        
        guard self.navigationController?.topViewController == self else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? FollowerFollowingPageViewController {
            
            nextVC.userID = uid!
            nextVC.followersID = followers
            nextVC.followingsID = following
            
            if segue.identifier == "following" {
                
                nextVC.titleVC = "Following"
                
            }
            if segue.identifier == "follower" {
                
                nextVC.titleVC = "Follower"
                
            }
        }
        
    }
    
    @IBAction func postedButtonTapped(_ sender: Any) {
           self.view.frame.origin.y = -195.0
       }
       
       
       // MARK: cant tap image although put tap recognizer.
       @IBAction func changeAccountImage(_ sender: UITapGestureRecognizer) {
           let imagePickerVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "imagePickerVC")
           
           guard self.navigationController?.topViewController == self else { return }
           navigationController?.pushViewController(imagePickerVC, animated: true)
       }
    
    @IBAction func postedButtonAction(_ sender: Any) {
        
        self.profileTableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
    }
    
}

extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 //4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "Main User Page", for: indexPath) as? mainUserProfileTableViewCell)!
            
            cell.userImageView?.image = self.userImage
            
            
            if Auth.auth().currentUser?.displayName == nil {
                cell.userNameLabel.text = self.user?.name
            }
            
            return cell
        }
            
        else if section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "show the num", for: indexPath) as? NumberTableViewCell)!
            
            cell.numOfRecipeUserPostedButton.setTitle("\(recipeList.count) \nPosted", for: .normal)
            cell.numOfRecipeUserSavedButton.setTitle("\(numberSavedRecipes) \nSaved", for: .normal)
            cell.numOfFollowerButton.setTitle("\(followers.count) \nFollowers", for: .normal)
            cell.numOfFollowingButton.setTitle("\(following.count) \nFollowings", for: .normal)
            
            return cell
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "recipeItemForUser", for: indexPath) as? userRecipeItemTableViewCell)!
        cell.delegate = self
        
        if recipeList.count != 0{
            cell.recipeData = recipeList
            
            if imageList.count >= recipeList.count {
                cell.recipeImage = imageList
                cell.collectionView.reloadData()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 135
        case 1:
            return 60
            
        case 2:
            return self.view.frame.height - ((self.view.frame.origin.y) * -1)
        //return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
}
   


extension MyPageViewController: MyPageDataManagerDelegate{
    func passSaveingRecipesNumber(number: Int) {
        self.numberSavedRecipes = 0
        self.numberSavedRecipes = number
        self.profileTableView.reloadData()
    }
    
    
    func reloadData(data:[RecipeDetail]) {
        
        recipeList = data
        
        if imageList.count == 0 {
            
            get_url_rid()
            dataManager.getImage(uid: uid!, rid: ridList)
            
            if imageList.count == 0{
                profileTableView.reloadData()
            }
        }
    }
    
    //MARK: initialized ImageList
    func reloadImg(images:[UIImage]){
        imageList = images
        
        UIView.transition(with:self.profileTableView, duration: 0.3, options: [UIView.AnimationOptions.transitionCrossDissolve], animations: {
            self.profileTableView.reloadData()
            
        }, completion: nil)
        
    }
    
    func assignUserImage(image: UIImage) {
        self.userImage = image
        self.profileTableView.reloadData()
    }
    
    func gotUserData(user: User) {
        self.user = user
        self.profileTableView.reloadData()
    }
    // MARK: initialized recipe id and image id
    
    func get_url_rid(){
        if recipeList.count != 0{
            for data in recipeList{
                urlList.append(data.image!)
                ridList.append(data.recipeID)
                
                print(data.recipeID)
                print(data.updatedDate)
                print(data.image!)
                
            }
            
        }
        
    }
    
    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String]) {
        
        self.following = followingsIDs
        self.followers = followersIDs
    }
    
    func setAccountImage(image: UIImage) {
        self.userImage = image
        self.profileTableView.reloadData()
    }
}


extension MyPageViewController: CollectionViewInsideProfileTableViewDelegate{
    func beginDragging() {
        self.profileTableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
    }
    
    func cellTaped(data: IndexPath) {
        
        let storyboard = UIStoryboard(name: "RecipeDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailvc") as! RecipeDetailViewController
        vc.userProfile = true
        vc.recipe = recipeList[data.row]
        vc.mainPhoto = imageList[data.row]
        vc.creator = self.user
        
        guard self.navigationController?.topViewController == self else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
