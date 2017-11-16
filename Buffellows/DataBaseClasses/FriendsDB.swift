//
//  FriendsDB.swift
//  Buffellows
//
//  Created by Eric Gambetta-Guglielmana on 11/14/17.
//  Copyright © 2017 Ashish Chatterjee. All rights reserved.
//

import Foundation
import Firebase

class FriendsDB  {
    
    public static let instance = FriendsDB()
    var friendsData  = [FriendsModel]()
    public init(){
       // FirebaseApp.configure()
    }
    
    
    let rootRef = Database.database().reference().child("Friends")
    public func addFriend(friend: FriendsModel, user: UserModel){
        
        let friendAdd = rootRef.child(friend.yourID!).child(friend.friendID!)
        let addFriend = rootRef.child(friend.friendID!).child(friend.yourID!)
        var friendsList = [String:String]()
        friendsList.updateValue("pending", forKey: "status")
        friendsList.updateValue(friend.first!, forKey: "first")
        friendsList.updateValue(friend.last!, forKey: "last")
        friendAdd.updateChildValues(friendsList, withCompletionBlock: {
            
            (error, user) in
            
            if error != nil{
                print("Friends-Database Error: \(String(describing: error?.localizedDescription))\n")
            }
            print("Friend Added to Database")
        })
        friendsList["status"] = "request"
        friendsList["first"] = user.first!
        friendsList["last"] = user.last!
        addFriend.updateChildValues(friendsList, withCompletionBlock: {
            
            (error, user) in
            
            if error != nil{
                print("Friends-Database Error: \(String(describing: error?.localizedDescription))\n")
            }
            print("Friend Request Added to Database")
        })
    }
    
    public func delFriend(friend: FriendsModel){
        rootRef.child(friend.yourID!).child(friend.friendID!).removeValue()
        print("Friend Deleted")
        
    }
    public func fetchFriends(friend: FriendsModel, completion:@escaping (_ result: String) -> Void)  {
        rootRef.child(friend.yourID!).observe( .childAdded, with: {(snapshot) in
            //print (snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let key = snapshot.key
                //print("Creating friends model array")
                let friendInfo = FriendsModel()
                friendInfo.first = dictionary["first"] as? String
                friendInfo.last = dictionary["last"] as? String
                friendInfo.status = dictionary["status"] as? String
                friendInfo.friendID = key
                self.friendsData.append(friendInfo)
                //print("Friends Model Array printing")
                
                
            }
           
            //print ("Done Fetching Users")
            completion("DataFetched")
        })
        
        
    }
    func passFriendData() -> [FriendsModel] {
        return self.friendsData
    }
}