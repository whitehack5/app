import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:memorare/components/web/fade_in_y.dart';
import 'package:memorare/components/web/nav_back_header.dart';
import 'package:memorare/components/web/topic_card_color.dart';
import 'package:memorare/data/add_quote_inputs.dart';
import 'package:memorare/screens/web/add_quote_layout.dart';
import 'package:memorare/screens/web/add_quote_nav_buttons.dart';
import 'package:memorare/state/topics_colors.dart';
import 'package:memorare/types/topic_color.dart';
import 'package:memorare/utils/on_long_press_nav_back.dart';
import 'package:memorare/router/route_names.dart';
import 'package:memorare/router/router.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class AddQuoteTopics extends StatefulWidget {
  @override
  _AddQuoteTopicsState createState() => _AddQuoteTopicsState();
}

class _AddQuoteTopicsState extends State<AddQuoteTopics> {
  final beginY    = 100.0;
  final delay     = 1.0;
  final delayStep = 1.2;

  List<TopicColor> allTopics = [];
  List<TopicColor> selectedTopics = [];

  FocusNode keyboardFocusNode;

  @override
  void initState() {
    super.initState();
    keyboardFocusNode = FocusNode();

    populateSelectedTopics();
  }

  @override
  void dispose() {
    if (keyboardFocusNode != null) {
      keyboardFocusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AddQuoteLayout(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              NavBackHeader(
                onLongPress: () => onLongPressNavBack(context),
              ),
              body(),
            ],
          ),

          Positioned(
            right: 120.0,
            top: 85.0,
            child: IconButton(
              onPressed: () {
                FluroRouter.router.navigateTo(
                  context,
                  AddQuoteAuthorRoute,
                );
              },
              icon: Icon(
                Icons.arrow_forward,
              ),
            ),
          ),

          Positioned(
            right: 50.0,
            top: 80.0,
            child: helpButton(),
          )
        ],
      ),
    );
  }

  Widget body() {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: keyboardFocusNode,
      onKey: keyHandler,
      child: Column(
        children: <Widget>[
          FadeInY(
            beginY: beginY,
            child: title(),
          ),

          selectedTopics.length == 0 ?
            emptyTopics() :
            selectedTopicsSection(),

          allTopicsSection(),

          AddQuoteNavButtons(
            onPrevPressed: () => FluroRouter.router.pop(context),
            onNextPressed: () => FluroRouter.router.navigateTo(context, AddQuoteAuthorRoute),
          ),
        ],
      ),
    );
  }

  Widget emptyTopics() {
    return FadeInY(
      delay: delay + (1 * delayStep),
      beginY: beginY,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
        child: Opacity(
          opacity: .6,
          child: Text(
            'You have not added any topic yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget helpButton() {
    return IconButton(
      icon: Opacity(
        opacity: .6,
        child: Icon(Icons.help)
      ),
      iconSize: 40.0,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 500.0,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        'Help',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 500.0,
                    child: Opacity(
                      opacity: .6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              '• Topics are used to categorize the quote',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              '• You can select one or more topics',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget allTopicsSection() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          ControlledAnimation(
            duration: 1.seconds,
            delay: 1.seconds,
            tween: Tween(begin: 0.0, end: 500.0),
            builder: (_, value) {
              return SizedBox(
                width: value,
                child: Divider(height: 120.0,),
              );
            },
          ),

          FadeInY(
            beginY: beginY,
            delay: delay + (2 * delayStep),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Topics',
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ),
          ),

          FadeInY(
            beginY: beginY,
            delay: delay + (3 * delayStep),
            child: SizedBox(
              width: 500.0,
              child: Opacity(
                opacity: .6,
                child: Text(
                  'Select some of the available topics to categorize the quote.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),

          Observer(builder: (context) {
            if (allTopics.length == 0) {
              allTopics.addAll(appTopicsColors.topicsColors);

            }

            int index = 0;

            return Container(
              width: 600.0,
              padding: const EdgeInsets.symmetric(vertical: 60.0),
              child: Wrap(
                children: allTopics.map<Widget>((topicColor) {
                  index++;
                  final name = topicColor.name;
                  final displayName = name.length < 5 ? name : '${name.substring(0, 4)}...';
                  final fontSize = name.length > 5 ? 15.0 : 17.0;

                  return FadeInY(
                    beginY: 100.0,
                    endY: 0.0,
                    delay: index * 1.0,
                    child: TopicCardColor(
                      onColorTap: () {
                        setState(() {
                          selectedTopics.add(topicColor);
                          allTopics.remove(topicColor);
                        });

                        AddQuoteInputs.quote.topics.add(topicColor.name);
                      },
                      size: 70.0,
                      elevation: 6.0,
                      outline: true,
                      color: Color(topicColor.decimal),
                      name: name,
                      displayName: displayName,
                      style: TextStyle(
                        fontSize: fontSize,
                      ),
                      tooltip: name,
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget selectedTopicsSection() {
    double index = 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70.0),
      child: Column(
        children: <Widget>[
          Wrap(
            spacing: 20.0,
            children: selectedTopics.map<Widget>((topicColor) {
              index++;
              final name = topicColor.name;

                return FadeInY(
                  beginY: 100.0,
                  endY: 0.0,
                  delay: index * 1.0,
                  child: TopicCardColor(
                    onColorTap: () {
                      setState(() {
                        allTopics.add(topicColor);
                        selectedTopics.remove(topicColor);
                      });

                      AddQuoteInputs.quote.topics
                        .removeWhere((element) => element == topicColor.name);
                    },
                    size: 100.0,
                    elevation: 6.0,
                    color: Color(topicColor.decimal),
                    name: name,
                    displayName: name,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                );
            }).toList(),
          ),

          FadeInY(
            beginY: 50.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: FlatButton(
                padding: EdgeInsets.all(10.0),
                onPressed: () {
                  setState(() {
                    AddQuoteInputs.clearTopics();
                    selectedTopics.clear();

                    allTopics.clear();
                    allTopics.addAll(appTopicsColors.topicsColors);
                  });
                },
                child: Opacity(
                  opacity: .6,
                  child: Text(
                    'Clear all topics',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Column(
      children: <Widget>[
        Text(
          'Add topics',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: Text(
            '2/5',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  void keyHandler (RawKeyEvent keyEvent) {
    if (keyEvent.runtimeType.toString() == 'RawKeyDownEvent') {
      return;
    }

    if (keyEvent.logicalKey.keyId == LogicalKeyboardKey.enter.keyId) {
      FluroRouter.router.navigateTo(context, AddQuoteAuthorRoute);
      return;
    }
  }

  void populateSelectedTopics() {
    AddQuoteInputs.quote.topics.forEach((topicName) {
      selectedTopics.add(
        appTopicsColors.find(topicName)
      );
    });

    setState(() {});
  }
}
