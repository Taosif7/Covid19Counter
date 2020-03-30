import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'flagUrl.dart';

class CountrySearchView extends SearchDelegate<String> {
  final List<String> names;

  CountrySearchView(this.names);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        // close the search view with null result
        close(context, null);
      },
    );
  }

  // We consider the suggestion & search results to be same
  // as the data is local

  @override
  Widget buildResults(BuildContext context) {
    // get search results
    return searchResultBuilder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // get suggestions
    return searchResultBuilder();
  }

  Widget searchResultBuilder() {
    // List to store the index of element from original list
    List<int> indexes = [];

    // If query is empty, result is empty list
    // else compare lowercased search query to lowercased data elements
    // and if match, then add their index to the indexes list
    // and assign list of matches to this list
    final search = query.isEmpty
        ? []
        : names.where((n) {
            bool s = n.toLowerCase().contains(query.toLowerCase());
            if (s) indexes.add(names.indexOf(n));
            return s;
          }).toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: search.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(search.elementAt(index)),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(getFlagImageUrl(search.elementAt(index))),
          ),
          onTap: () {
            // close the view on tap of item
            // and return the original index of item from the list as result
            close(context, indexes.elementAt(index).toString());
          },
        );
      },
    );
  }
}
