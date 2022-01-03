import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:ume_connect/models/videos.dart';

class VideoDetails extends StatelessWidget {
  const VideoDetails({Key? key, required this.postedBy, required this.caption})
      : super(key: key);
  final String postedBy;
  final String caption;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("$postedBy",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(
          height: 8,
        ),
        ExpandableText(
          caption,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
          expandText: 'show more',
          collapseText: 'show less',
          animation: true,
          expandOnTextTap: true,
          collapseOnTextTap: true,
          maxLines: 2,
          linkColor: Colors.grey,
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.music_note_outlined,
              size: 14,
              color: Colors.white,
            ),
            SizedBox(
              width: 8,
            ),
            Container(
                height: 20,
                width: MediaQuery.of(context).size.width / 2,
                child: Marquee(
                  text: "Audio name: Default Audio                 ",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  velocity: 20,
                ))
          ],
        ),
        //TODO USE SIZED BOX FOR GIVING A GAP
      ],
    );
  }
}
