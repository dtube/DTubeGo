import 'package:dtube_go/bloc/transaction/transaction_response_model.dart';
import 'package:dtube_go/bloc/user/user_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {}

class SignAndSendTransactionEvent extends TransactionEvent {
  SignAndSendTransactionEvent(this.tx);
  Transaction tx;

  @override
  List<Object> get props => List.empty();
}

class SendCommentEvent extends TransactionEvent {
  SendCommentEvent(
    this.uploadData,
  );
  UploadData uploadData;

  @override
  List<Object> get props => List.empty();
}

class ChangeProfileData extends TransactionEvent {
  ChangeProfileData(
    this.userData,
  );
  User userData;

  @override
  List<Object> get props => List.empty();
}

class SetInitState extends TransactionEvent {
  SetInitState();

  @override
  List<Object> get props => List.empty();
}

// used only for uploading videos
class TransactionPreprocessing extends TransactionEvent {
  TransactionPreprocessing({required this.txType});
  final int txType;
  @override
  List<Object> get props => List.empty();
}

// used only for uploading videos
class TransactionPreprocessingFailed extends TransactionEvent {
  String errorMessage;
  TransactionPreprocessingFailed({required this.errorMessage});
  @override
  List<Object> get props => List.empty();
}


// https://github.com/dtube/dtube/blob/master/client/broadcast.js
// comment: function(permlink, parentAuthor, parentPermlink, jsonMetadata, tag, isEditing, cb, newWif, publishVP) {
//             if (!permlink) {
//                 permlink = Template.publish.randomPermlink(11)
//                 if (jsonMetadata.videoId)
//                     permlink = String(jsonMetadata.videoId)
//             }
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(4) == -1)
//                 return missingPermission.handler('COMMENT',
//                     (newWif)=>broadcast.avalon.comment(permlink,parentAuthor,parentPermlink,jsonMetadata,tag,isEditing,cb,newWif),
//                     ()=>cb('missing required permission COMMENT'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             let weight = UserSettings.get('voteWeight') * 100
//             let tx = {
//                 type: 4,
//                 data: {
//                     link: permlink,
//                     json: jsonMetadata,
//                     vt: Math.floor(avalon.votingPower(activeuser) * weight / 10000)
//                 }
//             }
//             if (publishVP) tx.data.vt = publishVP
//             if (isEditing) tx.data.vt = 1 // Spend only 1 VP for editing existing content
//             if (tag) tx.data.tag = tag
//             else tx.data.tag = ""
//             if (parentAuthor && parentPermlink) {
//                 tx.data.pa = parentAuthor
//                 tx.data.pp = parentPermlink
//             }
//             tx = avalon.sign(wif, voter, tx)
//             avalon.sendTransaction(tx, function(err, res) {
//                 if (!err) res = tx.sender + '/' + tx.data.link
//                 cb(err, res)
//                 Users.refreshUsers([Session.get('activeUsername')])
//             })
//             return;
//         },
//         promotedComment: function(permlink, parentAuthor, parentPermlink, jsonMetadata, tag, burn, cb, newWif, publishVP) {
//             if (!permlink) {
//                 permlink = Template.publish.randomPermlink(11)
//                 if (jsonMetadata.videoId)
//                     permlink = String(jsonMetadata.videoId)
//             }
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // can be cross posted but wont be promoted on steem
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(13) == -1)
//                 return missingPermission.handler('PROMOTED_COMMENT',
//                     (newWif)=>broadcast.avalon.promotedComment(permlink,parentAuthor,parentPermlink,jsonMetadata,tag,burn,cb,newWif),
//                     ()=>cb('missing required permission PROMOTED_COMMENT'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             let weight = UserSettings.get('voteWeight') * 100
//             let tx = {
//                 type: 13,
//                 data: {
//                     link: permlink,
//                     json: jsonMetadata,
//                     burn: burn,
//                     vt: Math.floor(avalon.votingPower(activeuser) * weight / 10000)
//                 }
//             }
//             if (publishVP) tx.data.vt = publishVP
//             if (tag) tx.data.tag = tag
//             else tx.data.tag = ""
//             if (parentAuthor && parentPermlink) {
//                 tx.data.pa = parentAuthor
//                 tx.data.pp = parentPermlink
//             }
//             tx = avalon.sign(wif, voter, tx)
//             avalon.sendTransaction(tx, function(err, res) {
//                 if (!err) res = tx.sender + '/' + tx.data.link
//                 cb(err, res)
//                 Users.refreshUsers([Session.get('activeUsername')])
//             })
//             return;
//         },
//         vote: function(author, permlink, weight, tag, tip, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // cross vote possible
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && tip <= 0 && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(5) == -1)
//                 return missingPermission.handler('VOTE',
//                     (newWif)=>broadcast.avalon.vote(author,permlink,weight,tag,tip,cb,newWif),
//                     ()=>cb('missing required permission VOTE'))
//             else if (!newWif && tip > 0 && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(19) == -1)
//                 return missingPermission.handler('TIPPED_VOTE',
//                         (newWif)=>broadcast.avalon.vote(author,permlink,weight,tag,tip,cb,newWif),
//                         ()=>cb('missing required permission TIPPED_VOTE'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             let vt = Math.floor(avalon.votingPower(activeuser) * weight / 10000)
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 5,
//                     data: {
//                         author: author,
//                         link: permlink,
//                         vt: vt,
//                         tag: tag
//                     }
//                 }
//                 if (tip > 0) {
//                     tx = {
//                        type: 19,
//                         data: {
//                             author: author,
//                             link: permlink,
//                             vt: vt,
//                             tag: tag,
//                             tip: tip
//                         }
//                     }
//                 }
//                 tx = avalon.sign(wif, voter, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                     Users.refreshUsers([Session.get('activeUsername')])
//                 })
//                 return;
//             }
//         },
//         follow: function(following, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // cross follow possible
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(7) == -1)
//                 return missingPermission.handler('FOLLOW',
//                     (newWif)=>broadcast.avalon.follow(following,cb,newWif),
//                     ()=>cb('missing required permission FOLLOW'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 7,
//                     data: {
//                         target: following
//                     }
//                 }
//                 tx = avalon.sign(wif, voter, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         unfollow: function(following, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // cross unfollow possible
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(8) == -1)
//                 return missingPermission.handler('UNFOLLOW',
//                     (newWif)=>broadcast.avalon.unfollow(following,cb,newWif),
//                     ()=>cb('missing required permission UNFOLLOW'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 8,
//                     data: {
//                         target: following
//                     }
//                 }
//                 tx = avalon.sign(wif, voter, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         transfer: function(receiver, amount, memo, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // avalon only
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(3) == -1)
//                 return missingPermission.handler('TRANSFER',
//                     (newWif)=>broadcast.avalon.transfer(receiver,amount,memo,cb,newWif),
//                     ()=>cb('missing required permission TRANSFER'))
//             let sender = activeuser.username
//             if (!sender) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 3,
//                     data: {
//                         receiver: receiver,
//                         amount: amount,
//                         memo: memo
//                     }
//                 }
//                 tx = avalon.sign(wif, sender, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         editProfile: function(json, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // avalon only - steemitwallet.com for steem
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(6) == -1)
//                 return missingPermission.handler('USER_JSON',
//                     (newWif)=>broadcast.avalon.editProfile(json,cb,newWif),
//                     ()=>cb('missing required permission USER_JSON'))
//             let creator = activeuser.username
//             if (!creator) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 6,
//                     data: {
//                         json: json
//                     }
//                 }
//                 tx = avalon.sign(wif, creator, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         newAccount: function(username, pub, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // avalon only
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(0) == -1)
//                 return missingPermission.handler('NEW_ACCOUNT',
//                     (newWif)=>broadcast.avalon.newAccount(username,pub,cb,newWif),
//                     ()=>cb('missing required permission NEW_ACCOUNT'))
//             let creator = activeuser.username
//             if (!creator) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 0,
//                     data: {
//                         name: username,
//                         pub: pub
//                     }
//                 }
//                 tx = avalon.sign(wif, creator, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         newKey: function(id, pub, types, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // avalon only
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(10) == -1)
//                 return missingPermission.handler('NEW_KEY',
//                     (newWif)=>broadcast.avalon.newKey(id,pub,types,cb,newWif),
//                     ()=>cb('missing required permission NEW_KEY'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 10,
//                     data: {
//                         id: id,
//                         pub: pub,
//                         types: types
//                     }
//                 }
//                 tx = avalon.sign(wif, voter, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         removeKey: function(id, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // avalon only
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(11) == -1)
//                 return missingPermission.handler('REMOVE_KEY',
//                     (newWif)=>broadcast.avalon.removeKey(id,cb,newWif),
//                     ()=>cb('missing required permission REMOVE_KEY'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 11,
//                     data: {
//                         id: id
//                     }
//                 }
//                 tx = avalon.sign(wif, voter, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         changePassword: (pub, cb, newWif) => {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // avalon only
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(12) == -1)
//                 return missingPermission.handler('CHANGE_PASSWORD',
//                     (newWif)=>broadcast.avalon.changePassword(pub,cb,newWif),
//                     ()=>cb('missing required permission CHANGE_PASSWORD'))
//             let voter = activeuser.username
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (voter && wif) {
//                 let tx = {
//                     type: 12,
//                     data: {
//                         pub: pub
//                     }
//                 }
//                 tx = avalon.sign(wif, voter, tx)
//                 avalon.sendTransaction(tx, (err, res) => cb(err, res))
//                 return
//             }
//         },
//         voteLeader: function(target, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // avalon only
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(1) == -1)
//                 return missingPermission.handler('APPROVE_NODE_OWNER',
//                     (newWif)=>broadcast.avalon.voteLeader(target,cb,newWif),
//                     ()=>cb('missing required permission APPROVE_NODE_OWNER'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 1,
//                     data: {
//                         target: target
//                     }
//                 }
//                 tx = avalon.sign(wif, voter, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         unvoteLeader: function(target, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//                 // avalon only
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(2) == -1)
//                 return missingPermission.handler('DISAPPROVE_NODE_OWNER',
//                     (newWif)=>broadcast.avalon.unvoteLeader(target,cb,newWif),
//                     ()=>cb('missing required permission DISAPPROVE_NODE_OWNER'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 2,
//                     data: {
//                         target: target
//                     }
//                 }
//                 tx = avalon.sign(wif, voter, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         claimReward: function(author, link, cb, newWif) {
//             if (!Session.get('activeUsername') || Session.get('isDTCDisabled')) return
//             let activeuser = Users.findOne({username: Session.get('activeUsername'), network: 'avalon'})
//             if (!newWif && activeuser.allowedTxTypes && activeuser.allowedTxTypes.indexOf(17) == -1)
//             return missingPermission.handler('CLAIM_REWARD',
//                     (newWif)=>broadcast.avalon.claimReward(author,link,cb,newWif),
//                     ()=>cb('missing required permission CLAIM_REWARD'))
//             let voter = activeuser.username
//             if (!voter) return;
//             let wif = activeuser.privatekey
//             if (newWif) wif = newWif
//             if (wif) {
//                 let tx = {
//                     type: 17,
//                     data: {
//                         author: author,
//                         link: link
//                     }
//                 }
//                 tx = avalon.sign(wif, voter, tx)
//                 avalon.sendTransaction(tx, function(err, res) {
//                     cb(err, res)
//                 })
//                 return;
//             }
//         },
//         decrypt_memo: (memo,cb) => {
//             let username = Users.findOne({ username: Session.get('activeUsername'), network: 'avalon' }).username
//             let wif = Users.findOne({ username: Session.get('activeUsername'), network: 'avalon' }).privatekey
//             if (!username || !wif) return
//             avalon.decrypt(wif,memo,(e,decrypted) => {
//                 if (e)
//                     cb(e.error)
//                 else
//                     cb(null,decrypted)
//             })
//         }
//     },
//     hive: {
//         comment: function(permlink, parentAuthor, parentPermlink, body, jsonMetadata, tags, cb) {
//             if (!permlink) permlink = Template.publish.randomPermlink(11)
//             if (!parentAuthor) parentAuthor = ''
//             if (!parentPermlink) parentPermlink = 'hive-196037'
//             if (!Session.get('activeUsernameHive') || Session.get('isHiveDisabled')) return
//             let voter = Users.findOne({ username: Session.get('activeUsernameHive'), network: 'hive' }).username
//             if (!voter) return;
//             let author = Session.get('activeUsernameHive')
//             let title = jsonMetadata.title
//             finalTags = ['dtube']

//             for (let i = 0; i < tags.length; i++)
//                 if (finalTags.indexOf(tags[i]) == -1)
//                     finalTags.push(tags[i])

//             if (!body)
//                 body = genSteemBody(author, permlink, jsonMetadata)

//             var jsonMetadata = {
//                 video: jsonMetadata,
//                 tags: finalTags,
//                 app: Meteor.settings.public.app
//             }

//             let percent_hbd = 10000
//             if ($('input[name=powerup]')[0] && $('input[name=powerup]')[0].checked)
//                 percent_hbd = 0

//             let operations = [
//                 ['comment',
//                     {
//                         parent_author: '',
//                         parent_permlink: 'dtube',
//                         author: author,
//                         category: 'hive-196037',
//                         permlink: permlink,
//                         title: title,
//                         body: body,
//                         json_metadata: JSON.stringify(jsonMetadata)
//                     }
//                 ],
//                 ['comment_options', {
//                     author: author,
//                     permlink: permlink,
//                     max_accepted_payout: '1000000.000 HBD',
//                     percent_hbd: percent_hbd,
//                     allow_votes: true,
//                     allow_curation_rewards: true,
//                     extensions: [
//                         [0, {
//                             beneficiaries: [{
//                                 account: Meteor.settings.public.beneficiary,
//                                 weight: Session.get('remoteSettings').dfees
//                             }]
//                         }]
//                     ]
//                 }]
//             ]

//             operations[0][1].parent_author = parentAuthor
//             operations[0][1].parent_permlink = parentPermlink
//             broadcast.hive.send(operations, function(err, res) {
//                 if (!err && res && res.operations)
//                     res = res.operations[0][1].author + '/' + res.operations[0][1].permlink
//                 if (!err && res && res.data && res.data.operations)
//                     res = res.data.operations[0][1].author + '/' + res.data.operations[0][1].permlink
//                 cb(err, res)
//             })
//         },
//         vote: function(author, permlink, weight, cb) {
//             if (!Session.get('activeUsernameHive') || Session.get('isHiveDisabled')) return
//             let voter = Users.findOne({ username: Session.get('activeUsernameHive'), network: 'hive' })
//             if (!voter.username) return;

//             if (voter.type == "keychain") {
//                 if (!hive_keychain) {
//                     return cb('LOGIN_ERROR_KEYCHAIN_NOT_INSTALLED')
//                 }
//                 hive_keychain.requestVote(Session.get('activeUsernameHive'), permlink, author, weight, function(response) {
//                     console.log(response);
//                     cb(response.error, response)
//                 })
//                 return
//             }

//             let wif = voter.privatekey
//             if (wif) {
//                 hive.broadcast.vote(wif, voter, author, permlink, weight, function(err, result) {
//                     cb(err, result)
//                 })
//                 return
//             }
//         },
//         subHive: () => {
//             if (!Session.get('activeUsernameHive') || Session.get('isHiveDisabled')) return
//             let voter = Users.findOne({ username: Session.get('activeUsernameHive'), network: 'hive' })
//             if (!voter.username) return;

//             let operations = JSON.stringify(
//                 ['subscribe', {
//                     community: "hive-196037"
//                 }]
//             )

//             // Hive Keychain
//             if (voter.type == "keychain") {
//                 if (!hive_keychain) {
//                     return cb('LOGIN_ERROR_HIVE_KEYCHAIN_NOT_INSTALLED')
//                 }
//                 hive_keychain.requestCustomJson(voter.username, "community", "Posting", operations, "community", (response) => {
//                     cb(response.error, response)
//                 })
//                 return
//             }
//             let wif = voter.privatekey
//             if (wif) hive.broadcast.customJson(
//                 wif, [], [voter.username],
//                 'community',
//                 operations,
//                 (err, result) => cb(err, result)
//             )
//         },
//         send: (operations, cb) => {
//             if (!Session.get('activeUsernameHive') || Session.get('isHiveDisabled')) return
//             let voter = Users.findOne({ username: Session.get('activeUsernameHive'), network: 'hive' }).username
//             if (!voter) return;

//             if (Users.findOne({ username: Session.get('activeUsernameHive'), network: 'hive' }).type == "keychain") {
//                 if (!hive_keychain) return cb('LOGIN_ERROR_HIVE_KEYCHAIN_NOT_INSTALLED')

//                 hive_keychain.requestBroadcast(voter, operations, "Posting", (response) => {
//                     console.log(response);
//                     cb(response.error, response)
//                 })
//                 return
//             }

//             let wif = Users.findOne({ username: Session.get('activeUsernameHive'), network: 'hive' }).privatekey
//             if (wif) {
//                 hive.broadcast.send({ operations: operations, extensions: [] }, { posting: wif },
//                     function(err, result) {
//                         cb(err, result)
//                     }
//                 )
//                 return
//             }
//         },
//         decrypt_memo: (memo, cb) => {
//             if (!Session.get('activeUsernameHive')) return
//             if (Users.findOne({ username: Session.get('activeUsernameHive'), network: 'hive' }).type == 'keychain') {
//                 if (!hive_keychain) return cb(translate('LOGIN_ERROR_HIVE_KEYCHAIN_NOT_INSTALLED'))
//                 hive_keychain.requestVerifyKey(Session.get('activeUsernameHive'), memo, 'Posting', (response) => {
//                     cb(response.error, response.result.substr(1))
//                 })
//                 return
//             }
//             let wif = Users.findOne({ username: Session.get('activeUsernameHive'), network: 'hive' }).privatekey
//             let decoded = hive.memo.decode(wif, memo).substr(1)
//             cb(null, decoded)
//         }
//     }