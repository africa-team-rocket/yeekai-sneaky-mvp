// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:yeebus/main_feature/presentation/welcome_screen/widgets/yeeguides_snap_list.dart';

// import '../../../../core/commons/theme/app_colors.dart';

// import '../../../../core/commons/utils/app_constants.dart';

// class ChooseYeeguideWidget extends StatefulWidget {
//   const ChooseYeeguideWidget(
//       {Key? key,
//       required this.onPop,
//       required this.onSelectedYeeguide,
//       required this.onChangedName})
//       : super(key: key);
//   final Function(int newIndex) onSelectedYeeguide;
//   final Function(String newName) onChangedName;
//   final Function onPop;

//   @override
//   State<ChooseYeeguideWidget> createState() => _ChooseYeeguideWidgetState();
// }

// class _ChooseYeeguideWidgetState extends State<ChooseYeeguideWidget> {
//   // ignore: unused_field
//   var page3Key = const PageStorageKey('key3');
//   var page4Key = const PageStorageKey('key4');
//   final TextEditingController _nameController = TextEditingController();

//   @override
//   void initState() {
//     // Si tu veux avoir la possibilité de revenir et toujours avoir la même valeur, juste initialise le ici lol

//     // _nameController.text = widget.
//     _nameController.addListener(() {
//       widget.onChangedName(_nameController.value.text);
//     });
//     // widget.pageController.addListener(() {
//     //   // setState(() {
//     //   // widget.pageController.
//     //   widget.currentPage.value = widget.pageController.page;
//     //   // debugPrint("Current page :" + widget.currentPage.toString());
//     //   // });
//     // });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // widget.pageController.dispose();
//     _nameController.dispose();

//     // Pour l'instant je ne les remet pas à une valeur initiale.
//     // Ce sera à toi de voir, si tu en as vraiment besoin utilisé un value notifier.
//     // widget.onChangedName("");
//     // widget.currentPage.value = 0.0;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 1.sw,
//       // color: Colors.green,
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 60,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 5.0, right: 20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         borderRadius: BorderRadius.circular(30),
//                         onTap: () {
//                           widget.onPop();
//                         },
//                         child: SizedBox(
//                           height: 50,
//                           width: 50,
//                           child: Center(
//                             child: Image.asset(
//                               "assets/icons/lit_back_icon.png",
//                               height: 22,
//                               width: 22,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Text(
//                         "Accueil",
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.primaryText,
//                         ),
//                         textAlign: TextAlign.start,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 //   child: SmoothPageIndicator(
//                 //     controller: widget.pageController,
//                 //     count: 2,
//                 //     effect: WormEffect(
//                 //       spacing: 4,
//                 //       dotColor: AppColors.secondaryText.withOpacity(0.2),
//                 //       activeDotColor: AppColors.primaryVar0,
//                 //       dotHeight: 4,
//                 //       dotWidth: 120,
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 130,
//             height: 1.sh * 0.8,
//             child: SizedBox(
//               height: 500,
//               width: AppConstants.screenWidth,
//               child: PageView(
//                 // physics: NeverScrollableScrollPhysics(),
//                 // physics: AlwaysScrollableScrollPhysics(),
//                 // physics: BouncingScrollPhysics(),
//                 // physics: _currentPage == 1.0 ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
//                 onPageChanged: (page) {
//                   switch (page) {
//                     case 0.0:
//                       // Gérez le cas où la page est égale à 0.0
//                       break;
//                     case 1.0:
//                       // Gérez le cas où la page est égale à 1.0
//                       //   if (state.phoneNumberError != "") {
//                       //     _controller.previousPage(
//                       //         duration: Duration(milliseconds: 400),
//                       //         curve: Curves.linear);
//                       //   }

//                       break;
//                     case 2.0:
//                       // if (state.senderError != "") {
//                       //   _controller.previousPage(
//                       //       duration: Duration(milliseconds: 400),
//                       //       curve: Curves.linear);
//                       // }else{
//                       //   // if(state.getCodeMessage != ResourceType.success){
//                       //   context.read<LoginBloc>().add(SendCode());
//                       //   // }
//                       // }
//                       // if (state.phoneNumberError != "" && state.loginMessage != null && state.loginMessage!.type == ResourceType.success) {
//                       //   // _controller.previousPage(
//                       //   //     duration: Duration(milliseconds: 400),
//                       //   //     curve: Curves.linear);
//                       // }else{
//                       //   if(state.loginMessage != ResourceType.success){
//                       //     context.read<LoginBloc>().add(LoginUser());
//                       //   }
//                       // }
//                       // Gérez le cas où la page est égale à 2.0
//                       break;
//                     case 3.0:
//                       // context.read<LoginBloc>().add(VerifyCode(newCode: state.verificationCode));
//                       // Gérez le cas où la page est égale à 3.0
//                       break;
//                     default:
//                       // Gérez d'autres cas si nécessaire
//                       break;
//                   }
//                   // if(page == 2.0){
//                   //   _controller.previousPage(duration: Duration(milliseconds: 400), curve: Curves.linear);
//                   // }else{
//                   //   // if(page == 1.0){
//                   //   //   setState((){
//                   //   //     _scrollOn();
//                   //   //   });
//                   //   // }
//                   // }
//                 },
//                 scrollDirection: Axis.horizontal,
//                 // controller: widget.pageController,
//                 children: [
//                   // SUGGESTION :
//                   // Trouve une meilleure façon de conserver le niveau de scroll
//                   // Gérer le back & forth entre la première page et ici n'est pas difficile
//                   // Je m'occuperai de ça en finalisant le business logic

//                   SingleChildScrollView(
//                     // key: page3Key,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Comment vous appelez-vous ?",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.primaryText,
//                                     ),
//                                     textAlign: TextAlign.start,
//                                   ),
//                                   const SizedBox(
//                                     height: 2,
//                                   ),
//                                   SizedBox(
//                                     width: 1.sw - 40,
//                                     child: Text(
//                                       "Ceci n'est pas une inscription, donnez le nom qui vous plaît, même un pseudo fera l'affaire !",
//                                       style: TextStyle(
//                                           color: AppColors.secondaryText,
//                                           fontSize: 1.sw * 0.0344),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       textAlign: TextAlign.start,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Container(
//                             height: 55,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 color:
//                                     // Colors.red),
//                                     AppColors.secondaryText.withOpacity(.2)),
//                             child: Center(
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: TextField(
//                                         controller: _nameController,
//                                         style: const TextStyle(
//                                             fontSize: 14, height: 1.5),
//                                         decoration: InputDecoration(
//                                           contentPadding: const EdgeInsets
//                                               .symmetric(
//                                               vertical: 0,
//                                               horizontal:
//                                                   10), // Ajustez la marge intérieure verticale ici
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color: "" != ""
//                                                   ? AppColors.bootstrapRed
//                                                   : AppColors.secondaryText
//                                                       .withOpacity(
//                                                           .5), // Couleur de la bordure inférieure lorsque la zone de texte est en focus
//                                               width: "" != "" ? 1 : 0.5,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                           ),
//                                           border: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color: "" != ""
//                                                   ? AppColors.bootstrapRed
//                                                   : AppColors.secondaryText
//                                                       .withOpacity(
//                                                           .5), // Couleur de la bordure inférieure lorsque la zone de texte est en focus
//                                               width: 0.5,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                           ), // Bordure par défaut
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color: "" != ""
//                                                   ? AppColors.bootstrapRed
//                                                   : Colors
//                                                       .transparent, // Couleur de la bordure inférieure lorsque la zone de texte est en focus
//                                               width: 1,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                           ),
//                                           // errorBorder: OutlineInputBorder(
//                                           //   borderSide: BorderSide(
//                                           //     color: Colors
//                                           //         .red, // Couleur de la bordure inférieure en cas d'erreur
//                                           //     width: 0.5,
//                                           //   ),
//                                           //   borderRadius:
//                                           //       BorderRadius.circular(15),
//                                           // ),
//                                           hintText: "Nom complet",
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         // onChanged: (value) {
//                                         //   context.read<RegisterBloc>().add(UpdateFullName(newFullName: value));
//                                         //
//                                         // },
//                                         onSubmitted: (value) {
//                                           // onSubmitValue!(value);
//                                         }),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           if ("" != "") ...[
//                             Text(
//                               "",
//                               style: TextStyle(
//                                   color: AppColors.bootstrapRed, fontSize: 12),
//                               textAlign: TextAlign.start,
//                             ),
//                           ]
//                         ],
//                       ),
//                     ),
//                   ),
//                   SingleChildScrollView(
//                     // key: page4Key,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             children: [
//                               const SizedBox(
//                                 height: 15,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Choisissez votre yeeguide",
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w500,
//                                           color: AppColors.primaryText,
//                                         ),
//                                         textAlign: TextAlign.start,
//                                       ),
//                                       const SizedBox(
//                                         height: 2,
//                                       ),
//                                       SizedBox(
//                                         width: 1.sw - 40,
//                                         child: Text(
//                                           "Ce sera votre assistant personnel, disponible 7j/7 pour répondre à vos question sur les transports.",
//                                           style: TextStyle(
//                                               color: AppColors.secondaryText,
//                                               fontSize: 1.sw * 0.0344),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                           textAlign: TextAlign.start,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 1.sh / 40,
//                         ),
//                         YeeguidesSnapList(
//                             onSelectedYeeguide: widget.onSelectedYeeguide),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
