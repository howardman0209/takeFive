import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class homeUI extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: homeUIPage(),
        );
      },
      title: 'CheetahKing',
    );
  }
}

// ignore: camel_case_types
class homeUIPage extends StatefulWidget {
  @override
  _homeUIState createState() => _homeUIState();
}

// ignore: camel_case_types
class _homeUIState extends State<homeUIPage> {
  get padding => null;

  int numberOfPlayer = 2;
  int thisTurnPlayer = 1;
  int round = 1;
  bool gameStart = false;
  bool counting = false;
  bool roundEnded = false;
  bool placeCard = false;
  bool haveEatBullHeadChoice = false;
  bool gameEnded = false;
  bool playerReady = false;
  bool scrollViewEnable = false;
  bool secretSwitch = false;
  bool showThisRoundCard = false;
  List<int> thisRoundCard = [];
  Map eachRoundSelectedCards = {};
  Map bullHeadAteThisRound = {};
  Map playersResults = {};
  late int focusedCard;
  late List<int> iniCard;
  late List<List<int>> playersCard;
  late List<bool> selectedCard;
  late List<List<int>> gamePool;
  late List<int> playersBullheads;

  //single player mode
  bool singlePlayerMode = false;

  //functions
  initializeCard() {
    List<int> card = [];
    for (int i = 1; i <= 104; i++) {
      card.add(i);
    }
    return card;
  }

  Future<void> dispatch(int numOfPlayer) async {
    int numOfEachPlayerCard = 10;
    playersCard = List.generate(numOfPlayer, (index) => new List.filled(numOfEachPlayerCard, 0));
    KEYS = List.generate(numOfEachPlayerCard, (index) => new GlobalKey());
    playersBullheads = List.filled(numOfPlayer, 0);
    selectedCard = List.filled(numOfEachPlayerCard, false);
    for (int i = 0; i < numOfPlayer; i++) {
      for (int n = 0; n < numOfEachPlayerCard; n++) {
        playersCard[i][n] = iniCard[n + (i) * numOfEachPlayerCard];
      }
      playersCard[i].sort();
      print(playersCard[i]);
      // print(selectedCard);
    }
  }

  gamePoolIni() {
    gamePool = [
      [iniCard[100]],
      [iniCard[101]],
      [iniCard[102]],
      [iniCard[103]],
    ];
    print(gamePool);
  }

  quickEndGame() {
    setState(() {
      gameEnded = true;
    });
  }

//return bool true = autoPlace is OK ; false = autoPlace is not OK (Need Player Choose)
  placeCardFn(int selectedCard) {
    List diffFromlastItems = [];
    late int theRightPlace;
    for (int i = 0; i < 4; i++) {
      // print(gamePool[i].last);
      int diff = selectedCard - gamePool[i].last;
      if (!diff.isNegative) {
        // print(diff);
        diffFromlastItems.add(diff);
      }
    }
    diffFromlastItems.sort(); // make the smallest diff to be diffFromlastItems[0]
    if (diffFromlastItems.isNotEmpty) {
      for (int i = 0; i < 4; i++) {
        if (selectedCard - gamePool[i].last == diffFromlastItems[0]) {
          theRightPlace = i;
          gamePool[theRightPlace].add(selectedCard);
          if (gamePool[theRightPlace].length == 5) {
            print('Row ' + theRightPlace.toString() + ' is fully filled.');
            int tempLastItem = gamePool[theRightPlace].last;
            gamePool[theRightPlace].remove(gamePool[theRightPlace].last);
            playersBullheads[findPlayerWithSelectedCard(selectedCard)] += int.parse(countAteBullHead(i).toString());
            bullHeadAteThisRound.putIfAbsent(findPlayerWithSelectedCard(selectedCard) + 1, () => int.parse(countAteBullHead(i).toString()));
            gamePool[theRightPlace].clear();
            gamePool[theRightPlace].add(tempLastItem);
          } else {
            print('All rows are not fully filled');
          }
        }
      }
      return true;
    } else {
      return false;
    }
  }

  //
  countBullHead(int card) {
    if (card == 55) {
      return 7;
    } else if (card % 11 == 0) {
      return 5;
    } else if (card % 10 == 0) {
      return 3;
    } else if (card % 5 == 0) {
      return 2;
    } else {
      return 1;
    }
  }

  countAteBullHead(int rowNum) {
    int bullHeadHaveToEat = 0;
    for (int i = 0; i < gamePool[rowNum].length; i++) {
      bullHeadHaveToEat += int.parse(countBullHead(gamePool[rowNum][i]).toString());
    }
    return bullHeadHaveToEat;
  }

  findPlayerWithSelectedCard(int selectCard) {
    int playerNum = -1;
    for (int i = 1; i <= thisRoundCard.length; i++) {
      if (selectCard == eachRoundSelectedCards[i]) {
        playerNum = i - 1;
      }
    }
    return playerNum;
  }

  findPlayerWithResult(int result) {
    int playerNum = -1;
    bool stop = false;
    for (int i = 0; i <= numberOfPlayer && !stop; i++) {
      if (result == playersResults[i]) {
        playerNum = i;
        stop = true;
      }
    }
    return playerNum;
  }

// Computer Brain
  Future<void> randomChooseACard(List<int> handCard) async {
    //random choose a card
    var rng = new Random();
    int randomOption = rng.nextInt(handCard.length);
    print(randomOption);
    selectedCard[randomOption] = true;
    for (int i = 0; i < selectedCard.length; i++) {
      if (i != randomOption) {
        setState(() {
          selectedCard[i] = false;
        });
      }
    }
    print(handCard[randomOption]);
    print('choose randomly');
  }

  Future<void> chooseTheLargestCard(List<int> handCard) async {
    int choosenCard = handCard.length - 1;
    selectedCard[choosenCard] = true;
    for (int i = 0; i < selectedCard.length; i++) {
      if (i != choosenCard) {
        setState(() {
          selectedCard[i] = false;
        });
      }
    }
    print(handCard[choosenCard]);
    print('choose the largest card');
  }

  Future<void> chooseTheSmallestCard(List<int> handCard) async {
    int choosenCard = 0;
    selectedCard[choosenCard] = true;
    for (int i = 0; i < selectedCard.length; i++) {
      if (i != choosenCard) {
        setState(() {
          selectedCard[i] = false;
        });
      }
    }
    print(handCard[choosenCard]);
    print('choose the Smallest card');
  }

  Future<void> chooseTheSmallestNotEatRowCard(List<int> notEatRowCard) async {
    int choosenCard = notEatRowCard[0];
    selectedCard[choosenCard] = true;
    for (int i = 0; i < selectedCard.length; i++) {
      if (i != choosenCard) {
        setState(() {
          selectedCard[i] = false;
        });
      }
    }
    print(playersCard[thisTurnPlayer - 1][choosenCard]);
    print('choose The Smallest Not Eat Row Card');
  }

  Future<void> randomChooseFromNotEatCards(List<int> notEatCards) async {
    var rng = new Random();
    int randomOption = rng.nextInt(notEatCards.length);
    selectedCard[notEatCards[randomOption]] = true;
    for (int i = 0; i < selectedCard.length; i++) {
      if (i != notEatCards[randomOption]) {
        setState(() {
          selectedCard[i] = false;
        });
      }
    }
    print(notEatCards[randomOption]);
    print('choose randomly from not eat card');
  }

  Future<void> chooseTheBestCard(List<int> handCard, int bestOptionRow) async {
    int choosenCard = -1;
    for (int i = 0; i < handCard.length; i++) {
      if (handCard[i] - gamePool[bestOptionRow].last > 0 && handCard[i] - gamePool[bestOptionRow].last < 5 - gamePool[bestOptionRow].length) {
        choosenCard = i;
        selectedCard[choosenCard] = true;
      }
    }
    for (int i = 0; i < selectedCard.length; i++) {
      if (i != choosenCard) {
        setState(() {
          selectedCard[i] = false;
        });
      }
    }
    print(handCard[choosenCard]);
    print('choose the best card');
  }

  Future<void> computerBrainChooseCard(List<int> handCard, int computerNum) async {
    print(gamePool);
    //get gamePool Info
    List<int> rowsLength = [];
    List<int> rowsLastItem = [];
    List<int> rowsBullheadContain = [];
    //
    List<int> handcardDiffFromLastItem = [];
    List<int> smallestDiffFromLastItem = [];
    List<int> smallestDiffCardOption = [];
    //
    List<int> eatRowCards = [];
    List<int> notToEatRowCards = [];
    //
    List<String> rowsStatus = [];
    List<String> rowBullHeadStatus = [];
    //
    bool verySafe = true;
    bool veryDangerous = true;
    bool bestOptionExist = false;
    bool timeToEat = false;
    //
    int bestOptionRow = -1;
    int lessCount = 0;
    //
    for (int i = 0; i < gamePool.length; i++) {
      rowsLength.add(gamePool[i].length);
      rowsLastItem.add(gamePool[i].last);
      rowsBullheadContain.add(int.parse(countAteBullHead(i).toString()));
      for (int n = 0; n < handCard.length; n++) {
        if (handCard[n] - gamePool[i].last > 0) {
          handcardDiffFromLastItem.add(handCard[n] - gamePool[i].last);
        }
      }
      // sorting to find to smallest diff
      handcardDiffFromLastItem.sort();

      // find to smallest diff and save
      //// postive
      if (handcardDiffFromLastItem.isNotEmpty) {
        int smallestDiff = handcardDiffFromLastItem[0];
        smallestDiffFromLastItem.add(smallestDiff);
        handcardDiffFromLastItem.clear();
      } else {
        int smallestDiff = 104;
        smallestDiffFromLastItem.add(smallestDiff);
      }
    }
    //set rowsStatus
    for (int i = 0; i < gamePool.length; i++) {
      if (5 - rowsLength[i] > numberOfPlayer) {
        rowsStatus.add('absSafe');
      } else {
        if (smallestDiffFromLastItem[i] < 5 - rowsLength[i]) {
          rowsStatus.add('bestOption');
        } else if (smallestDiffFromLastItem[i] != 104) {
          rowsStatus.add('dangerous');
        } else if (smallestDiffFromLastItem[i] == 104) {
          rowsStatus.add('safe');
        } else {
          rowsStatus.add('notSafe');
        }
      }
    }
    //set rowBullHeadStatus
    for (int i = 0; i < gamePool.length; i++) {
      if (rowsBullheadContain[i] < 3) {
        rowBullHeadStatus.add('less'); // 1,2
      } else if (rowsBullheadContain[i] > 5) {
        rowBullHeadStatus.add('many'); // 6,7
      } else if (rowsBullheadContain[i] > 7) {
        rowBullHeadStatus.add('massive'); // 8~
      } else {
        rowBullHeadStatus.add('normal'); // 3,4,5
      }
    }
    // check verySafe
    for (int i = 0; i < rowsStatus.length; i++) {
      if (rowsStatus[i] != 'absSafe') {
        verySafe = false;
      }
    }
    // check veryDangerous
    for (int i = 0; i < smallestDiffFromLastItem.length; i++) {
      if (smallestDiffFromLastItem[i] != 104) {
        veryDangerous = false;
      }
    }
    //set smallestDiffCardOption
    for (int i = 0; i < gamePool.length; i++) {
      bool chooseLC = false;
      for (int n = 0; n < handCard.length; n++) {
        if (smallestDiffFromLastItem[i] != 104) {
          if (handCard[n] - gamePool[i].last == smallestDiffFromLastItem[i]) {
            smallestDiffCardOption.add(n);
          }
        } else {
          chooseLC = true;
        }
      }
      if (chooseLC) {
        smallestDiffCardOption.add(handCard.length - 1);
        chooseLC = false;
      }
    }
    //set Eat Row Cards Option
    for (int i = 0; i < handCard.length; i++) {
      bool allNegative = true;
      for (int n = 0; n < gamePool.length; n++) {
        if (handCard[i] - gamePool[n].last > 0) {
          allNegative = false;
        }
      }
      if (allNegative) {
        eatRowCards.add(i);
      }
    }
    //set Not To Eat Row Cards
    for (int i = 0; i < handCard.length; i++) {
      notToEatRowCards.add(i);
    }
    for (int i = 0; i < eatRowCards.length; i++) {
      notToEatRowCards.remove(eatRowCards[i]);
    }

    //check bestOption existence
    for (int i = 0; i < rowsStatus.length; i++) {
      if (rowsStatus[i] == 'bestOption') {
        bestOptionExist = true;
        bestOptionRow = i;
      }
    }
    //check timeToEat bool
    for (int i = 0; i < rowBullHeadStatus.length; i++) {
      if (rowBullHeadStatus[i] == 'less') {
        lessCount++;
      }
    }
    print('lessCount: ' + lessCount.toString());
    if (lessCount == 1) {
      timeToEat = true;
    }
    //print value
    print('rows length: ' + rowsLength.toString());
    print('rows Last Item: ' + rowsLastItem.toString());
    print('rows Bull head Contain: ' + rowsBullheadContain.toString());
    print('smallest Diff From Last Item: ' + smallestDiffFromLastItem.toString());
    print('rows Status: ' + rowsStatus.toString());
    print('It is veryDangerous: ' + veryDangerous.toString());
    print('It is verySafe: ' + verySafe.toString());
    print('smallest Diff Card Option: ' + smallestDiffCardOption.toString());
    print('eat Row Cards : ' + eatRowCards.toString());
    print('not To Eat Row Cards : ' + notToEatRowCards.toString());
    print('best Option Exist : ' + bestOptionExist.toString() + ' is Row ' + bestOptionRow.toString());
    print('row Bull Head Status : ' + rowBullHeadStatus.toString());
    print('It is time to eat Row actively : ' + timeToEat.toString());
    // Choose Card
    if (1 == 1) {
      if (computerNum % 2 == 0) {
        print('computer type A');
        if (!bestOptionExist) {
          if (timeToEat) {
            await chooseTheSmallestCard(handCard);
          } else {
            if (veryDangerous) {
              await chooseTheLargestCard(handCard);
            } else {
              if (verySafe) {
                await chooseTheSmallestNotEatRowCard(notToEatRowCards);
              } else {
                await chooseTheLargestCard(handCard);
              }
            }
          }
        } else {
          await chooseTheBestCard(handCard, bestOptionRow);
        }
      } else if (computerNum % 3 == 0) {
        print('computer type B');
        if (!bestOptionExist) {
          if (timeToEat) {
            await chooseTheSmallestCard(handCard);
          } else {
            if (veryDangerous) {
              await chooseTheLargestCard(handCard);
            } else {
              if (verySafe) {
                await chooseTheSmallestNotEatRowCard(notToEatRowCards);
              } else {
                if (notToEatRowCards.isNotEmpty) {
                  await randomChooseFromNotEatCards(notToEatRowCards);
                } else {
                  await randomChooseACard(handCard);
                }
              }
            }
          }
        } else {
          await chooseTheBestCard(handCard, bestOptionRow);
        }
      } else {
        print('computer type C');
        if (!bestOptionExist) {
          if (timeToEat) {
            await chooseTheSmallestCard(handCard);
          } else {
            if (veryDangerous) {
              await chooseTheLargestCard(handCard);
            } else {
              if (verySafe) {
                await randomChooseFromNotEatCards(notToEatRowCards);
              } else {
                if (notToEatRowCards.isNotEmpty) {
                  await chooseTheSmallestNotEatRowCard(notToEatRowCards);
                } else {
                  await randomChooseACard(handCard);
                }
              }
            }
          }
        } else {
          await chooseTheBestCard(handCard, bestOptionRow);
        }
      }
    } else {
      //testing AI
      if (!bestOptionExist) {
        if (timeToEat) {
          await chooseTheSmallestCard(handCard);
        } else {
          if (veryDangerous) {
            await chooseTheLargestCard(handCard);
          } else {
            if (verySafe) {
              await chooseTheSmallestNotEatRowCard(notToEatRowCards);
            } else {
              await chooseTheLargestCard(handCard);
            }
          }
        }
      } else {
        await chooseTheBestCard(handCard, bestOptionRow);
      }
    }
  }

  //

  Future<int> randomChooseALeastBullHeadRow(List<int> leastBullHeadRows) async {
    var rng = new Random();
    int randomOption = rng.nextInt(leastBullHeadRows.length);
    int choosenRow = leastBullHeadRows[randomOption];

    print(leastBullHeadRows[randomOption]);
    print('randomly Choose A Least Bull Head Row');
    return choosenRow;
  }

  Future<int> computerBrainChooseRow() async {
    //get rows info
    List<int> rowsBullheadContain = [];
    List<int> tempRBHC = [];
    List<int> leastBullHeadRows = [];
    int choosenRow = -1;
    for (int i = 0; i < gamePool.length; i++) {
      rowsBullheadContain.add(int.parse(countAteBullHead(i).toString()));
      tempRBHC.add(int.parse(countAteBullHead(i).toString()));
    }
    tempRBHC.sort();
    for (int i = 0; i < gamePool.length; i++) {
      int bullHeadCount = int.parse(countAteBullHead(i).toString());
      if (bullHeadCount == tempRBHC[0]) {
        leastBullHeadRows.add(i);
      }
    }

    print('rows Bull head Contain: ' + rowsBullheadContain.toString());
    print('least Bull Head Rows: ' + leastBullHeadRows.toString());

    await randomChooseALeastBullHeadRow(leastBullHeadRows).then((value) {
      // print(value);
      choosenRow = value;
    });
    return choosenRow;
  }

//initialized
  @override
  void initState() {
    super.initState();
    numberOfPlayer = 2;
    thisTurnPlayer = 1;
    round = 1;
    focusedCard = 0;
    gameStart = false;
    gameEnded = false;
    counting = false;
    roundEnded = false;
    placeCard = false;
    scrollViewEnable = false;
    showThisRoundCard = false;
    iniCard = initializeCard();
    // thisRoundCard = [];
    // eachRoundSelectedCards = {};
    // playersSelectedCards = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<_CardUIState> _key = GlobalKey();
  // ignore: non_constant_identifier_names
  late List<GlobalKey<_CardUIState>> KEYS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height - 200,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              color: Colors.indigo,
              child: Container(
                  // padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: new Border.all(color: Colors.transparent, width: 0),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (!gameStart)
                          ? Expanded(
                              child: Container(
                                // color: Colors.green,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          // color: Colors.blueGrey,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Number of Players:',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // color: Colors.amberAccent,
                                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                // color: Colors.amber,
                                                child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    shape: CircleBorder(),
                                                    side: BorderSide(
                                                      width: 2,
                                                      // color: Color(0xff54c3c2),
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (numberOfPlayer > 2) {
                                                      setState(() {
                                                        numberOfPlayer--;
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                numberOfPlayer.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Container(
                                                // color: Colors.amber,
                                                child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    backgroundColor: Colors.white,
                                                    shape: CircleBorder(),
                                                    side: BorderSide(
                                                      width: 2,
                                                      // color: Color(0xff54c3c2),
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (numberOfPlayer < 10) {
                                                      setState(() {
                                                        numberOfPlayer++;
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      // color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            // color: Colors.amber,
                                            padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                            child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  side: BorderSide(
                                                    width: 2,
                                                    // color: Color(0xff54c3c2),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  gameStart = !gameStart;
                                                  if (singlePlayerMode) {
                                                    playerReady = true;
                                                  } else {
                                                    playerReady = false;
                                                  }
                                                  await dispatch(numberOfPlayer).then((value) => {
                                                        gamePoolIni(),
                                                        setState(() {}),
                                                      });
                                                  // print('Game Started ' + gameStart.toString());
                                                },
                                                child: Text(
                                                  'Start Game',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                )),
                                          ),
                                          Container(
                                            // color: Colors.amber,
                                            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                            child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: singlePlayerMode ? Colors.white : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                  side: BorderSide(
                                                    width: 2,
                                                    // color: Color(0xff54c3c2),
                                                    color: singlePlayerMode ? Colors.amber : Colors.black,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    singlePlayerMode = !singlePlayerMode;
                                                  });
                                                  print(singlePlayerMode);
                                                },
                                                child: Text(
                                                  'Single Player',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: singlePlayerMode ? Colors.amber : Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.blueAccent,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            // color: Colors.amber,
                                            child: CardUI(
                                              key: _key,
                                              value: iniCard,
                                              indexOfCard: focusedCard,
                                              gameStart: gameStart,
                                              showCardFront: true,
                                              canFlip: true,
                                              // setCardState: setStateFn(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : (!gameEnded)
                              ? Expanded(
                                  child: Container(
                                    // color: Colors.green,
                                    child: Stack(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.start,
                                      children: [
                                        !counting
                                            ? Container(
                                                // color: Colors.lightBlue,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      // color: Colors.amber,
                                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                      child: Text(
                                                        'Player ' + (thisTurnPlayer).toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: secretSwitch ? Colors.blueGrey : Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.pest_control,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            playersBullheads[thisTurnPlayer - 1].toString(),
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    //restart button
                                                    Container(
                                                      // color: Colors.amber,
                                                      child: OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                          backgroundColor: Colors.white,
                                                          shape: CircleBorder(),
                                                          side: BorderSide(
                                                            width: 2,
                                                            // color: Color(0xff54c3c2),
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            numberOfPlayer = 2;
                                                            thisTurnPlayer = 1;
                                                            focusedCard = 0;
                                                            round = 1;
                                                            gameStart = false;
                                                            gameEnded = false;
                                                            counting = false;
                                                            roundEnded = false;
                                                            placeCard = false;
                                                            playerReady = false;
                                                            scrollViewEnable = false;
                                                            singlePlayerMode = false;
                                                            showThisRoundCard = false;
                                                            haveEatBullHeadChoice = false;
                                                            secretSwitch = false;
                                                            bullHeadAteThisRound = {};
                                                            eachRoundSelectedCards = {};
                                                            playersResults = {};
                                                            playersBullheads = [];
                                                            iniCard = initializeCard();
                                                            thisRoundCard.clear();
                                                          });
                                                          print('Game restarted!');
                                                        },
                                                        child: Icon(
                                                          Icons.restart_alt_sharp,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                //Round N + Show Cards/Place Cards/Next Round/Show Result
                                                // color: Colors.blueGrey,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      // color: Colors.amber,
                                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                      child: Text(
                                                        'Round ' + round.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    //restart button
                                                    Container(
                                                      // color: Colors.amber,
                                                      child: OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                          backgroundColor: Colors.white,
                                                          shape: CircleBorder(),
                                                          side: BorderSide(
                                                            width: 2,
                                                            // color: Color(0xff54c3c2),
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            numberOfPlayer = 2;
                                                            thisTurnPlayer = 1;
                                                            focusedCard = 0;
                                                            round = 1;
                                                            gameStart = false;
                                                            gameEnded = false;
                                                            counting = false;
                                                            roundEnded = false;
                                                            placeCard = false;
                                                            playerReady = false;
                                                            scrollViewEnable = false;
                                                            singlePlayerMode = false;
                                                            showThisRoundCard = false;
                                                            haveEatBullHeadChoice = false;
                                                            secretSwitch = false;
                                                            bullHeadAteThisRound = {};
                                                            eachRoundSelectedCards = {};
                                                            playersResults = {};
                                                            playersBullheads = [];
                                                            iniCard = initializeCard();
                                                            thisRoundCard.clear();
                                                          });
                                                          print('Game restarted!');
                                                        },
                                                        child: Icon(
                                                          Icons.restart_alt_sharp,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        Container(
                                          // padding: EdgeInsets.all(20),
                                          child: Container(
                                            // color: Colors.yellow,
                                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                //gamePool
                                                Container(
                                                  // padding: EdgeInsets.fromLTRB(
                                                  //     10, 10, 10, 0),
                                                  // color: Colors.blue,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      for (int n = 0; n < 4; n++)
                                                        Container(
                                                          // color: Colors.purple,
                                                          // 1st Column
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              //gamePool with cards already
                                                              for (int i = 0; i < gamePool[n].length; i++)
                                                                Container(
                                                                  padding: EdgeInsets.all(2),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(color: Colors.amber[100 + 200 * (i)], border: Border.all(width: 1)),
                                                                    child: CardUI(
                                                                      value: gamePool[n],
                                                                      indexOfCard: i,
                                                                      gameStart: gameStart,
                                                                      showCardFront: true,
                                                                      canFlip: false,
                                                                      // setCardState: setStateFn(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              //gamePool without cards
                                                              for (int i = 0; i < 5 - gamePool[n].length; i++)
                                                                (i == 4 - gamePool[n].length) //Last Column (red card Pool)
                                                                    ? InkWell(
                                                                        onTap: () {
                                                                          //Multiplayer
                                                                          if (!singlePlayerMode || thisRoundCard[0] == eachRoundSelectedCards[1]) {
                                                                            if (haveEatBullHeadChoice) {
                                                                              print('Eat row ' + (n + 1).toString());
                                                                              setState(() {
                                                                                playersBullheads[findPlayerWithSelectedCard(thisRoundCard[0])] += int.parse(countAteBullHead(n).toString());
                                                                                bullHeadAteThisRound.putIfAbsent(findPlayerWithSelectedCard(thisRoundCard[0]) + 1, () => int.parse(countAteBullHead(n).toString()));
                                                                                gamePool[n].clear();
                                                                                gamePool[n].add(thisRoundCard[0]);
                                                                                thisRoundCard.remove(thisRoundCard[0]);
                                                                                thisRoundCard.add(0);
                                                                                thisRoundCard.sort();
                                                                                haveEatBullHeadChoice = false;
                                                                              });
                                                                            }
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          padding: EdgeInsets.all(2),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.red,
                                                                                border: Border.all(
                                                                                  color: haveEatBullHeadChoice ? Colors.indigo : Colors.black,
                                                                                  width: haveEatBullHeadChoice ? 2 : 1,
                                                                                )),
                                                                            child: Container(
                                                                              child: Container(
                                                                                width: 60,
                                                                                height: 80,
                                                                                child: Center(
                                                                                  child: haveEatBullHeadChoice
                                                                                      ? Text(
                                                                                          'R' + (n + 1).toString(),
                                                                                          style: TextStyle(
                                                                                            color: Colors.indigo,
                                                                                            fontSize: 20,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        )
                                                                                      : Icon(
                                                                                          Icons.pest_control,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        padding: EdgeInsets.all(2),
                                                                        child: Container(
                                                                          decoration: BoxDecoration(color: Colors.white, border: Border.all()),
                                                                          child: Container(
                                                                            width: 60,
                                                                            height: 80,
                                                                          ),
                                                                        ),
                                                                      )
                                                            ],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              // color: Colors.yellow,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      //switch card display mode button
                                                      Container(
                                                        // color: Colors.amber,
                                                        child: OutlinedButton(
                                                          style: OutlinedButton.styleFrom(
                                                            backgroundColor: Colors.white,
                                                            shape: CircleBorder(),
                                                            side: BorderSide(
                                                              width: 2,
                                                              // color: Color(0xff54c3c2),
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          onLongPress: () {
                                                            // setState(() {
                                                            //   //singlePlayerMode switch
                                                            //   secretSwitch = !secretSwitch;
                                                            //   print('secretSwitch ' + secretSwitch.toString());
                                                            // });
                                                          },
                                                          onPressed: () async {
                                                            // TESTING BUTTON HERE
                                                            // print('player ' + thisTurnPlayer.toString());
                                                            // print('Players Cards: ' + playersCard.toString());
                                                            // print('This Round Cards: ' + thisRoundCard.toString());
                                                            // print('Players Select Cards: ' + eachRoundSelectedCards.toString());
                                                            // print('Players Bull Heads: ' + playersBullheads.toString());
                                                            // print('Game Pool Cards: ' + gamePool.toString());
                                                            // print('Players Bull Heads: ' + playersBullheads.toString());
                                                            print('Current Testing: ');
                                                            if (secretSwitch) {
                                                              await computerBrainChooseCard(playersCard[thisTurnPlayer - 1], thisTurnPlayer);
                                                            } else {
                                                              setState(() {
                                                                scrollViewEnable = !scrollViewEnable;
                                                              });
                                                            }
                                                          },
                                                          child: Icon(
                                                            !scrollViewEnable ? Icons.swipe_outlined : Icons.view_module_rounded,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      //AI hint button
                                                      Container(
                                                        // color: Colors.amber,
                                                        child: OutlinedButton(
                                                          style: OutlinedButton.styleFrom(
                                                            backgroundColor: Colors.white,
                                                            shape: CircleBorder(),
                                                            side: BorderSide(
                                                              width: 2,
                                                              // color: Color(0xff54c3c2),
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          onLongPress: () {},
                                                          onPressed: () async {
                                                            await computerBrainChooseCard(playersCard[thisTurnPlayer - 1], 2);
                                                          },
                                                          child: Icon(
                                                            Icons.emoji_objects_outlined,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //restart button
                                                  !counting
                                                      ? Container(
                                                          // color: Colors.amber,
                                                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                          child: OutlinedButton(
                                                              style: OutlinedButton.styleFrom(
                                                                backgroundColor: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                ),
                                                                side: BorderSide(
                                                                  width: 2,
                                                                  // color: Color(0xff54c3c2),
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              onPressed: () async {
                                                                //Multiplayer

                                                                bool cardChoosen = false;
                                                                // check whether user selected card
                                                                for (int i = 0; i < selectedCard.length; i++) {
                                                                  if (selectedCard[i]) {
                                                                    cardChoosen = true;
                                                                  }
                                                                }
                                                                if (!singlePlayerMode) {
                                                                  if (cardChoosen) {
                                                                    if (!secretSwitch) {
                                                                      playerReady = false;
                                                                    }
                                                                    setState(() {
                                                                      for (int k = 0; k < selectedCard.length; k++) {
                                                                        if (selectedCard[k]) {
                                                                          thisRoundCard.add(playersCard[thisTurnPlayer - 1][k]);
                                                                          eachRoundSelectedCards.putIfAbsent(thisTurnPlayer, () => playersCard[thisTurnPlayer - 1][k]);
                                                                          List<int> remainingCards = playersCard[thisTurnPlayer - 1].toList();
                                                                          remainingCards.remove(playersCard[thisTurnPlayer - 1][k]);
                                                                          playersCard[thisTurnPlayer - 1] = remainingCards;
                                                                        }
                                                                      }
                                                                      if (thisTurnPlayer < numberOfPlayer) {
                                                                        thisTurnPlayer++;
                                                                      } else {
                                                                        counting = true;
                                                                        showThisRoundCard = true;
                                                                        thisTurnPlayer = 1;
                                                                      }
                                                                      for (int k = 0; k < selectedCard.length; k++) {
                                                                        selectedCard[k] = false;
                                                                      }
                                                                    });
                                                                  } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      const SnackBar(
                                                                        content: Text('Please Choose One Card !!'),
                                                                      ),
                                                                    );
                                                                  }
                                                                } else {
                                                                  //singlePlayerMode
                                                                  print('singlePlayerMode is on');
                                                                  if (cardChoosen) {
                                                                    print('pass to computers\' turns');
                                                                    playerReady = true;
                                                                    //add player's selected card to this Round Card
                                                                    for (int k = 0; k < selectedCard.length; k++) {
                                                                      if (selectedCard[k]) {
                                                                        thisRoundCard.add(playersCard[thisTurnPlayer - 1][k]);
                                                                        eachRoundSelectedCards.putIfAbsent(thisTurnPlayer, () => playersCard[thisTurnPlayer - 1][k]);
                                                                        List<int> remainingCards = playersCard[thisTurnPlayer - 1].toList();
                                                                        remainingCards.remove(playersCard[thisTurnPlayer - 1][k]);
                                                                        playersCard[thisTurnPlayer - 1] = remainingCards;
                                                                        thisTurnPlayer++; //pass turn to computer
                                                                        for (int k = 0; k < selectedCard.length; k++) {
                                                                          selectedCard[k] = false; //deselect all cards
                                                                        }
                                                                      }
                                                                    }
                                                                    //  computers turns
                                                                    ////  player : thisTurnPlayer = 1
                                                                    ////  computers : thisTurnPlayer = 2 ~ numberOfPlayer
                                                                    for (int i = 1; i < numberOfPlayer; i++) {
                                                                      //
                                                                      await computerBrainChooseCard(playersCard[thisTurnPlayer - 1], thisTurnPlayer).then((value) {
                                                                        //function that choose a card
                                                                        for (int k = 0; k < selectedCard.length; k++) {
                                                                          if (selectedCard[k]) {
                                                                            thisRoundCard.add(playersCard[thisTurnPlayer - 1][k]);
                                                                            eachRoundSelectedCards.putIfAbsent(thisTurnPlayer, () => playersCard[thisTurnPlayer - 1][k]);
                                                                            List<int> remainingCards = playersCard[thisTurnPlayer - 1].toList();
                                                                            remainingCards.remove(playersCard[thisTurnPlayer - 1][k]);
                                                                            playersCard[thisTurnPlayer - 1] = remainingCards;
                                                                            for (int k = 0; k < selectedCard.length; k++) {
                                                                              selectedCard[k] = false; //deselect all cards
                                                                            }
                                                                          }
                                                                        }
                                                                        if (thisTurnPlayer < numberOfPlayer) {
                                                                          thisTurnPlayer++;
                                                                        } else {
                                                                          counting = true;
                                                                          showThisRoundCard = true;
                                                                          thisTurnPlayer = 1;
                                                                        }
                                                                      });
                                                                      //
                                                                    }
                                                                  } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      const SnackBar(
                                                                        content: Text('Please Choose One Card !!'),
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                                // print('Player ' + thisTurnPlayer.toString());
                                                              },
                                                              child: Text(
                                                                (thisTurnPlayer == numberOfPlayer) ? 'End Turn' : 'Next Player',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                ),
                                                              )),
                                                        )
                                                      : Container(
                                                          // color: Colors.amber,
                                                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                          child: OutlinedButton(
                                                              style: OutlinedButton.styleFrom(
                                                                backgroundColor: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                ),
                                                                side: BorderSide(
                                                                  width: 2,
                                                                  // color: Color(0xff54c3c2),
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              onPressed: () async {
                                                                bool placeCardFinished = false;
                                                                int selectedRow = -1;
                                                                await computerBrainChooseRow().then((value) => selectedRow = value);
                                                                //Multiplayer
                                                                if (!roundEnded) {
                                                                  setState(() {
                                                                    if (!placeCard) {
                                                                      for (int i = 0; i < thisRoundCard.length; i++) {
                                                                        KEYS[i].currentState!.flipOnce(); //SHOW SELECTED CARDS
                                                                      }
                                                                      placeCard = true;
                                                                      thisRoundCard.sort();
                                                                    } else {
                                                                      //placeCard  here
                                                                      //Multiplayer Mode
                                                                      if (!singlePlayerMode) {
                                                                        if (placeCardFn(thisRoundCard[0]) || (thisRoundCard[0] == 0)) {
                                                                          for (int i = 1; i < thisRoundCard.length; i++) {
                                                                            placeCardFinished = placeCardFn(thisRoundCard[i]);
                                                                          }
                                                                          if (placeCardFinished) {
                                                                            roundEnded = true;
                                                                            placeCard = false;
                                                                            showThisRoundCard = false;
                                                                            thisRoundCard.clear();
                                                                            eachRoundSelectedCards.clear();
                                                                          }
                                                                        } else {
                                                                          print('Smallest Card Player have to choose one row to eat.');
                                                                          haveEatBullHeadChoice = true;
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                            const SnackBar(
                                                                              content: Text('"Smallest Card Player" have to choose one row to eat.\nPlease Click on the Red Card to Select one Row!'),
                                                                            ),
                                                                          );
                                                                        }
                                                                      } else {
                                                                        //singlePlayerMode
                                                                        print('singlePlayerMode is on');
                                                                        if (placeCardFn(thisRoundCard[0]) || (thisRoundCard[0] == 0)) {
                                                                          for (int i = 1; i < thisRoundCard.length; i++) {
                                                                            placeCardFinished = placeCardFn(thisRoundCard[i]);
                                                                          }
                                                                          if (placeCardFinished) {
                                                                            roundEnded = true;
                                                                            placeCard = false;
                                                                            showThisRoundCard = false;
                                                                            thisRoundCard.clear();
                                                                            eachRoundSelectedCards.clear();
                                                                          }
                                                                        } else {
                                                                          print(eachRoundSelectedCards);
                                                                          if (thisRoundCard[0] != eachRoundSelectedCards[1]) {
                                                                            haveEatBullHeadChoice = true;
                                                                            print('computer choose one row');
                                                                            if (haveEatBullHeadChoice) {
                                                                              print(selectedRow);
                                                                              setState(() {
                                                                                playersBullheads[findPlayerWithSelectedCard(thisRoundCard[0])] += int.parse(countAteBullHead(selectedRow).toString());
                                                                                bullHeadAteThisRound.putIfAbsent(findPlayerWithSelectedCard(thisRoundCard[0]) + 1, () => int.parse(countAteBullHead(selectedRow).toString()));
                                                                                gamePool[selectedRow].clear();
                                                                                gamePool[selectedRow].add(thisRoundCard[0]);
                                                                                thisRoundCard.remove(thisRoundCard[0]);
                                                                                thisRoundCard.add(0);
                                                                                thisRoundCard.sort();
                                                                                haveEatBullHeadChoice = false;
                                                                              });
                                                                            }
                                                                          } else {
                                                                            print('Smallest Card Player have to choose one row to eat.');
                                                                            haveEatBullHeadChoice = true;
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Text('"Smallest Card Player" have to choose one row to eat.\nPlease Click on the Red Card to Select one Row!'),
                                                                              ),
                                                                            );
                                                                          }
                                                                        }
                                                                      }
                                                                    }
                                                                    // roundEnded = true;
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    if (round < 10) {
                                                                      //NEXT ROUND BUTTON
                                                                      bullHeadAteThisRound.clear();
                                                                      counting = false;
                                                                      roundEnded = false;
                                                                      round++;
                                                                    } else {
                                                                      // Show Result Button
                                                                      for (int i = 0; i < numberOfPlayer; i++) {
                                                                        playersResults.putIfAbsent(i, () => playersBullheads[i]);
                                                                      }
                                                                      playersBullheads.sort();
                                                                      gameEnded = true;
                                                                    }
                                                                    // eachRoundSelectedCards.clear();
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                !placeCard ? (roundEnded ? ((round == 10) ? 'Show Result' : 'Next Round') : 'Show Cards') : (haveEatBullHeadChoice ? 'Choose Row' : 'Place Cards'),
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                ),
                                                              )),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Container(
                                    // color: Colors.blueGrey,
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              //HERE 18:28
                                              Stack(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Container(
                                                            // color: Colors.amber,
                                                            child: OutlinedButton(
                                                              style: OutlinedButton.styleFrom(
                                                                backgroundColor: Colors.white,
                                                                shape: CircleBorder(),
                                                                side: BorderSide(
                                                                  width: 2,
                                                                  // color: Color(0xff54c3c2),
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  numberOfPlayer = 2;
                                                                  thisTurnPlayer = 1;
                                                                  focusedCard = 0;
                                                                  round = 1;
                                                                  gameStart = false;
                                                                  gameEnded = false;
                                                                  counting = false;
                                                                  roundEnded = false;
                                                                  placeCard = false;
                                                                  playerReady = false;
                                                                  scrollViewEnable = false;
                                                                  singlePlayerMode = false;
                                                                  showThisRoundCard = false;
                                                                  haveEatBullHeadChoice = false;
                                                                  secretSwitch = false;
                                                                  bullHeadAteThisRound = {};
                                                                  eachRoundSelectedCards = {};
                                                                  playersResults = {};
                                                                  playersBullheads = [];
                                                                  iniCard = initializeCard();
                                                                  thisRoundCard.clear();
                                                                });
                                                                print('Game restarted!');
                                                              },
                                                              child: Icon(
                                                                Icons.restart_alt_sharp,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                        // color:
                                                        // Colors.amberAccent,
                                                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              'Game Result:',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      for (int i = 0; i < numberOfPlayer; i++)
                                                        Container(
                                                          // color: Colors.blue,
                                                          padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Container(
                                                                width: 110,
                                                                // color: Colors.blueGrey,
                                                                alignment: Alignment.topLeft,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    if (playersResults[i] == playersBullheads[0])
                                                                      Container(
                                                                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                                        child: Icon(
                                                                          Icons.star_rounded,
                                                                          color: Colors.yellow,
                                                                          size: 30,
                                                                        ),
                                                                      )
                                                                    else if (playersResults[i] == playersBullheads.last)
                                                                      Container(
                                                                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                                        child: Icon(
                                                                          Icons.sentiment_dissatisfied_rounded,
                                                                          color: Colors.black,
                                                                          size: 26,
                                                                        ),
                                                                      ),
                                                                    (!singlePlayerMode)
                                                                        ? Container(
                                                                            child: Text(
                                                                              'Player ' + (i + 1).toString(),
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : (i == 0)
                                                                            ? Container(
                                                                                child: Text(
                                                                                  'You',
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container(
                                                                                child: Text(
                                                                                  'Com ' + (i).toString(),
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      // '',
                                                                      playersResults[i].toString(),
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 18,
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      Icons.pest_control,
                                                                      color: Colors.black,
                                                                      size: 20,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                    ],
                  ))),

          /// Buttom Panel
          gameStart
              ? Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  color: Colors.pink,
                  child: !gameEnded
                      ? Row(
                          children: [
                            //players' cards
                            !counting
                                ? (playerReady)
                                    ? Container(
                                        // color: Colors.blueAccent,
                                        width: MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            !scrollViewEnable
                                                ? Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                      // color: Colors.blueGrey,
                                                      child: Wrap(
                                                        alignment: WrapAlignment.center,
                                                        children: [
                                                          for (int i = 0; i < playersCard[thisTurnPlayer - 1].length; i++)
                                                            GestureDetector(
                                                              onTap: () {
                                                                //Multiplayer
                                                                setState(() {
                                                                  selectedCard[i] = !selectedCard[i];
                                                                  for (int k = 0; k < selectedCard.length; k++) {
                                                                    if (k != i) {
                                                                      selectedCard[k] = false;
                                                                    }
                                                                  }
                                                                });
                                                                // print(selectedCard[i]);
                                                              },
                                                              child: Container(
                                                                color: selectedCard[i] ? Colors.amber : Colors.transparent,
                                                                child: CardUI(
                                                                  // key: new key,
                                                                  value: playersCard[thisTurnPlayer - 1],
                                                                  indexOfCard: i,
                                                                  gameStart: gameStart,
                                                                  showCardFront: true,
                                                                  canFlip: false,
                                                                  // setCardState: setStateFn(),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                //Enable Scroll Cards
                                                : Container(
                                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    height: 80,
                                                    width: MediaQuery.of(context).size.width,
                                                    child: ListView(
                                                      physics: BouncingScrollPhysics(),
                                                      scrollDirection: Axis.horizontal,
                                                      children: [
                                                        for (int i = 0; i < playersCard[thisTurnPlayer - 1].length; i++)
                                                          GestureDetector(
                                                            onTap: () {
                                                              //Multiplayer
                                                              setState(() {
                                                                selectedCard[i] = !selectedCard[i];
                                                                for (int k = 0; k < selectedCard.length; k++) {
                                                                  if (k != i) {
                                                                    selectedCard[k] = false;
                                                                  }
                                                                }
                                                              });
                                                              // print(selectedCard[i]);
                                                            },
                                                            child: Container(
                                                              color: selectedCard[i] ? Colors.amber : Colors.transparent,
                                                              child: CardUI(
                                                                // key: new key,
                                                                value: playersCard[thisTurnPlayer - 1],
                                                                indexOfCard: i,
                                                                gameStart: gameStart,
                                                                showCardFront: true,
                                                                canFlip: false,
                                                                // setCardState: setStateFn(),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        ),
                                      )
                                    : Expanded(
                                        child: !singlePlayerMode
                                            ? Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Are you ready?',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Container(
                                                      // color: Colors.amber,
                                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                      child: OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                          backgroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                          ),
                                                          side: BorderSide(
                                                            width: 2,
                                                            // color: Color(0xff54c3c2),
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            playerReady = true;
                                                          });
                                                        },
                                                        child: Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      )
                                : Expanded(
                                    child: Container(
                                      // color: Colors.blueAccent,
                                      child: Column(
                                        mainAxisAlignment: showThisRoundCard ? MainAxisAlignment.start : MainAxisAlignment.center,
                                        children: [
                                          if (showThisRoundCard)
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 100,
                                              // color: Colors.blueAccent,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  //This Round Card
                                                  Expanded(
                                                    child: Container(
                                                      alignment: Alignment.topCenter,
                                                      // color: Colors.orangeAccent,
                                                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                      child: Wrap(
                                                        alignment: WrapAlignment.center,
                                                        children: [
                                                          for (int i = 0; i < thisRoundCard.length; i++)
                                                            if (thisRoundCard[i] != 0)
                                                              Container(
                                                                // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                // color: Colors
                                                                //     .amber,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    for (int n = 0; n < numberOfPlayer; n++)
                                                                      if (thisRoundCard[i] == eachRoundSelectedCards[n + 1])
                                                                        Text(
                                                                          'P' + (n + 1).toString(),
                                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                    Container(
                                                                      // decoration: BoxDecoration(color: Colors.amber[600], border: Border.all()),
                                                                      child: CardUI(
                                                                        key: KEYS[i],
                                                                        value: thisRoundCard,
                                                                        indexOfCard: i,
                                                                        gameStart: gameStart,
                                                                        showCardFront: false,
                                                                        canFlip: false,
                                                                        // setCardState: setStateFn(),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (!placeCard)
                                            for (int i = 0; i < numberOfPlayer; i++)
                                              if (bullHeadAteThisRound[i + 1] != null)
                                                Container(
                                                  // color: Colors.green,
                                                  padding: EdgeInsets.fromLTRB(100, 5, 100, 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                                                        child: Text(
                                                          'Player ' + (i + 1).toString(),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '+' + bullHeadAteThisRound[i + 1].toString(),
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.pest_control,
                                                            color: Colors.black,
                                                            size: 25,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      : Center(
                          child: Text(
                            'Game Over',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ),
                )
              : Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
                  color: Colors.pink,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          // color: Colors.orange,
                          child: Container(
                            height: 150,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  side: BorderSide(
                                    width: 2,
                                    // color: Color(0xff54c3c2),
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  print('previous Card');
                                  _key.currentState!.previousCard();
                                  _key.currentState!.setStateFn();
                                },
                                child: Text(
                                  'Previous\nCard',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          // color: Colors.orange,
                          child: Container(
                            height: 150,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  side: BorderSide(
                                    width: 2,
                                    // color: Color(0xff54c3c2),
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  _key.currentState!.humanShuffle(initializeCard());
                                  iniCard = _key.currentState!.computerShuffle();
                                  _key.currentState!.setStateFn();
                                },
                                child: Text(
                                  'Shuffle',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                          // color: Colors.orange,
                          child: Container(
                            height: 150,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  side: BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  print('next Card');
                                  _key.currentState!.nextCard();
                                  _key.currentState!.setStateFn();
                                },
                                child: Text(
                                  'Next\nCard',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CardUI extends StatefulWidget {
  List<int> value;
  int indexOfCard;
  bool gameStart;
  bool showCardFront;
  bool canFlip;
  // final Function setCardState;
  CardUI({Key? key, required this.value, required this.indexOfCard, required this.gameStart, required this.showCardFront, required this.canFlip
      /*required this.setCardState*/
      })
      : super(key: key);

  @override
  _CardUIState createState() => _CardUIState();
}

class _CardUIState extends State<CardUI> {
  var flipCardController = new FlipCardController();

  setStateFn() {
    setState(() {
      print('child widget state set');
    });
  }

  nextCard() {
    if (widget.indexOfCard < widget.value.length - 1) {
      widget.indexOfCard++;
      print(widget.indexOfCard.toString());
    } else {
      print('This is the last Card');
    }
  }

  previousCard() {
    if (widget.indexOfCard > 0) {
      widget.indexOfCard--;
      print(widget.indexOfCard);
    } else {
      print('This is the first Card');
    }
  }

  countBullHead(int card) {
    if (card == 55) {
      return 7;
    } else if (card % 11 == 0) {
      return 5;
    } else if (card % 10 == 0) {
      return 3;
    } else if (card % 5 == 0) {
      return 2;
    } else {
      return 1;
    }
  }

  bullHeadColor(int numberOfBullHead) {
    if (numberOfBullHead == 1) {
      return Colors.black;
    }
    if (numberOfBullHead == 2) {
      return Colors.blue[300];
    }
    if (numberOfBullHead == 3) {
      return Colors.green;
    }
    if (numberOfBullHead == 5) {
      return Colors.red[900];
    }
    if (numberOfBullHead == 7) {
      return Colors.amber;
    }
  }

  humanShuffle(List<int> card) {
    var rng = new Random();
    int shuffleCount = 5 + rng.nextInt(5);
    // print(card[0]);
    late List<int> list;
    for (int i = 0; i < shuffleCount; i++) {
      list = List.filled(104, 0);
      int newTop = rng.nextInt(52);
      int newBottom = 52 + rng.nextInt(52);
      // print('newTop: ' + newTop.toString());
      // print('newBottom: ' + newBottom.toString());
      for (int n = 0; n + newTop < newBottom; n++) {
        list[n] = card[newTop + n];
      }
      for (int n = 0; n < newTop; n++) {
        list[newBottom - newTop + n] = card[n];
      }
      for (int n = 0; n < 104 - newBottom; n++) {
        list[newBottom + n] = card[newBottom + n];
      }
      card = list;
    }
    widget.value = list;
    print('Card shuffled');
    // print(list);
    // return list;
  }

  computerShuffle() {
    widget.value.shuffle();
    return widget.value;
  }

  int flipCount = 1;
  flipOnce() {
    if (flipCount > 0) {
      flipCardController.toggleCard();
      flipCount--;
    }
  }

  @override
  void initState() {
    super.initState();
    flipCount = 1;
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.value[widget.indexOfCard] != 0) {
    return Container(
      width: widget.gameStart ? 60 : 150,
      height: widget.gameStart ? 80 : 200,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        flipOnTouch: widget.canFlip ? true : false,
        controller: flipCardController,
        onFlip: () {},
        onFlipDone: (ok) {},
        front: widget.showCardFront
            ? Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                // shadowColor: Colors.black,
                shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        // color: Colors.amber,
                        border: Border(
                      bottom: BorderSide(color: Colors.black),
                    )),
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                    height: widget.gameStart ? 24 : 60,
                    child: Wrap(alignment: WrapAlignment.center, children: [
                      for (int i = 0; i < countBullHead(widget.value[widget.indexOfCard]); i++)
                        Icon(
                          Icons.pest_control,
                          color: bullHeadColor(countBullHead(widget.value[widget.indexOfCard])),
                          size: widget.gameStart ? 10 : 20,
                        ),
                    ]),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      // color: Colors.red,
                      child: Text(
                        widget.value[widget.indexOfCard].toString(),
                        style: TextStyle(
                          color: bullHeadColor(countBullHead(widget.value[widget.indexOfCard])),
                          fontSize: widget.gameStart ? 20 : 30,
                        ),
                      ),
                    ),
                  ),
                ]),
              )
            : Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                // shadowColor: Colors.black,
                shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.black,
                child: Column(children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      // color: Colors.red,
                      child: Icon(
                        Icons.pest_control,
                        color: Color(0xfff2f7ff),
                      ),
                    ),
                  ),
                ]),
              ),
        back: widget.showCardFront
            ? Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                // shadowColor: Colors.black,
                shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.black,
                child: Column(children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      // color: Colors.red,
                      child: Icon(
                        Icons.pest_control,
                        color: Color(0xfff2f7ff),
                      ),
                    ),
                  ),
                ]),
              )
            : Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                // shadowColor: Colors.black,
                shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        // color: Colors.amber,
                        border: Border(
                      bottom: BorderSide(color: Colors.black),
                    )),
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                    height: widget.gameStart ? 24 : 60,
                    child: Wrap(alignment: WrapAlignment.center, children: [
                      for (int i = 0; i < countBullHead(widget.value[widget.indexOfCard]); i++)
                        Icon(
                          Icons.pest_control,
                          color: bullHeadColor(countBullHead(widget.value[widget.indexOfCard])),
                          size: widget.gameStart ? 10 : 20,
                        ),
                    ]),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      // color: Colors.red,
                      child: Text(
                        widget.value[widget.indexOfCard].toString(),
                        style: TextStyle(
                          color: bullHeadColor(countBullHead(widget.value[widget.indexOfCard])),
                          fontSize: widget.gameStart ? 20 : 30,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
      ),
    );
    // } else {
    //   return Container(
    //     width: 60,
    //     height: 80,
    //     color: Colors.white,
    //   );
    // }
  }
}

void main() {
  runApp(homeUI());
}
