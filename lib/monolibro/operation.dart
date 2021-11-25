enum Operation {
  // DO NOT change the order of the intentions
  systemDebug,
  clientDebug,
  joinNetwork,
  leaveNetwork,
  createAccountInit,
  voteSessionInit,
  voteSessionQuery,
  reply,
  freezeAccount,
  uptadeAccount,
  joinActivity,
  updateActivity,
  signActivity,
  leaveActivity,
  commitActivity,
  clearPaymentInit,
  clearPaymentConfirm,
  joinActivityData,
  syncUsers,
  syncUsersData,
  syncActivities,
  syncActivitiesData,
}

extension IntentionExtension on Operation {
  int get value {
    return Operation.values.indexOf(this) - 2;
  }
}
