# RoadTripBuddy
My submission for the NHacks 2022 Hackathon. This app won the [Most Practical](https://nhacks-vii.devpost.com/project-gallery) Prize!

Description as copied from the [Devpost](https://devpost.com/software/roadtripbuddy):

# Inspiration

I wanted to allow drivers to focus more on actually driving than worrying about how they are going to navigate to where to want to go. When a path-altering need comes up, like that for gas or food, current navigation services require too much attention. If the app even allows you to add stops, you have to specifically choose the address of where to go. If you wanted more information about where you’re stopping or seeing other options, you’d need to open another app. If you wanted to see what the weather was like at that location, you’d need yet another app. All these maneuvers are confusing and take up precious time and attention. RoadTripBuddy solves this problem by fusing several information sources into one place, along with running its own logic to maintain the optimal route, ultimately keeping drivers more focused and roads safer.

# What it does

The app allows users to tell that they need gas, food, shopping, or hotels in the next x miles. The app then uses data from Yelp and Apple Maps to determine the places nearby. This is then fed into an optimization algorithm that only chooses the locations that are in the intended direction of travel as well as very close off track. This results in highly optimized results with very slight detours.

Similarly, users are given lots of information in one place to rank the various options for their queries. Users are presented with the Yelp rating and price summary, some images, as well as what the weather is estimated to be at that location when the user is expected to arrive there. This allows users to plan a lot easier and avoid places that are expected to be in bad weather upon arrival. All in all I'm very proud of what I've been able to do with this app in just two days and I hope you all like it!

# Design Considerations
Some of the major design considerations regarding the User interface are meant to be as practical as possible and are targeted specifically toward the original goal of the project: allowing drivers to focus on the road.

That's why, on the map screen, the screen is as simple as possible, with large buttons and large touch-targets for those buttons. This means that even a slight glance at a phone screen can allow the driver to view the important details about the navigation progress. Similarly, the business viewer only shares the amount of information that can allow a driver to choose a good stop but also without crowding their screen with distracting text and images. Users can always visit the full Yelp page of any suggested business for more 

# How I built it

Technologies:

Base app:
 - Written in Swift
  - SwiftUI
  - Alamofire
 - Available on GitHub

APIs Used:
 - Yelp Businesses API 
 - Apple MapKit and CoreLocation 
 - OpenMeteo Weather
