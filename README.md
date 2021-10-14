# DTube Go

The Readme still in progress. Same goes for the code documentation and various coding style related changes that have to be made in the near future.

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Future plans](#future-plans)
* [Contribution](#contribution)

## General info
This is a flutter based DTube client to interact with the Avalon blockchain. (https://github.com/dtube/avalon/)
It includes most of the functionalities a user can do on the website https://d.tube but on a mobile device.
	
## Technologies
This client is based on api functions of the avalon blockchain which is a social media blockchain. 
The blockchain is maintained by several block producering and observer nodes and a few api nodes supplying the endpoints to interact with the blockchain.

The blockchains token is called DTube Coin (DTC).

DTube Go is created with:
* [Flutter](https://github.com/flutter/flutter) basic development framework
* [flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc) state management we decided to use
* [better_player](https://github.com/jhomlala/betterplayer) as player for videos stored on ipfs / sia 
* [youtube_player_iframe](https://github.com/sarbagyastha/youtube_player_flutter) as player for videos stored on youtube
* various other cryptography and UI related packages (see pubspec.yaml)

## Future plans
1. We are going to provide all transaction types of the avalon blockchain. Most important: 
- voting for leaders
- creating custom keys
- swapping coins with metamask
- and more
2. We are going to release the app on ios as well and probably build desktop clients with it.
3. The app will act as a keychain to log into your dtube account in web via scanning a qr code on the website.

More planned changes you can find in the issues.

## Contribution