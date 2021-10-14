# DTube Go

DTube mobile client created in dart and flutter!
![](https://about.d.tube/img/kit/Logo_Black.png)

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Future plans](#future-plans)
* [Contribution](#contribution)
* [Communication](#communication)

## General info
This is a flutter based DTube client to interact with the Avalon blockchain. (https://github.com/dtube/avalon/)
It includes most of the functionalities a user can do on the website https://d.tube but on a mobile device.

**Important:** This readme is still in progress. 
Same goes for the code documentation and various coding style related changes that have to be made in the near future.

## Technologies
This client is based on api functions of the [avalon blockchain](https://github.com/dtube/avalon/) which is a social media blockchain. 
The blockchain is maintained by several independent `node leaders` on Avalon. They host one or more of the following components:
- block producing nodes
- observer nodes and 
- api nodes supplying the endpoints to interact with the blockchain.

The blockchains token is called DTube Coin (DTC).

DTube Go is created with:
* [Flutter](https://github.com/flutter/flutter) basic development framework
* [flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc) state management we decided to use
* [better_player](https://github.com/jhomlala/betterplayer) as player for videos stored on ipfs / sia 
* [youtube_player_iframe](https://github.com/sarbagyastha/youtube_player_flutter) as player for videos stored on youtube
* various other cryptography and UI related packages (see pubspec.yaml)

## Future plans
1. We are going to provide all transaction types of the avalon blockchain. Most important: 
- voting for node leaders
- creating custom keys
- swapping coins with metamask
- editing posts / comments
- and more
2. We are going to release the app on iOS as well and probably build desktop clients with it.
3. The app will act as a keychain to log into your dtube account in web via simply scanning a qr code on the website.

You can find more planned changes in the issues of this repository.

## Contribution
We are preparing a funding platform for future contributions to DTubeGo, [Avalon](https://github.com/dtube/avalon/) and the [DTube Website](https://github.com/dtube/dtube). Stay tuned

## Communication
You can reach the developers, node leaders and the community by joining the [DTube Discord Server](https://discord.gg/hdHf92x)

