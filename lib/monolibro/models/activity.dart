import 'dart:async';

import 'package:monolibro/globals/ws_control.dart';
import 'package:monolibro/monolibro/models/activity_action.dart';
import 'package:monolibro/monolibro/models/activity_entry.dart';
import 'package:monolibro/monolibro/models/user.dart';

class Activity{
  String code;
  String timestamp;
  String name;
  User hostUser;
  double totalPrice;
  late StreamController<ActivityAction> subscribedStream;

  bool committed;
  List<ActivityEntry> entries = <ActivityEntry>[];

  Activity(this.code, this.timestamp, this.hostUser, this.totalPrice, this.name, {this.committed = false}){
    subscribedStream = StreamController<ActivityAction>();

    subscribedStream.stream.listen((ActivityAction action) {
      switch (action.action){
        case Action.memberJoin:
          if (committed) return;
          entries.add(
            ActivityEntry(
              action.user!,
              action.price!
            )
          );
          break;
        case Action.memberLeave:
          if (committed) return;
          for (int i = 0; i < entries.length; i ++){
            ActivityEntry e = entries[i];
            if (e.user.userID == action.user!.userID){
              entries.removeAt(i);
            }
          }
          break;
        case Action.update:
          if (committed) return;
          for (int i = 0; i < entries.length; i ++){
            ActivityEntry e = entries[i];
            if (e.user.userID == action.user!.userID){
              entries[i].price = 1;
            }
          }
          break;
        case Action.commit:
          if (committed) return;
          committed = true;
          break;
        case Action.exit:
          if (committed) return;
          wsClientGlobal.wsClient.state.activities.remove(code);
          break;
      }
    });
  }

  double getEntrySum(){
    double sum = 0;
    for (ActivityEntry entry in entries){
      sum += entry.price;
    }
    return sum;
  }

  double getSelfSum(){
    double entrySum = getEntrySum();
    return totalPrice - entrySum;
  }
}