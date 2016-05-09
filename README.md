#Usage
###Register Dribble application
https://dribbble.com/account/applications/new

#Installation

###Manual
* Drag files into Xcode project
* import DribbbleSwift

###Cocoapods
```ruby
pod 'DribbbleSwift'
```

#Endpoints
##[GET](#examples-get)
- [Buckets :pouch: ](#buckets-pouch)
- [Projects :page_facing_up: ](#project-page_facing_up)
- [Shots :camera: ](#shots-camera)
- [Teams :busts_in_silhouette:](#team-busts_in_silhouette)
- [Users :bowtie: ](#users-bowtie)

##[Authenticated Request](#authenticated-request-lock)
- [Configuration] (#config)
- [Shots :camera: ](#shots)

##Examples (GET)
**REQUIRED FOR ANY GET REQUEST TO WORK**
```swift
        ConfigDS.setAccessToken("YOUR ACCESS TOKEN")
```
#Buckets :pouch:
###Get a bucket
```swift
        BucketDS.getBucket(bucketId: 377694){
            bucket in
            print(bucket.bucket?.name)
            print(bucket.bucket?.user.username)
        }
```
###List shots for a bucket
```swift
        BucketDS.getShots(bucketId: 377694){
            shots in
            print(shots.shots?.count)
            print(shots.shots?[0].title)
        }
```
# Project :page_facing_up:
###Get a project
```swift
      ProjectDS.getProject(projectId: 3){
            project in
            print(project.project?.name)
            print(project.project?.user.username)
        }
```
###List shots for a project
```swift
        ProjectDS.getShots(projectId: 3){
            shots in
            print(shots.shots?.count)
            print(shots.shots?[0].title)
        }
```

#Shots :camera:
###List Shots
Parameters
```swift
 /**
     List shots
     - parameter perPage:           Resources per page, maximum = 100
     -parameter page: Current page of resource. Default = 1
     - parameter list:              Limit the results to a specific type with the following possible values: animated, attachments, debuts, playoffs, rebounds, teams     teams
     - parameter sort:              The sort field with the following possible values: comments, recent, views. Default = .views
     - parameter timeframe:         A period of time to limit the results to with the following possible values: week, month, year, ever
     - parameter date:              Limit the timeframe to a specific date, week, month, or year. Must be in the format of YYYY-MM-DD.
     - parameter completionHandler:   return NSError, JSON and an array of shots.
     */
     
        ShotsDS.getShots(perPage: 50, list: .animated, sort: .recent){
            shotz in
            print(shotz.shots?.count)
            print(shotz.shots?[0].title)
        }
```

###List attachments for a shot
 ```swift
        ShotsDS.getAttachments(shotID: 2694049){
            atts in
            print(atts.0.json)
            print(atts.attachments?[0].url)
        }
```
###List buckets for a shot
```swift
        ShotsDS.getBuckets(shotID: 2694049, perPage: 50){
            bucks in
            print(bucks.buckets?[0].description)
        }
```  
###List comments for a shot
```swift
        ShotsDS.getComments(shotID: 2694049, perPage: 50){
            cmnts in
            print(cmnts.comments?[0].body)
        }
```
###List likes for a shot
```swift
        ShotsDS.getLikes(shotID: 2694049, perPage: 50){
            lks in
            print(lks.likes?[0].created_at)
            print(lks.likes?[0].user.username)
        }
```
###List projects for a shot
```swift
        ShotsDS.getProjects(shotID: 2698163, perPage: 50){
            projs in
            print(projs.projects?[0].name)
        }
```
###List rebounds for a shot
```swift
        ShotsDS.getRebounds(shotID: 2691323, perPage: 50){
            rbs in
            print(rbs.rebounds?[0].title)
        }
```
#Team :busts_in_silhouette:
###List a team’s members
```swift
        TeamDS.getTeamMembers("Dribbble"){
            api in
            print(api.members?[0].username)
        }
```
```swift
        TeamDS.getTeamShots("Dribbble", perPage: 10, page: 1){
            api in
            print(api.shots?[0].title)
        }
```

#Users :bowtie:
###Get a single user
```swift
        UserDS.getUser("Ramotion"){
            api in
            print(api.user?.bio)
        }
```
###List a user’s buckets
```swift
        UserDS.getBuckets("SergeyValiukh"){
            api in
            print(api.buckets?[0].name)
        }
```
###List followers of a user
```swift
        UserDS.getFollowers("simplebits", page: 1){
            api in
            print(api.followers?[0].follower.username)
            print(api.followers?[0].follower.name)
        }
```
###List users followed by a user
```swift
        UserDS.getFollowing("simplebits", perPage: 20, page: 1){
            api in
            print(api.followees?[0].followee.username)
            print(api.followees?[0].followee.bio)
            
        }
```
###Check if one user is following another
*returns true if following, else false.*
```swift
        UserDS.checkIfUserFollowingUser("dannpetty", targetUser: "SergeyValiukh"){
            api in
            print(api.isFollowing)
        }
```
###List shot likes for a user
```swift
        UserDS.getLikes("simplebits", perPage: 20, page: 1){
            api in
            print(api.likes?[0].shot.title)
            print(api.likes?[0].shot.user.username)
        }
```
###List a user’s projects
```swift
        UserDS.getProjects("simplebits", perPage: 10, page: 1){
            api in
            print(api.projects?[0].name)
        }
```
###List shots for a user
```swift
        
        UserDS.getShots("simplebits", perPage: 10, page: 3){
            api in
            print(api.shots?[0].title)
        }
```

###List a user’s teams
```swift
        UserDS.getTeams("simplebits"){
            api in
            print(api.teams?[0].name)
            print(api.teams?[0].members_count)
        }
```

#Authenticated Request :lock:
http://developer.dribbble.com/v1/oauth/ for more information about authentication process.
###Config
*MUST SET CONFIG TOKEN BEFORE ANY AUTHENTICATED REQUEST CAN BE EXECUTED*
```swift
ConfigDS.setOAuth2Token("OAUTH2 TOKEN RECEIVED")
```

##Shots
`Liking and Unliking shot requires the user to be authenticated with the write scope.`

###Like a shot
```swift
 ShotsDS.likeShot(shotId: "2678120"){
            api in
            print(api.statusCode)
            print(api.success)
        }
```
###Unlike a shot
```swift
ShotsDS.unlikeShot(shotId: "2678120"){
            api in
            print(api.statusCode)
            print(api.unliked)
            
        }
```
###Checking if user liked a shot
```swift
ShotsDS.checkIfShotLiked(shotId: "2687276"){
            api in
            print(api.statusCode)
            print(api.liked)
        }
```
#Users
###Get the authenticated user
```swift
 UserDS.getUser("Ramotion"){user _ in}
```
###List a user’s buckets
```swift
 UserDS.getAuthenticatedUserBuckets(perPage: 10, page: 1){bks in print(bks.0.json)   }
```
###List the authenticated user’s followers
```swift
 UserDS.getAuthenticatedUserFollowers(perPage: 10, page: 1){ flwrs in print(flwrs.followers?.count)}
```
###List who the authenticated user is following
```swift
 UserDS.getAuthenticatedUserFollowing(perPage: 10, page: 2){ fllwee in print(fllwee.followees?.count)}
```

 
