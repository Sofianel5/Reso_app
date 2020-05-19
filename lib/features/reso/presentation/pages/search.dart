import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../routes/routes.dart';
import '../bloc/root_bloc.dart';
import '../widgets/venue_card.dart';
import 'venue.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  //! Localize
  final categories = [
    "Resturaunt",
    "Grocery",
    "Coffee",
    "Gym",
    "Gas",
    "Mail",
    "Laundry",
    "Repair",
    "Beauty",
    "Education",
  ];

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

  Widget generateCategoryBtns(int index) {
    final c = categories[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text(c),
        onPressed: () {
          BlocProvider.of<SearchPageBloc>(context).add(SearchSubmitted(c));
        },
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
              .showSnackBar(SnackBar(content: Text(state.message)));
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

  Column buildBody(state, BuildContext context) {
    final bloc = BlocProvider.of<SearchPageBloc>(context);
    final focused = !(state is SearchTyping);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        state is SearchTypingState
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  //! Localize
                  "Search",
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
                        //! Localize
                        "Cancel",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () => bloc.add(SearchCancelled()),
                    )
            ],
          ),
        ),
        buildBodySwitchState(state),
      ],
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
      } else {
        return buildResults(state);
      }
    } else {
      return buildInitialBody();
    }
  }

  Container buildResults(SearchFinishedState state) {
    return Container(
      height: 600,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: state.venues.length,
        itemBuilder: (BuildContext context, int index) => VenueCard(
          venue: state.venues[index],
          from: "search",
        ),
      ),
    );
  }

  Padding buildNoResultsBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
          child: Text(
        //! Localize
        "None nearby",
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
            //! Localize
            "Categories",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            height: 600,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) => generateCategoryBtns(index),
            ),
          )
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
        //! Localize
        hintText: "Search Tracery",
      ),
    );
  }
}
