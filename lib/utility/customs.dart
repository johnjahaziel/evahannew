import 'package:evahan/utility/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

const List<Map<String, String>> bloodgroupItems = [
  {'label': 'A+', 'value': 'A+'},
  {'label': 'A-', 'value': 'A-'},
  {'label': 'B+', 'value': 'B+'},
  {'label': 'B-', 'value': 'B-'},
  {'label': 'AB+', 'value': 'AB+'},
  {'label': 'AB-', 'value': 'AB-'},
  {'label': 'O+', 'value': 'O+'},
  {'label': 'O-', 'value': 'O-'},
];

const List<Map<String, String>> reasonItems = [
  {'label': 'Money Theft', 'value': 'Money Theft'},
  {'label': 'Diesel Theft', 'value': 'Diesel Theft'},
  {'label': 'Misbehave', 'value': 'Misbehave'},
  {'label': 'Drink and Drive', 'value': 'Drink and Drive'},
];

textfield(
  String title,
  TextEditingController controller, {
  bool numpad = false,
  FocusNode? focusNode,
}) =>
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        color: Color(0xff919EAB),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 5),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        maxLines: 1,
        keyboardType:
            numpad ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xff919EAB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xff919EAB)),
          ),
        ),
      ),
    ),
  ],
);

password(String title, suffixIcon,bool isPassword,TextEditingController controller) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      title,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: Color(0xff919EAB)
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(top: 5),
      child: TextField(
        maxLines: 1,
        controller: controller,
        obscureText: !isPassword,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xff919EAB)
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xff919EAB)
            )
          ),
          suffixIcon: suffixIcon
        ),
      ),
    ),
  ],
);

errortext(String title) => Padding(
  padding: const EdgeInsets.only(left: 28,top: 3),
  child: Text(
    title,
    style: TextStyle(
      color: kred
    ),
  ),
);

decor(String title) => InputDecoration(
  hintText: title,
  hintStyle: TextStyle(
    fontFamily: 'Poppins',
    color: kred
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: kblackgrey
    )
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: kblackgrey
    )
  )
);

button(String title, VoidCallback onTap) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
    ),
    child: RawMaterialButton(
      onPressed: onTap,
      fillColor: kred,
      elevation: 2,
      constraints: BoxConstraints.tightFor(
        height: 55,
        width: double.infinity
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
      ),
    ),
  ),
);

String formatDateTime(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal();

  return DateFormat('dd MMM yyyy • hh:mm a').format(dateTime);
}

Widget homebox(
  String title,
  String content,
  String firstName,
  String lastName,
  // String phoneNumber,
  String createdAt,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: kred,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF555555),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Divider(),
                  const SizedBox(height: 2),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.person
                            ),
                            
                            const SizedBox(width: 10),
                            
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$firstName $lastName",
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // const SizedBox(height: 2),
                                // Row(
                                //   children: [
                                //     const Icon(
                                //       Icons.call,
                                //       size: 13,
                                //       color: Color(0xFF777777),
                                //     ),
                                //     const SizedBox(width: 4),
                                //     Text(
                                //       phoneNumber,
                                //       style: const TextStyle(
                                //         fontFamily: 'Poppins',
                                //         fontSize: 12,
                                //         color: Color(0xFF777777),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6F8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          formatDateTime(createdAt),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Color(0xFF666666),
                          ),
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

textfield2(String title, String title2) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xff919EAB)
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 25,right: 25,top: 10),
      child: TextField(
        maxLines: 1,
        decoration: InputDecoration(
          hintText: title2,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xff6C5B5B),
            fontSize: 11,
          ),
          filled: true,
          fillColor: Color(0xffD9D9D9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
          )
        )
      ),
    ),
  ],
);

fieldbox(String title) => Padding(
  padding: const EdgeInsets.only(left: 25,right: 25,top: 10),
  child: TextField(
    maxLines: 1,
    decoration: InputDecoration(
      hintText: title,
      hintStyle: TextStyle(
        fontFamily: 'Poppins',
        color: Color(0xff6C5B5B),
        fontSize: 11,
      ),
      filled: true,
      fillColor: Color(0xffD9D9D9),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none
      )
    )
  ),
);

Widget youtube({required String link}) {
  final videoId = YoutubePlayer.convertUrlToId(link);

  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId: videoId ?? '',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kgrey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 174, 174, 174),
            offset: Offset(0, 4),
            blurRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
        ),
      ),
    ),
  );
}

Widget reportbox(
  String title,
  String userid,
  String createdAt,
  // String firstName,
  // String lastName,
  VoidCallback onTap
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: kred,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Reported by $userid",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF555555),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Divider(),
                  const SizedBox(height: 2),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // Icon(
                            //   Icons.person
                            // ),
                            
                            // const SizedBox(width: 10),
                            
                            // Text(
                            //   "$firstName $lastName",
                            //   style: const TextStyle(
                            //     fontFamily: 'Poppins',
                            //     fontSize: 13,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F6F8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                formatDateTime(createdAt),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Color(0xFF666666),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),

                      RawMaterialButton(
                        onPressed: onTap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        fillColor: klightred,
                        child: Text(
                          'Take Action',
                          style: textmedium10.copyWith(
                            color: kwhite
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget reporttakenbox(
  String title,
  String userid,
  String createdAt,
  // String firstName,
  // String lastName,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: kred,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Reported by $userid",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      height: 1.4,
                      color: Color(0xFF555555),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Divider(),
                  const SizedBox(height: 2),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Icon(
                            //   Icons.person
                            // ),
                            
                            // const SizedBox(width: 10),
                            
                            // Text(
                            //   "$firstName $lastName",
                            //   style: const TextStyle(
                            //     fontFamily: 'Poppins',
                            //     fontSize: 13,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F6F8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                formatDateTime(createdAt),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Color(0xFF666666),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}