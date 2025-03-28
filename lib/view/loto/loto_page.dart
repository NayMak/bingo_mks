import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loto_mks/components/modal.dart';
import 'package:loto_mks/provider/loto_provider.dart';
import 'package:loto_mks/view/loto/circle_button.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';

class LotoPage extends StatefulWidget {
  const LotoPage({super.key});

  @override
  State<LotoPage> createState() => _LotoPageState();
}

class _LotoPageState extends State<LotoPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LotoProvider>(
      create: (_) => LotoProvider(),
      child: Scaffold(
        backgroundColor: Colors.tealAccent,
        body: Consumer<LotoProvider>(
          builder: (context, provider, Widget? child) {
            return Center(
              child: Column(
                children: [
                  Text(
                    'JEU DU BINGO !',
                    style: TextStyle(
                      fontSize: 96,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.withValues(alpha: 0.3),
                    thickness: 2,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        spacing: 16,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: provider.currentCard == null
                                  ? Center(
                                      child: Text(
                                        'Lancer le jeu pour commencer à tirer les cartes',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 1.0,
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Image(
                                          image: AssetImage(
                                            provider.currentCard!.asset,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: provider.isGameStarted
                                ? MainAxisAlignment.spaceEvenly
                                : MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: provider.isGameStarted,
                                child: CircleButton(
                                  icon: FontAwesomeIcons.fileArrowUp,
                                  onPressed: () {
                                    provider.selectRandomCard();
                                  },
                                ),
                              ),
                              Visibility(
                                visible: !provider.isGameStarted,
                                child: Column(
                                  children: [
                                    CircleButton(
                                      icon: FontAwesomeIcons.circlePlay,
                                      onPressed: () {
                                        provider
                                          ..init()
                                          ..startGame()
                                          ..selectRandomCard();
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    CircleButton(
                                      icon: FontAwesomeIcons.arrowLeft,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    /*
                                SizedBox(height: 16),
                                Visibility(
                                  visible: provider.isGameStarted,
                                  child: CircleButton(
                                    icon: provider.isSoundOn
                                        ? Icons.volume_up
                                        : Icons.volume_off,
                                    onPressed: () {
                                      provider.soundOption();
                                    },
                                  ),
                                ),
                                */
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: provider.isGameStarted,
                                child: Column(
                                  children: [
                                    CircleButton(
                                      icon: FontAwesomeIcons.b,
                                      backgroundColor: Colors.redAccent,
                                      onPressed: () {
                                        if (provider.isSoundOn) {
                                          provider.player = AudioPlayer()
                                            ..setUrl(
                                              'assets/audio/bingo_win.mp3',
                                            );
                                        }
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            if (provider.isSoundOn) {
                                              provider.player!.play();
                                            }
                                            return AlertDialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              scrollable: true,
                                              content: Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/bingo/bingo.png',
                                                  ),
                                                  CircleButton(
                                                    icon:
                                                        FontAwesomeIcons.house,
                                                    onPressed: () {
                                                      if (provider.isSoundOn) {
                                                        provider.player!.stop();
                                                      }
                                                      Navigator.popUntil(
                                                        context,
                                                        (route) =>
                                                            route.isFirst,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    CircleButton(
                                      icon: FontAwesomeIcons.arrowRotateRight,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ChangeNotifierProvider.value(
                                              value: provider,
                                              child: Modal(
                                                title:
                                                    'Souhaitez-vous démarrer une nouvelle partie ?',
                                                subtitle:
                                                    'Les numéros tirées lors de la partie en cours seront réinitialisés.',
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleButton(
                                        icon: FontAwesomeIcons.tableCellsLarge,
                                        onPressed: () {
                                          provider.updateGridViewAxisCount(3);
                                        },
                                        disable:
                                            provider.gridViewAxisCount == 3,
                                      ),
                                      SizedBox(width: 16),
                                      CircleButton(
                                        icon: FontAwesomeIcons.tableCells,
                                        onPressed: () {
                                          provider.updateGridViewAxisCount(5);
                                        },
                                        disable:
                                            provider.gridViewAxisCount == 5,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Expanded(
                                    child: GridView.count(
                                      primary: false,
                                      padding: const EdgeInsets.all(8),
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4,
                                      crossAxisCount:
                                          provider.gridViewAxisCount,
                                      children: [
                                        ...provider.announcedCards.map((card) {
                                          return Image(
                                            image: AssetImage(card.asset),
                                          );
                                        }),
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
