
import 'package:sep21/Models/Sector.dart';
import 'package:sep21/Models/Stadium.dart';

class PopulateStadiums{

  PopulateStadiums() {
    List <Stadium> _stadiums = [
      Stadium("Antonis Papadopoulos", 7000,
        new Sector("SOUTH", 2400),
        new Sector("NORTH", 1200),
        new Sector("WEST", 3700),
        new Sector("EAST", 1500),
      ),

      Stadium("GSP Stadium", 22000,
        new Sector("SOUTH", 4000),
        new Sector("NORTH", 4000),
        new Sector("WEST", 6000),
        new Sector("EAST", 6000),
      ),

      Stadium("Tsireion Stadium", 8000,
        new Sector("SOUTH - N/A", 0),
        new Sector("NORTH - N/A", 0),
        new Sector("WEST", 4000),
        new Sector("EAST", 4000),
      ),

      Stadium("Aek Arena", 7500,
        new Sector("SOUTH", 1200),
        new Sector("NORTH", 1200),
        new Sector("WEST", 3000),
        new Sector("EAST", 2000),
      ),

      Stadium("Makarion Stadium", 19000,
        new Sector("SOUTH", 4000),
        new Sector("NORTH", 4000),
        new Sector("WEST", 6000),
        new Sector("EAST", 6000),
      ),

      Stadium("Stelios Kyriakides", 6000,
          new Sector("SOUTH - N/A", 0),
          new Sector("NORTH - N/A", 0),
          new Sector("WEST", 3000),
          new Sector("EAST", 3000))

    ];
  }
    List<Stadium> get stadiums {
      return stadiums;
    }



}