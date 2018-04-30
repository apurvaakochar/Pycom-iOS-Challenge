## Pycom iOS Challenge

### UI

The app comprises of two views: **Feed** and **FullScreen**.

• Feed displays the images fetched from [Flickr](https://www.flickr.com) in a vertical flow

• It displays one picture in a row

• The width of the cell is equal to the height and adjusts itself according to the screen size

• On being tapped, it takes to the FullScreen View of the Image

• FullScreen View is like the Photos Gallery where one can **horizontally scroll** through images

• An Alert View is shown to address error scenarios

• Activity Indicators are shown when a feed is loaded

![alt text](https://raw.githubusercontent.com/apurvaakochar/Pycom-iOS-Challenge/blob/master/feed.png)

![alt text](https://raw.githubusercontent.com/apurvaakochar/Pycom-iOS-Challenge/blob/master/fullscreen.png)

### Architecture

• MVVM-R was used, wherein R stands for Router, which manages the navigation and data transfer between views 

• Protocols and extensions were used to segregate Presentation Logic from Business Logic

• However, MVVM has its drawback of mixing the two logics

• An Additional layer of Presenter can serve the purpose for future usage

• Fetched URLs are stored in the CoreData to use cached images during offline mode

• SDWebImage fetches the cached images from the URL during offline mode

• Closures were used for Observer Mechanism

![alt text](https://raw.githubusercontent.com/apurvaakochar/Pycom-iOS-Challenge/blob/master/PycomiOSChallenge.png)


### Unit Tests

• Tested the FlickrAPI

• Tested Offline Scenario

• Tested data transfer between view controllers

### Xib vs. Storyboards

• In this scenario, both .Xib and Storyboards could have been used

• Storyboards were chosen as there were very few pages

• However, in case of multiple developers or too many pages, I prefer to use .Xib, as storyboards are slow and less flexible

### Libraries

[SDWebImage](https://github.com/rs/SDWebImage)

**Apurva Kochar**
