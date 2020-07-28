import 'dart:async';

import 'package:Reso/features/reso/domain/entities/venue.dart';
import 'package:Reso/features/reso/presentation/bloc/root_bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksService {
  Future<Map<String, String>> getLaunchData() async {
    try {
      final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;
      if (deepLink != null) {
        return deepLink.queryParameters;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  void handleRelaunchData(Map<String, dynamic> data, RootBloc bloc, bool authenticated) {
    if (!authenticated) {
      bloc.add(ChangeLaunchDataEvent(data));
      return;
    }
    if (data.containsKey("venue")) {
      bloc.add(PushVenue(Venue.getLoadingPlaceholder(data["venue"]), authenticated: authenticated));
      return;
    }
    if (data.containsKey("user")) {
      bloc.add(FullPopEvent());
      bloc.homeBloc.add(DeepLinkedSearchEvent(data["user"]));
    }
  }
}
