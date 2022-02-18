class AppUser {
  String uid;
  String name;
  String college;
  String mailId;
  String branch;
  String yearofgraduation;
  List<dynamic> categories;
  String resumeUrl;
  int currentCredits;
  List<Map<String,dynamic>> appliedInternships;
  bool isComplete;

  AppUser(
      {this.uid,
      this.name,
      this.college,
      this.branch,
      this.categories,
      this.mailId,
      this.yearofgraduation,
      this.resumeUrl,
      this.currentCredits,
      this.appliedInternships,
      this.isComplete});
}
