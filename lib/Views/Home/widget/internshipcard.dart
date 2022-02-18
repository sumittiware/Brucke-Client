import 'package:brucke_app/Providers/feedsProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Home/internshipDetail.dart';
import 'package:brucke_app/common/showmessage.dart';
import 'package:brucke_app/config/fromatdate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InternshipCard extends StatefulWidget {
  final id;
  InternshipCard({this.id});
  @override
  _InternshipCardState createState() => _InternshipCardState();
}

class _InternshipCardState extends State<InternshipCard> {
  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedsProvider>(context);
    final currentInternship = feedProvider.getById(widget.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return InternshipDetail(
              internshipId: widget.id,
            );
          }));
        },
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentInternship.name,
                          style: TextStyle(
                              color: textBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          currentInternship.company.name,
                          style: TextStyle(fontSize: 14, color: textGrey),
                        ),
                      ],
                    ),
                    Image(
                      image: NetworkImage(currentInternship.company.imageUrl),
                      height: 40,
                      width: 40,
                    )
                  ],
                ),
                _buildMethod(
                    Icons.location_on_rounded, currentInternship.location),
                Row(
                  children: [
                    _buildMethod(
                        Icons.money_outlined, "₹ ${currentInternship.stipend}"),
                    SizedBox(
                      width: 16,
                    ),
                    _buildMethod(Icons.calendar_today_rounded,
                        currentInternship.duration),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(children: [
                        Icon(
                          Icons.hourglass_empty_outlined,
                          color: textGrey,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Apply By ${getFormatedDate(currentInternship.closeDate)}",
                          style: TextStyle(color: textGrey, fontSize: 12),
                        ),
                      ]),
                    ),
                    IconButton(
                        onPressed: () {
                          feedProvider.toogleSavedInternships(widget.id,
                              feedProvider.savedIds.contains(widget.id));
                          showCustomSnackBar(
                              context,
                              (!feedProvider.savedIds.contains(widget.id))
                                  ? "Internship added to saved"
                                  : "Intership removed from saved");
                        },
                        icon: Icon(
                          (feedProvider.savedIds.contains(widget.id))
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: contenText,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethod(IconData icon, String tag) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(
          icon,
          color: contenText,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          tag,
          style: TextStyle(color: contenText, fontSize: 14),
        ),
      ]),
    );
  }
}
