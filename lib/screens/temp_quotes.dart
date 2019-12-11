import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:memorare/components/error.dart';
import 'package:memorare/components/filter_fab.dart';
import 'package:memorare/components/loading.dart';
import 'package:memorare/components/small_temp_quote_card.dart';
import 'package:memorare/models/http_clients.dart';
import 'package:memorare/types/boolean_message.dart';
import 'package:memorare/types/colors.dart';
import 'package:memorare/types/temp_quote.dart';
import 'package:memorare/types/temp_quotes_response.dart';
import 'package:provider/provider.dart';

class MyTempQuotes extends StatefulWidget {
  @override
  MyTempQuotesState createState() => MyTempQuotesState();
}

class MyTempQuotesState extends State<MyTempQuotes> {
  String lang = 'en';
  int limit = 10;
  int order = -1;
  int skip = 0;
  List<TempQuote> quotes = [];

  int attempts = 1;
  int maxAttempts = 2;

  final String fetchPublishedQuotes = """
    query (\$lang: String, \$limit: Float, \$order: Float, \$skip: Float) {
      tempQuotes (lang: \$lang, limit: \$limit, order: \$order, skip: \$skip) {
        pagination {
          hasNext
          limit
          nextSkip
          skip
        }
        entries {
          id
          name
        }
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: fetchPublishedQuotes,
        variables: {'lang': lang, 'limit': limit, 'order': order, 'skip': skip},
      ),
      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
        if (result.hasErrors) {
          if (attempts < maxAttempts &&
            ErrorComponent.isJWTRelated(result.errors.first.toString())) {

            attempts++;

            ErrorComponent.trySignin(context)
              .then((errorReason) {
                if (errorReason.hasErrors) { return; }
                refetch();
              });

            return Scaffold(
              body: LoadingComponent(),
            );
          }

          return ErrorComponent(
            description: result.errors.first.toString(),
            title: 'Proposed Quotes',
          );
        }

        if (result.loading) {
          return Scaffold(
            body: LoadingComponent(),
          );
        }

        var response = TempQuotesResponse.fromJSON(result.data['tempQuotes']);
        quotes = response.entries;

        return Scaffold(
          appBar: AppBar(
            title: Text('Proposed Quotes'),
          ),
          floatingActionButton: FilterFab(
            onOrderChanged: (int newOrder) {
              setState(() {
                order = newOrder;
              });
            },
            order: order,
          ),
          body: GridView.builder(
            itemCount: quotes.length,
            padding: EdgeInsets.symmetric(vertical: 20.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return SmallTempQuoteCard(
                quote: quotes.elementAt(index),
                onLongPress: (String id) async {
                  final booleanMessage = await validateTempQuote(id);

                  if (booleanMessage.boolean) {
                    refetch();
                  }

                  Scaffold.of(context)
                    .showSnackBar(
                      SnackBar(
                        backgroundColor: booleanMessage.boolean ?
                          ThemeColor.success :
                          ThemeColor.error,

                        content: Text(
                          booleanMessage.boolean ?
                          'The quote has been successfully validated' :
                          booleanMessage.message,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<BooleanMessage> validateTempQuote(String id) {
    final String mutationValidateTempQuote = """
      mutation (\$id: String!, \$ignoreStatus: Boolean) {
        validateTempQuoteAdmin (id: \$id, ignoreStatus: \$ignoreStatus) {
          id
        }
      }
    """;

    final httpClientModel = Provider.of<HttpClientsModel>(context);

    return httpClientModel.defaultClient.value.mutate(MutationOptions(
      document: mutationValidateTempQuote,
      variables: {'id': id, 'ignoreStatus':  true},
    ))
    .then((queryResult) {
      if (queryResult.hasErrors) {
        return BooleanMessage(
          boolean: false,
          message: queryResult.errors.first.message
        );
      }

      return BooleanMessage(boolean: true);
    })
    .catchError((error) {
      return BooleanMessage(boolean: false, message: error.toString());
    });
  }
}