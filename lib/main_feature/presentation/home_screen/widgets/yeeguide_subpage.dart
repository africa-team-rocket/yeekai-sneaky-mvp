import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/domain/models/chatbot_conversation.dart';
import '../../../domain/model/yeeguide.dart';
import 'intro_message.dart';

class YeeguideSubPage extends StatefulWidget {
  const YeeguideSubPage({Key? key, required this.introChatResponse})
      : super(key: key);

  final ChatResponse introChatResponse;

  @override
  State<YeeguideSubPage> createState() => _YeeguideSubPageState();
}

class _YeeguideSubPageState extends State<YeeguideSubPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // color: Colors.red,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 1.sw,
            // color: Colors.red,
            padding: const EdgeInsets.only(left: 15.0, right: 18.0),
            // color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    height: 59,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Hero(
                          tag: locator
                                  .get<SharedPreferences>()
                                  .getString("yeeguide_id") ??
                              "raruto",
                          child: Image.asset(
                            Yeeguide.getById(locator
                                        .get<SharedPreferences>()
                                        .getString("yeeguide_id") ??
                                    "raruto")
                                .profilePictureAsset,
                            height: 43,
                            width: 43,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // if(chatMessagesSections.isNotEmpty)...[
                IntroMessageSection(
                  key: const PageStorageKey("ezz"),
                  // chatMessages: conservation1
                  //     .steps.first.response.text,
                  username: "Al Amine",
                  chatResponse: widget.introChatResponse,
                  animationLevel: 1,
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 110,
          // ),
          // Image.asset(
          //   "assets/bg_test.png",
          //   height: 1.sh,
          //   width: 1.sw,
          // ),
        ],
      ),
    );
  }
}
