
// In the particular.dart file the following operations
// will be implemented on the App (Home Screen):
// (1) Showing all teams as a navigator rail 
// (2) Function to press on the preferred team and execute appropriate messages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Inner%20Screens/teams_rail_widget.dart';
import 'package:sep21/Provider/Matches.dart';


class TeamsNavigationRailScreen extends StatefulWidget {
  const TeamsNavigationRailScreen({Key? key}) : super(key: key);

  static const routeName = '/team_navigation_rail';

  @override
  _TeamsNavigationRailScreenState createState() => _TeamsNavigationRailScreenState();
}

class _TeamsNavigationRailScreenState extends State<TeamsNavigationRailScreen> {

  int _selectedIndex = 0;
  final padding = 8.0;
  late String routeArgs;
  late String team;


  @override
  void didChangeDependencies() {
    routeArgs = ModalRoute.of(context)!.settings.arguments.toString();
    _selectedIndex = int.parse(
      routeArgs.substring(1,2)
    );
    print (routeArgs.toString());

    if (_selectedIndex == 0) {
      setState(() {
        team = 'ANORTHOSIS';
      });
    }
    if (_selectedIndex == 1) {
      setState(() {
        team = 'AEK';
      });
    }
    if (_selectedIndex == 2) {
      setState(() {
        team = 'AEL';
      });
    }
    if (_selectedIndex == 3) {
      setState(() {
        team = 'APOEL';
      });
    }
    if (_selectedIndex == 4) {
      setState(() {
        team = 'OMONOIA';
      });
    }

    if (_selectedIndex == 5) {
      setState(() {
        team = 'All';
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      minWidth: 55.0,
                      groupAlignment: 1.0,
                      selectedIndex: _selectedIndex,
                      // called when the user clicks on the a panel on the left tap
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                          // Setting states
                          if (_selectedIndex == 0) {
                            setState(() {
                              team = 'ANORTHOSIS';
                            });
                          }
                          if (_selectedIndex == 1) {
                            setState(() {
                              team = 'AEK';
                            });
                          }
                          if (_selectedIndex == 2) {
                            setState(() {
                              team = 'AEL';
                            });
                          }
                          if (_selectedIndex == 3) {
                            setState(() {
                              team = 'APOEL';
                            });
                          }
                          if (_selectedIndex == 4) {
                            setState(() {
                              team = 'OMONOIA';
                            });
                          }

                          if (_selectedIndex == 5) {
                            setState(() {
                              team = 'All';
                            });
                          }
                          print(this.team);
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      leading: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                  "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                      selectedLabelTextStyle: TextStyle(
                        color: Color(0xffffe6bc97),
                        fontSize: 20,
                        letterSpacing: 1,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.5,
                      ),
                      unselectedLabelTextStyle: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.8,
                      ),
                      destinations: [
                        buildRotatedTextRailDestination('Anorthosis', padding),
                        buildRotatedTextRailDestination("AEK", padding),
                        buildRotatedTextRailDestination("AEL", padding),
                        buildRotatedTextRailDestination("APOEL", padding),
                        buildRotatedTextRailDestination("OMONOIA", padding),
                        buildRotatedTextRailDestination("All", padding),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // This is the main content.

          ContentSpace(context, team)
        ],
      ),
    );
  }
}


NavigationRailDestination buildRotatedTextRailDestination(
    String text, double padding) {
  return NavigationRailDestination(
    icon: SizedBox.shrink(),
    label: Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: RotatedBox(
        quarterTurns: -1,
        child: Text(text),
      ),
    ),
  );
}

class ContentSpace extends StatelessWidget {
  // final int _selectedIndex;

  final String team;
  ContentSpace(BuildContext context, this.team);

  @override
  Widget build(BuildContext context) {
    final teamData = Provider.of<Matches>(context);
    final matchesTeams = teamData.findByTeam(team);
    if (team == 'All'){
      for (int i=0; i < teamData.matches.length; i++){
        matchesTeams.add(teamData.matches[i]);
      }
    }

    //print ("team: "+ team );
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
            itemCount: matchesTeams.length,
            itemBuilder: (BuildContext context, int index) =>
                ChangeNotifierProvider.value(
                    value: matchesTeams[index],
                    child: TeamsNavigationRail()),
          ),
        ),
      ),
    );
  }
}



