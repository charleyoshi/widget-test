import 'package:flutter/material.dart';
import 'package:widget_test/mapscreen3.dart';
import 'mapscreen2.dart';
import 'mapscreen.dart';

class Situation extends StatelessWidget {
  const Situation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.grey,
      height: 200,
      child: Row(
          // width: double.infinity,
          // margin: EdgeInsets.all(10),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //const SizedBox(width: 1),
            Flexible(
              flex: 1,

              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen3()));
                        },
                        child: const Text('Offer'),
                      ),
                    ],
                  ),
                ),
              ),
              //const SizedBox(width: 1),),
            ),

            Flexible(
              flex: 1,

              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen2()));
                        },
                        child: const Text('Offer a Ride'),
                      ),
                    ],
                  ),
                ),
              ),
              //const SizedBox(width: 1),),
            ),
            Flexible(
              flex: 1,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen()));
                        },
                        child: const Text('Need An Umbrella'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
