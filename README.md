# aliens

A new Flutter application.

## Getting Started

This is a personal project designed and produced using a 
  - Dart backend 
  - Flutter frontend framework 
  - Firebase data storage system.

The game runs on mobile devices, IOS and android, and uses interval timed functions and action triggered data pulls to simulate a live server connection.

The premise of the game is you fill a lobby with 5-10 players, all live displayed on starting screen. The initial game creator can then start the game when at least 5 players have joined and then it will run a random assignment function making a majority of players "Humans" and a minority "Aliens" but only revealing to the Alien team who their teammates are.

This leaves the human team in the dark.

The group will then vote on a President and VP to run a mission recieving 3 random choices which the president will chose 2 for the VP who will choose 1 leading to a pass/fail of the round. Only the P and VP see the choices presented to them.

Using action triggered functions, such as each vote action, i called a data refresh on all connected phones simulating live server updates without a live connection. Using Firebase i was able to set local variables and conditions such as whos turn it is based on stored values in the database.

For Example:
    The President (person in 5-10 person groups whos current turn it is) is the only player who can initiate a vote on a VP. If a player tries to initiate an action a check will be done to see if their playerID matches the database ID for whos turn it is. This is done by having the database store a list of players and iterating to the next at each round end setting the current turn ID to the playerIDs in the list.
    
    
*****THIS PROJECT WAS MADE TO COMPLETE MY 3 MONTH FULLSTACK BOOTCAMP IN PYTHON AND JAVASCRIPT*****

I did the project in dart and flutter to challenge myself with new languages and frameworks as well as prepare for my upcoming internship at Spryte labs which required me to work in Dart and Flutter
