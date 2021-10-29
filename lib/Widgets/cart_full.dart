import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';


class CartFull extends StatefulWidget {
  const CartFull({Key? key}) : super(key: key);

  @override
  _CartFullState createState() => _CartFullState();
}

class _CartFullState extends State<CartFull> {
  @override
  Widget build(BuildContext context) {
    final themeChanged = Provider.of<DarkThemeProvider>(context);
    return Container(
      height: 140,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomRight: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0)),
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
        children: [
          Container(
            width: 130,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://image.freepik.com/free-icon/ticket_318-1629.jpg'),
                    fit: BoxFit.fill)),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Title',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32),
                          onTap: () {},
                          child: Container(
                              height: 50,
                              width: 50,
                              child: Icon(Entypo.cross,
                                  color: Colors.red, size: 23)),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text('Price'),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '150',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text('Subtotal'),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '150',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: themeChanged.darkTheme
                                ? Colors.brown.shade900
                                : Theme.of(context).accentColor),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Ships Free',
                        style: TextStyle(
                            color: themeChanged.darkTheme
                                ? Colors.brown.shade900
                                : Theme.of(context).accentColor),
                      ),
                      Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () {},
                          child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Entypo.minus,
                                    color: Colors.red, size: 23),
                              )),
                        ),
                      ),
                      Card(
                        elevation: 12,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            MyAppColor.gradiendLStart,
                            MyAppColor.blueGrey,
                          ], stops: [
                            0.0,
                            0.7
                          ],),
                          ),
                          // ** BOX TO DISPLAY THE NUMBER OF QUANTITY **
                          child: Text('3',
                          textAlign: TextAlign.center,),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () {},
                          child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Entypo.plus,
                                    color: Colors.green, size: 23),
                              )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
