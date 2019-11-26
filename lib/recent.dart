import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:memorare/types/quotesResp.dart';

class RecentWidget extends StatefulWidget {
  RecentWidgetState createState() => RecentWidgetState();
}

class RecentWidgetState extends State<RecentWidget> {
  String lang;
  int order;

  final String fetchRecent = """
    query (\$lang: String, \$order: Float) {
      quotes (lang: \$lang, order: \$order) {
        pagination {
          hasNext
          limit
          nextSkip
          skip
        }
        entries {
          author {
            id
            name
          }
          id
          name
        }
      }
    }
  """;

  @override
  void initState() {
    super.initState();
    setState(() {
      lang = 'en';
      order = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: fetchRecent,
        variables: {'lang': lang, 'order': order},
      ),
      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
        if (result.errors != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(result.errors.toString()),
            ],
          );
        }

        if (result.loading) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Loading...'),
            ],
          );
        }

        var response = QuotesResp.fromJSON(result.data['quotes']);
        var quotes = response.entries;

        return Scaffold(
          backgroundColor: Color(0xFF706FD3),
          body: ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color(0xFF706FD3),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          quotes[index].name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 15.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: CircleAvatar(
                                backgroundColor: Color(0xFFF56098),
                                backgroundImage: quotes[index].author.imgUrl.length > 1 ?
                                  NetworkImage(quotes[index].author.imgUrl) :
                                  AssetImage('assets/images/monk.png'),
                                child: Text('${quotes[index].author.name.substring(0,1)}'),
                              ),
                            ),
                            Text(
                              '${quotes[index].author.name}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              );
            },
          ),
        );
      },
    );
  }
}
