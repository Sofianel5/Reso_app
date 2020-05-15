import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:tracery_app/models/venue_model.dart';
import 'package:tracery_app/widgets/venue_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  bool focused = false;
  var loading = false;
  TextEditingController q = TextEditingController();
  FocusNode searchFocus;
  List<Venue> venues;
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

  void search(String q) async {
    searchFocus.unfocus();
    setState(() {
      focused = false;
    });
    if (q == null || q.trim() == "") {
      return;
    }
    setState(() {
      loading = true;
    });
    var _venues = await userRepo.searchVenues(q);
    setState(() {
      loading = false;
      venues = _venues;
    });
  }

  Widget generateCategoryBtns(int index) {
    final c = categories[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text(c),
        onPressed: () {
          search(c);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userRepo == null) {
      userRepo = Provider.of<UserRepository>(context);
    }
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          focused
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
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
                  child: TextField(
                    onTap: () => setState(() {
                      focused = true;
                    }),
                    onEditingComplete: () => setState(() {
                      focused = false;
                    }),
                    onSubmitted: (q) => search(q),
                    maxLines: 1,
                    controller: q,
                    focusNode: searchFocus,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search Tracery"),
                  ),
                ),
                !focused
                    ? Container()
                    : FlatButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () {
                          searchFocus.unfocus();
                          setState(
                            () {
                              focused = false;
                            },
                          );
                        },
                      )
              ],
            ),
          ),
          venues == null
              ? focused
                  ? Container()
                  : loading
                      ? Center(
                          child: Container(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator()))
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
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
                                    itemBuilder: (context, index) =>
                                        generateCategoryBtns(index)),
                              )
                            ],
                          ),
                        )
              : venues.length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                          child: Text(
                        "None nearby",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      )),
                    )
                  : Container(
                      height: 600,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        itemCount: venues.length,
                        itemBuilder: (BuildContext context, int index) =>
                            VenueCard(
                          venue: venues[index],
                          userRepo: userRepo,
                        ),
                      ),
                    )
        ],
      ),
    );
  }
}
