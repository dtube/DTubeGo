var txTypes = {
  0: 'NEW_ACCOUNT',
  1: 'APPROVE_NODE_OWNER',
  2: 'DISAPROVE_NODE_OWNER',
  3: 'TRANSFER',
  4: 'COMMENT',
  5: 'VOTE',
  6: 'USER_JSON',
  7: 'FOLLOW',
  8: 'UNFOLLOW',
  // RESHARE: 9, // not sure
  10: 'NEW_KEY',
  11: 'REMOVE_KEY',
  12: 'CHANGE_PASSWORD',
  13: 'PROMOTED_COMMENT',
  14: 'TRANSFER_VT',
  15: 'TRANSFER_BW',
  16: 'LIMIT_VT',
  17: 'CLAIM_REWARD',
  18: 'ENABLE_NODE',
  19: 'TIPPED_VOTE'
};

var txTypeFriendlyDescriptionNotifications = {
  0: 'NEW_ACCOUNT',
  1: 'voted for you as chain leader', //'APPROVE_NODE_OWNER',
  2: 'unvoted you as chain leader', //'DISAPROVE_NODE_OWNER',
  3: 'sent you ##DTCAMOUNT DTC', //'TRANSFER',
  4: 'commented on your content', // 'COMMENT',
  5: 'voted on your content', // 'VOTE',
  6: 'USER_JSON',
  7: 'subscribed to your channel', // 'FOLLOW',
  8: 'unsubscribed from your channel', // 'UNFOLLOW',
  // RESHARE: 9, // not sure
  10: 'NEW_KEY',
  11: 'REMOVE_KEY',
  12: 'CHANGE_PASSWORD',
  13: 'commented on your content', // 'PROMOTED_COMMENT',
  14: 'TRANSFER_VT',
  15: 'TRANSFER_BW',
  16: 'LIMIT_VT',
  17: 'CLAIM_REWARD',
  18: 'ENABLE_NODE',
  19: 'voted on your content ##TIPAMOUNT% tip' //'TIPPED_VOTE'
};

var txTypeFriendlyDescriptionActions = {
  0: 'account created',
  1: 'voted for chain leader', //'APPROVE_NODE_OWNER',
  2: 'unvoted as chain leader', //'DISAPROVE_NODE_OWNER',
  3: 'successfully sent ##DTCAMOUNT DTC', //'TRANSFER',
  4: 'commented', // 'COMMENT',
  5: 'successfully voted', // 'VOTE',
  6: 'USER_JSON',
  7: 'followed ##USERNAME', // 'FOLLOW',
  8: 'unfollowed ##USERNAME', // 'UNFOLLOW',
  // RESHARE: 9, // not sure
  10: 'NEW_KEY',
  11: 'REMOVE_KEY',
  12: 'CHANGE_PASSWORD',
  13: 'comment sent', // 'PROMOTED_COMMENT',
  14: 'TRANSFER_VT',
  15: 'TRANSFER_BW',
  16: 'LIMIT_VT',
  17: '##DTCAMMOUNT DTC claimed',
  18: 'ENABLE_NODE',
  19: 'successfully voted with ##TIPAMOUNT% tip' //'TIPPED_VOTE'
};
