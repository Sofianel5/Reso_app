import 'package:Reso/core/localizations/localizations.dart';
import 'package:Reso/features/reso/domain/entities/venue.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_bloc.dart';
import '../widgets/venue_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {

  @override 
  void didChangeDependencies() {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;
        if (deepLink != null) {
          if (deepLink.queryParameters.containsKey('user')) {
            BlocProvider.of<RootBloc>(context).add(PushListings(int.parse(deepLink.queryParameters["user"])));
          } else if (deepLink.queryParameters.containsKey('venue')) {
            BlocProvider.of<RootBloc>(context).add(PushVenue(Venue.getLoadingPlaceholder(int.parse(deepLink.queryParameters["venue"]))));
          }
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      }
    );
    super.didChangeDependencies();
  }
  
  //! Localize
  final categories = Venue.types;
  
  TextEditingController q = TextEditingController();
  FocusNode searchFocus;

  @override
  void dispose() {
    searchFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchFocus = FocusNode();
  }

  Widget generateCategoryBtns(String category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: RaisedButton(
              child: Text(Localizer.of(context).get(category)),
              onPressed: () {
                BlocProvider.of<SearchPageBloc>(context)
                    .add(SearchSubmitted(category));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<SearchPageBloc>(context),
      listener: (context, state) {
        if (!(state is SearchTypingState)) {
          if (searchFocus.hasFocus) {
            searchFocus.unfocus();
          }
        }
        if (state is SearchFailedState) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(Localizer.of(context).get(state.message))));
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<SearchPageBloc>(context),
        builder: (context, state) => SafeArea(
          bottom: false,
          child: buildBody(state, context),
        ),
      ),
    );
  }

  Widget buildBody(state, BuildContext context) {
    final bloc = BlocProvider.of<SearchPageBloc>(context);
    final focused = !(state is SearchTyping);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          state is SearchTypingState
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    Localizer.of(context).get(
                      "Search",
                    ),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: buildSearchField(bloc),
                ),
                !focused
                    ? Container()
                    : FlatButton(
                        child: Text(
                          Localizer.of(context).get(
                            "Cancel",
                          ),
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          bloc.add(SearchCancelled());
                        },
                      )
              ],
            ),
          ),
          if (state is SearchFinishedState && !(state is NoResultsState))
            for (var venue in state.venues)
              VenueCard(
                venue: venue,
                from: "search",
              )
          else
            buildBodySwitchState(state),
        ],
      ),
    );
  }

  Widget buildBodySwitchState(SearchState state) {
    if (state is SearchLoadingState) {
      return buildLoadingBody();
    } else if (state is InitialSearchState) {
      return buildInitialBody();
    } else if (state is SearchFinishedState) {
      if (state is NoResultsState) {
        return buildNoResultsBody();
      }
    } else {
      return buildInitialBody();
    }
  }

  Padding buildNoResultsBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
          child: Text(
        Localizer.of(context).get(
          "None nearby",
        ),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      )),
    );
  }

  Padding buildInitialBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            Localizer.of(context).get(
              "Categories",
            ),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          for (var category in categories) generateCategoryBtns(category)
        ],
      ),
    );
  }

  Center buildLoadingBody() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }

  TextField buildSearchField(SearchPageBloc bloc) {
    return TextField(
      onTap: () => bloc.add(SearchTyping()),
      onEditingComplete: () => bloc.add(SearchCancelled()),
      onSubmitted: (q) => bloc.add(SearchSubmitted(q)),
      maxLines: 1,
      controller: q,
      focusNode: searchFocus,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: Localizer.of(context).get("Search"),
      ),
    );
  }
}
