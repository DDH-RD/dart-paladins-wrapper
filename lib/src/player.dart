class Player {
  int? activePlayerId;
  int? avatarId;
  String? avatarURL;
  DateTime? createdDatetime;
  int? hoursPlayed;
  int? id;
  DateTime? lastLoginDatetime;
  int? leaves;
  int? level;
  String? loadingFrame;
  int? losses;
  int? masteryLevel;
  List<MergedPlayer>? mergedPlayers;
  int? minutesPlayed;
  String? name;
  String? personalStatusMessage;
  String? platform;
  RankedStats? rankedConquest;
  RankedStats? rankedController;
  RankedStats? rankedKBM;
  String? region;
  int? teamId;
  String? teamName;
  int? tierConquest;
  int? tierRankedController;
  int? tierRankedKBM;
  String? title;
  int? totalAchievements;
  int? totalWorshippers;
  int? totalXP;
  int? wins;
  String? hzGamerTag;
  String? hzPlayerName;
  String? privacyFlag;

  Player({
    this.activePlayerId,
    this.avatarId,
    this.avatarURL,
    this.createdDatetime,
    this.hoursPlayed,
    this.id,
    this.lastLoginDatetime,
    this.leaves,
    this.level,
    this.loadingFrame,
    this.losses,
    this.masteryLevel,
    this.mergedPlayers,
    this.minutesPlayed,
    this.name,
    this.personalStatusMessage,
    this.platform,
    this.rankedConquest,
    this.rankedController,
    this.rankedKBM,
    this.region,
    this.teamId,
    this.teamName,
    this.tierConquest,
    this.tierRankedController,
    this.tierRankedKBM,
    this.title,
    this.totalAchievements,
    this.totalWorshippers,
    this.totalXP,
    this.wins,
    this.hzGamerTag,
    this.hzPlayerName,
    this.privacyFlag,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    String? createdDatetimeString = json["Created_Datetime"];
    String? lastLoginDatetimeString = json["Last_Login_Datetime"];

    DateTime? createdDatetime = _parseCustomDateTime(createdDatetimeString);
    DateTime? lastLoginDatetime = _parseCustomDateTime(lastLoginDatetimeString);

    return Player(
      activePlayerId: json["ActivePlayerId"],
      avatarId: json["AvatarId"],
      avatarURL: json["AvatarURL"],
      createdDatetime: createdDatetime,
      hoursPlayed: json["HoursPlayed"],
      id: json["Id"],
      lastLoginDatetime: lastLoginDatetime,
      leaves: json["Leaves"],
      level: json["Level"],
      loadingFrame: json["LoadingFrame"],
      losses: json["Losses"],
      masteryLevel: json["MasteryLevel"],
      mergedPlayers: (json["MergedPlayers"] as List?)?.map((x) => MergedPlayer.fromJson(x)).toList(),
      minutesPlayed: json["MinutesPlayed"],
      name: json["Name"],
      personalStatusMessage: json["Personal_Status_Message"],
      platform: json["Platform"],
      rankedConquest: RankedStats.fromJson(json["RankedConquest"]),
      rankedController: RankedStats.fromJson(json["RankedController"]),
      rankedKBM: RankedStats.fromJson(json["RankedKBM"]),
      region: json["Region"],
      teamId: json["TeamId"],
      teamName: json["Team_Name"],
      tierConquest: json["Tier_Conquest"],
      tierRankedController: json["Tier_RankedController"],
      tierRankedKBM: json["Tier_RankedKBM"],
      title: json["Title"],
      totalAchievements: json["Total_Achievements"],
      totalWorshippers: json["Total_Worshippers"],
      totalXP: json["Total_XP"],
      wins: json["Wins"],
      hzGamerTag: json["hz_gamer_tag"],
      hzPlayerName: json["hz_player_name"],
      privacyFlag: json["privacy_flag"],
    );
  }

  static DateTime? _parseCustomDateTime(String? dateTimeString) {
    if (dateTimeString == null) return null;
    List<String> dateTimeParts = dateTimeString.split(' ');
    String datePart = dateTimeParts[0];
    String timePart = dateTimeParts[1];

    List<String> dateParts = datePart.split('/');
    List<String> timeParts = timePart.split(':');

    int year = int.parse(dateParts[2]);
    int month = int.parse(dateParts[0]);
    int day = int.parse(dateParts[1]);
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    return DateTime(year, month, day, hour, minute, second);
  }

  @override
  String toString() {
    return 'Player{activePlayerId: $activePlayerId, '
        'avatarId: $avatarId, '
        'avatarURL: $avatarURL, '
        'createdDatetime: $createdDatetime, '
        'hoursPlayed: $hoursPlayed, '
        'id: $id, '
        'lastLoginDatetime: $lastLoginDatetime, '
        'leaves: $leaves, '
        'level: $level, '
        'loadingFrame: $loadingFrame, '
        'losses: $losses, '
        'masteryLevel: $masteryLevel, '
        'mergedPlayers: $mergedPlayers, '
        'minutesPlayed: $minutesPlayed, '
        'name: $name, '
        'personalStatusMessage: $personalStatusMessage, '
        'platform: $platform, '
        'rankedConquest: $rankedConquest, '
        'rankedController: $rankedController, '
        'rankedKBM: $rankedKBM, '
        'region: $region, '
        'teamId: $teamId, '
        'teamName: $teamName, '
        'tierConquest: $tierConquest, '
        'tierRankedController: $tierRankedController, '
        'tierRankedKBM: $tierRankedKBM, '
        'title: $title, '
        'totalAchievements: $totalAchievements, '
        'totalWorshippers: $totalWorshippers, '
        'totalXP: $totalXP, '
        'wins: $wins, '
        'hzGamerTag: $hzGamerTag, '
        'hzPlayerName: $hzPlayerName, '
        'privacyFlag: $privacyFlag}';
  }
}

class MergedPlayer {
  String? mergeDatetime;
  int? playerId;
  int? portalId;

  MergedPlayer({
    required this.mergeDatetime,
    required this.playerId,
    required this.portalId,
  });

  factory MergedPlayer.fromJson(Map<String, dynamic> json) {
    return MergedPlayer(
      mergeDatetime: json["merge_datetime"],
      playerId: json["player_id"],
      portalId: json["portal_id"],
    );
  }

  @override
  String toString() {
    return 'MergedPlayer{mergeDatetime: $mergeDatetime, playerId: $playerId, portalId: $portalId}';
  }
}

class RankedStats {
  int? leaves;
  int? losses;
  String? name;
  int? points;
  int? prevRank;
  int? rank;
  int? season;
  int? tier;
  int? trend;
  int? wins;
  int? playerId;
  String? retMsg;

  RankedStats({
    required this.leaves,
    required this.losses,
    required this.name,
    required this.points,
    required this.prevRank,
    required this.rank,
    required this.season,
    required this.tier,
    required this.trend,
    required this.wins,
    this.playerId,
    this.retMsg,
  });

  factory RankedStats.fromJson(Map<String, dynamic> json) {
    return RankedStats(
      leaves: json["Leaves"],
      losses: json["Losses"],
      name: json["Name"],
      points: json["Points"],
      prevRank: json["PrevRank"],
      rank: json["Rank"],
      season: json["Season"],
      tier: json["Tier"],
      trend: json["Trend"],
      wins: json["Wins"],
      playerId: json["player_id"],
      retMsg: json["ret_msg"],
    );
  }

  @override
  String toString() {
    return 'RankedStats{leaves: $leaves, losses: $losses, '
        'name: $name, points: $points, prevRank: $prevRank, rank: $rank, season: $season, tier: $tier, '
        'trend: $trend, wins: $wins, playerId: $playerId, retMsg: $retMsg}';
  }
}
