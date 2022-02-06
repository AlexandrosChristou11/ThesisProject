/// @author: Alexandros Christou
/// Date: 06Feb21
/// MatchPreview model


class MatchPreview{
  String MatchName;
  String HomeTeam ;
  String AwayTeam;
  String DateAndTime;
  String Location ;
  String SportType ;
  String MatchType ;

  String SectorAStudentQuantity ;
  String SectorAStudentPrice ;
  String SectorARegularQuantity ;
  String SectorARegularPrice ;
  String SectorBStudentQuantity ;
  String SectorBStudentPrice ;
  String SectorBRegularQuantity ;
  String SectorBRegularPrice ;
  String SectorCStudentQuantity ;
  String SectorCStudentPrice ;
  String SectorCRegularQuantity ;
  String SectorCRegularPrice;

  MatchPreview(this.MatchName, this.HomeTeam, this.AwayTeam,
      this.DateAndTime, this.Location, this.SportType, this.MatchType,
      this.SectorAStudentQuantity, this.SectorAStudentPrice,
      this.SectorARegularQuantity, this.SectorARegularPrice,
      this.SectorBStudentQuantity, this.SectorBStudentPrice,
      this.SectorBRegularQuantity, this.SectorBRegularPrice,
      this.SectorCStudentQuantity, this.SectorCStudentPrice,
      this.SectorCRegularQuantity, this.SectorCRegularPrice);

}