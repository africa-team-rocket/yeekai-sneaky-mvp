'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "2efe42b830e0980e4a39eee0036ae52b",
"version.json": "bf322545638cb2e416de16eb2027e35b",
"index.html": "04c76ba03d09a578436b581f8dd42eca",
"/": "04c76ba03d09a578436b581f8dd42eca",
"main.dart.js": "dbfcd44044038b5a8a48e693affdd1f1",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "423b4c8bca7dd65ca8972eb7d234dacc",
"assets/AssetManifest.json": "3fdac385e0a9a5d8455c253613facc63",
"assets/NOTICES": "6216f1642eb60ca327d02421398c7077",
"assets/FontManifest.json": "b48df8ce263188b5adb999ba3de61110",
"assets/AssetManifest.bin.json": "4b45b92d62c22926e2de36d14c694a7b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "d67f40902109211b6f7e8f2664d204b3",
"assets/fonts/Poppins-ExtraLight.ttf": "6f8391bbdaeaa540388796c858dfd8ca",
"assets/fonts/Poppins-ThinItalic.ttf": "01555d25092b213d2ea3a982123722c9",
"assets/fonts/Poppins-ExtraLightItalic.ttf": "a9bed017984a258097841902b696a7a6",
"assets/fonts/Poppins-BoldItalic.ttf": "19406f767addf00d2ea82cdc9ab104ce",
"assets/fonts/Poppins-Light.ttf": "fcc40ae9a542d001971e53eaed948410",
"assets/fonts/Poppins-Medium.ttf": "bf59c687bc6d3a70204d3944082c5cc0",
"assets/fonts/Poppins-SemiBoldItalic.ttf": "9841f3d906521f7479a5ba70612aa8c8",
"assets/fonts/Poppins-ExtraBoldItalic.ttf": "8afe4dc13b83b66fec0ea671419954cc",
"assets/fonts/Poppins-ExtraBold.ttf": "d45bdbc2d4a98c1ecb17821a1dbbd3a4",
"assets/fonts/Poppins-BlackItalic.ttf": "e9c5c588e39d0765d30bcd6594734102",
"assets/fonts/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/fonts/Poppins-LightItalic.ttf": "0613c488cf7911af70db821bdd05dfc4",
"assets/fonts/MaterialIcons-Regular.otf": "3a3b16a9439909d6a437253ca057051d",
"assets/fonts/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/fonts/Poppins-Black.ttf": "14d00dab1f6802e787183ecab5cce85e",
"assets/fonts/Poppins-Thin.ttf": "9ec263601ee3fcd71763941207c9ad0d",
"assets/fonts/Poppins-SemiBold.ttf": "6f1520d107205975713ba09df778f93f",
"assets/fonts/Poppins-Italic.ttf": "c1034239929f4651cc17d09ed3a28c69",
"assets/fonts/Poppins-MediumItalic.ttf": "cf5ba39d9ac24652e25df8c291121506",
"assets/assets/launcher/icon_bg.png": "439cf5c097c153e58178b6718df8d0c5",
"assets/assets/launcher/icon.png": "4e857b65726c440dee756bba783ffa6b",
"assets/assets/launcher/icon.svg": "e7a86ed7a386fb47303d6bf03cdeb64f",
"assets/assets/launcher/icon_round.png": "407bd36447d55a9de189034a23c14cb7",
"assets/assets/launcher/icon_foreground.png": "9323ed88c139cfd11f78216b6138cde6",
"assets/assets/mapstyles/light_mode.json": "4f3cda29146f89a11686e4e576b9e932",
"assets/assets/bg_test.png": "ee2e6ae73df8939231bdaeaddf1eba67",
"assets/assets/images/statut_amicale.png": "225d77c4b56a3df572399445a0d6ae40",
"assets/assets/images/yeebus_logo_blue.png": "4315aab70a25d399fcea42e7e5819acd",
"assets/assets/images/statut_brt.jpg": "502387d4a639e52936ea47c24288bab3",
"assets/assets/images/illustration_1.png": "99ddaa96e6e2b0af2ad4e9c0ee6a5136",
"assets/assets/images/logo_cetud.png": "e918313a7f1a48d38601b16864697a8a",
"assets/assets/images/sms.png": "5c358c18f2f51d7947141adef1f42ac7",
"assets/assets/images/esmt_1.png": "ab7dae85f947c71301cd6b89ab45e35b",
"assets/assets/images/logo_market.png": "39f20212545e9a661ab73f8fd1dcf11b",
"assets/assets/images/esmt_2.png": "e81482660482ffb6303a075d37049a18",
"assets/assets/images/half_crowded_bus.png": "dd658b509f682b2649dcebee3f36b354",
"assets/assets/images/esmt_3.png": "b9a713f48af8fa056c4f7335970c1828",
"assets/assets/images/statut_mpssi-1.png": "fdf1cb220bb07c2bcf4966c99ca3b70f",
"assets/assets/images/statut_cetud.jpg": "25c23f7507fb4102463078ab9ee1955e",
"assets/assets/images/logo_ddd.png": "f9db7897a5abbdd5c53ae01cf92be7b9",
"assets/assets/images/statut_ter.jpg": "db690ab8bbf05706f24137ad1c24aed0",
"assets/assets/images/salle_de_classe_esmt.jpg": "9d5ae062f78751bd3a5a806f920e485d",
"assets/assets/images/ddd_1.png": "c567d6bbb5683c3828687f834b611e59",
"assets/assets/images/messages_bg.png": "1ee7c3e3752cbc5e29ec1442157925b1",
"assets/assets/images/thierry_kondengar.png": "2d0c6a7ca3f8d1a4b4109d4476d35abc",
"assets/assets/images/statut_aftu.jpg": "0e033ac6d8e3d03b3dada7dd4d551e90",
"assets/assets/images/ousmane_sarr.png": "14818b8f467ea99fc2ff894a9c9c717e",
"assets/assets/images/filled_heart.png": "c9aa9d4c550b45f5c37c4b91c32fbfc1",
"assets/assets/images/profile_pic_placeholder.png": "cb79b346275a47bd6043b894bd0efc47",
"assets/assets/images/not_found_1.png": "207e527a6e1601549a11fcabce09feaf",
"assets/assets/images/crowded_bus.png": "4bf96dd3053de4541f37a6b6dbb08b87",
"assets/assets/images/not_found.svg": "5bcc8b7196396bc11b503767b6c3733a",
"assets/assets/images/logo_aftu.png": "f2298520ab1ea19ee824e7cb0f34a094",
"assets/assets/images/logo_opportunities.png": "3c278a69f3905bf3402a934175c6b4f8",
"assets/assets/images/school_toilets.jpg": "c252b9789b96420dc1fa5a43044edcd4",
"assets/assets/images/logo_brt.png": "f498e90166b40ee603edd5936b7d7f6f",
"assets/assets/images/fatiha.jpg": "4525586d87ab509553302a60f043e328",
"assets/assets/images/senegal_flag.png": "5aac2c6b5847cd04fab490d048eadfbd",
"assets/assets/images/unknown_bus.png": "8ad97132c2e021aa3298bb968d61ea48",
"assets/assets/images/arr%25C3%25AAt_3.png": "c8a6a81958f5b43a5c6166e11a300889",
"assets/assets/images/statut_lpti1.png": "3dd99bd02a34a4cdb4f953c39e4a5cab",
"assets/assets/images/statut_yeebus.jpg": "a8d80a5491c8b1a30881b81ab70e7d70",
"assets/assets/images/arr%25C3%25AAt_2.png": "6a080f43789a77a3f8cb591fedc2640f",
"assets/assets/images/labo_1.jpeg": "363d34e3ae870a8dd02b32b6faaf104c",
"assets/assets/images/statut_administration.png": "81ccebcaa5fe5f036e6e9c5428ad3395",
"assets/assets/images/adji_sonko.png": "7b1a31abf72141e20887f32905d34447",
"assets/assets/images/whatsapp.png": "1227f7edc0704ff99f73e0425d85ab5d",
"assets/assets/images/arr%25C3%25AAt_1.png": "08e60815860bee9cdb4439232e962085",
"assets/assets/images/annonce_marketplace.jpg": "cdfa4eef1ba0b0ba5c26670d3a4fae89",
"assets/assets/images/statut_ddd.jpg": "6360746366e34968b631728efe8b28d5",
"assets/assets/images/empty_bus.png": "fa69d56887e6573fd76214cd57a6e2c1",
"assets/assets/images/bureau_esmt.jpg": "eb19deb75ab1db9a93ba8b2bd19b7da6",
"assets/assets/images/place_placeholder.png": "db911bca1702105b5ec854aa9d48f724",
"assets/assets/images/logo_infos.png": "17afca3c9e4516f7b5ff8ee02eabf6a4",
"assets/assets/images/opportunities.png": "b97dc1316e5ff72fbba9ef0693d89476",
"assets/assets/images/map_mockup.png": "676bf51a0d6f5adb23a5e7f1dc0be1e4",
"assets/assets/images/statut_ingc3.png": "b3a06ca05effb30334e7eed0e75a026d",
"assets/assets/map_icons/yeebus_derriere.png": "44e84b1c26d68c726aa5b5af63097ad9",
"assets/assets/map_icons/sortie_batiment.png": "c6cb5eedb557a71b0edf5faa43dad4b4",
"assets/assets/map_icons/salle_reprographie.png": "f7d960790d80b77fe490aacd58f2f77f",
"assets/assets/map_icons/salle_restaurant.png": "1fa4a961cc8aba56e8162e3f0e1a3895",
"assets/assets/map_icons/salle_ha1.png": "856477ae8055f9d8a0360bedd1c21399",
"assets/assets/map_icons/salle_ha3.png": "212cf4aae6e52de223157ee6929faf5d",
"assets/assets/map_icons/salle_conference.png": "230d09b7ceb49b5120612071617510a2",
"assets/assets/map_icons/toilettes_femme.png": "400893a2394f80781840230f5fef23ed",
"assets/assets/map_icons/salle_ha6.png": "10e100f7e4b21110d285c929124fe634",
"assets/assets/map_icons/point_priere.png": "7077d43347f61db078acb22aec110abb",
"assets/assets/map_icons/salle_hb8.png": "09853e6ae87639a6c70d0e44813f8e36",
"assets/assets/map_icons/salle_ha4.png": "01bf75fe6c2169933345b7647ee2f6bb",
"assets/assets/map_icons/salle_ha5.png": "b7f91aecbbefeb3797718e9fe3965a33",
"assets/assets/map_icons/salle_ha%253F.png": "8b212399b7da957768d6af77795a49f8",
"assets/assets/map_icons/ne_venez_pas_ici.png": "2eed8243972d2ece72458f2049979520",
"assets/assets/map_icons/salle_mp_ssi2.png": "704014e9957510161159485c8d8124ec",
"assets/assets/map_icons/salle_mystere.png": "90ccecd9db64e18c6f667050ba33a1ee",
"assets/assets/map_icons/salle_hb7.png": "5d7dc9a8ac2e9428752d2186b297863e",
"assets/assets/map_icons/salle_hb6.png": "731a440c20f149c5c42d630541f4412a",
"assets/assets/map_icons/salle_cyber_hb8.png": "b282b81e6cfe1ffd0180cc4b5244ce3c",
"assets/assets/map_icons/salle_gymnase.png": "23ae07548238fb7ec831df91e568cd7a",
"assets/assets/map_icons/salle_dar.png": "07f3e0a88c6e946fee6416a7769bf057",
"assets/assets/map_icons/salle_hb2.png": "aee3b2c9506f31db3fb17a8d89c7669a",
"assets/assets/map_icons/salle_hb3.png": "ebb8e093d7908e90bd7934987a470da3",
"assets/assets/map_icons/bat_e.png": "d2622f57d39cceed613b3e0d955f6b9b",
"assets/assets/map_icons/salle_mp_isi2.png": "73756f6f17949d425a6c5631f55aaf3f",
"assets/assets/map_icons/salle_biblio.png": "b849a69f18b0368d5f225e2f1ced0773",
"assets/assets/map_icons/toilettes_homme.png": "db9924d3f0985521b56f450419ad8135",
"assets/assets/map_icons/salle_mystere_2.png": "eb17ad292198526c71eb3fadfa234d79",
"assets/assets/map_icons/exit.png": "f5a0bad4af89b7f8db630ff74a7ca406",
"assets/assets/map_icons/salle_amicale.png": "bfe73578e24c8a7921c8c65440929c7c",
"assets/assets/map_icons/image_front.png": "fcbd2f3397b856c9f80fc9be4662a9e4",
"assets/assets/map_icons/salle_infirmerie.png": "2daa06c99dddfaaaf7f475fb0d5acde3",
"assets/assets/map_icons/toilette_mixte_locked.png": "d26ddce59dc5a94999ae028b6b1ae466",
"assets/assets/map_icons/toilette_mixte.png": "90ba0d7fa6e393d05001baac9fcb3f60",
"assets/assets/map_icons/labo.png": "f41b2beed34b809bc647688894a48b05",
"assets/assets/map_icons/salle_incubateur.png": "de03b3515a4f849546b86a63bb1bb597",
"assets/assets/map_icons/yeebus_devant.svg": "43310765bf9aa763b914531b8e8e5bac",
"assets/assets/map_icons/salle_ha_.png": "1f30cd3a4b05fa538b4b6996f2a635d6",
"assets/assets/example.gif": "1ff0f61f37783fcd4a6c1bbdcaecd780",
"assets/assets/icons/cart_fav_blue.png": "6090e174428c06511930f0d8a2d70515",
"assets/assets/icons/pin_point.png": "5ebdc0620e8c5e8a42c244de4dc7ebc7",
"assets/assets/icons/gear.png": "0584280cebab7b9c165e3b5acde77c7a",
"assets/assets/icons/plus_white.png": "5916f43683b8f7f94a93df4709bb144c",
"assets/assets/icons/dumbell_fav_disabled.png": "d7097b4807bebf1c6b592a6b66a5e779",
"assets/assets/icons/single_bus_unknown.png": "b68519b18e2ed15ebc14c053c5164be6",
"assets/assets/icons/single_bus_green.png": "348db5e1150c0eba6fd32875b9d2483f",
"assets/assets/icons/saved_navbar.png": "e41f235ee597b0c8de1dc9eaf1ca3a24",
"assets/assets/icons/Group%2520101.png": "e2a80380dd4d9650acda4c6e652b4145",
"assets/assets/icons/contribute_navbar.png": "9bbea83dd3a945c397a9a05543198940",
"assets/assets/icons/right_arrow_grey.png": "c3e3d6f727080a84bc76ff59319bd2c1",
"assets/assets/icons/exit_marker.png": "b9444ae72cabb09d2c1394d0deedcdd7",
"assets/assets/icons/work_fav_white.png": "b76e47a24194a614e123f61629d43773",
"assets/assets/icons/direction.png": "66bba6956a2ffc7411a5be6133802fe5",
"assets/assets/icons/bus_search.png": "ca6e1468339ef920d01e6489b387041a",
"assets/assets/icons/mic_circle.png": "a3aa81852c73d72f8f1ccbf2732e99cb",
"assets/assets/icons/conference_marker.png": "2aa46be84cfbd76fc5a800719dca9188",
"assets/assets/icons/share_blue.png": "02c3e010f02b38cada6e41e780e181c4",
"assets/assets/icons/user_position_big.png": "9c92056e6d6d38c6b510eba5e240b779",
"assets/assets/icons/search_lit_icon.png": "6b20e2dceaa747044ecb459ed7d6b85a",
"assets/assets/icons/yeemap.png": "0d00648c014e785c348c80a9fe6ac1df",
"assets/assets/icons/trans_ddd.png": "7fac0e17038d3ba768a3e93b51244a46",
"assets/assets/icons/trash_outlined.png": "0f7a4c5df92611ed30434b9a4c73c82a",
"assets/assets/icons/cart_fav_white.png": "6b58df7b4666f45f1c5412da387e2f77",
"assets/assets/icons/more_fav_white.png": "2691ee9613ca64d9badc9130c4ac8094",
"assets/assets/icons/stop_yellow.png": "15e955c8cb5f5e5ea125107f5fa4c1ed",
"assets/assets/icons/valid_check.png": "f27cb3475381e558063e5e1e789d4564",
"assets/assets/icons/retry.png": "85bc9c4ff8fa3808eb6346664b705036",
"assets/assets/icons/back_left_icon_blue.png": "e5b2407d4a7ac96f276c4f8cf4fe0ca2",
"assets/assets/icons/filter_outlined_maroon.png": "a7ce58039b18ea72cb42fc2271cefba9",
"assets/assets/icons/user_walk_big.png": "4d3c647e837b257dfde781fc47fde263",
"assets/assets/icons/bus_grey.png": "de4571ac56ae4f5d74276306b8f0f189",
"assets/assets/icons/stop_search.png": "cbfa3001002d6554f2d347ae50d8696c",
"assets/assets/icons/clock_white.png": "54e7d33e67442656655e619314f75506",
"assets/assets/icons/resto_marker.png": "2eab52320bbf8fa294670f556e6e71a5",
"assets/assets/icons/Group%252032972.png": "946fa9e4840133fedc03a36394fd3880",
"assets/assets/icons/cart_fav_disabled.png": "ab0544d0d52b598beacc90c11aff30e4",
"assets/assets/icons/map_level.png": "e4e44efac54c28d02e1a0f7c09afe961",
"assets/assets/icons/half_crowded_bus.png": "a7446a0f6dd373696bebd75389521569",
"assets/assets/icons/bat_marker.png": "fec9fae0b2a766f3dce3566a408a7d68",
"assets/assets/icons/map_settings_white.png": "2291ad6b435fee6decbb13d138dee7d2",
"assets/assets/icons/history_search.png": "145d9c4b9af48487addee183557aa353",
"assets/assets/icons/locate_me.png": "70ac9c9de92a086be5f53e3187c749f0",
"assets/assets/icons/bibliotheque_marker.png": "d60aac612457a66abaf75edf820d605f",
"assets/assets/icons/mixed_marker.png": "d41719a21bc1be45d2dc590dbafec814",
"assets/assets/icons/categories_blue.png": "1b96f15810b72015bfed5661d8f0b14e",
"assets/assets/icons/close_circle_black.png": "ee24c158e77178bc14c34d5cc8a8434c",
"assets/assets/icons/stop_half_crowded.png": "a972a59c629e7269128ead7fa91712fc",
"assets/assets/icons/trash_outlined_maroon.png": "e94a9fe50739cd90395645f2dd1a3304",
"assets/assets/icons/seat_blue.png": "63c50b96fe2c53457a15fa014d878b47",
"assets/assets/icons/map_white.png": "3a7318845b703a320aa7102f855c550c",
"assets/assets/icons/map.png": "bba61f33c722914dceb6bc267eabf23d",
"assets/assets/icons/floating_map.png": "ac3076d4d5405f47d6bab1a30b13dbb9",
"assets/assets/icons/recycle-bin-2--remove-delete-empty-bin-trash-garbage.png": "1816606a8d7cce8b250b47fb48728a1d",
"assets/assets/icons/fav_collection/fav_more.svg": "a2cf614f4a9d36406048093cb5e90366",
"assets/assets/icons/fav_collection/fav_star.svg": "acb1b2a6e1ea926a1c5395058d736210",
"assets/assets/icons/fav_collection/fav_curch.svg": "aa4a3d6681a8cb58c54d89dbc8934754",
"assets/assets/icons/fav_collection/fav_basketball.svg": "2c0dd1ded6d6b17427b7dcf93f53d3f7",
"assets/assets/icons/fav_collection/fav_sofa.svg": "74c1f58620120f86dd0f6fe384a7e577",
"assets/assets/icons/fav_collection/fav_music.svg": "6ca08c1da91bf913b4f52ea50a727493",
"assets/assets/icons/fav_collection/fav_swords.svg": "8f7e4ed4264852fd721d08230649febb",
"assets/assets/icons/fav_collection/fav_shop.svg": "d9ae9e65ab690c4b3badcb9e964cb381",
"assets/assets/icons/fav_collection/fav_home.svg": "1c2065117f174e92250e173ef90e5fc0",
"assets/assets/icons/fav_collection/fav_cup.svg": "edc36738230a2da48ea2aa96f771aee0",
"assets/assets/icons/fav_collection/fav_heart.svg": "7a18d098717f018ef503c632b8e9ec25",
"assets/assets/icons/fav_collection/fav_dumbell.svg": "71c7d55222ffbcbfcba62a6fd9290d44",
"assets/assets/icons/fav_collection/fav_mosquee.svg": "2dc1d8ad97b87543798c86e8a78292d8",
"assets/assets/icons/fav_collection/fav_kingdom.svg": "b513dc923a2c31bcb70d2f0795c7a9cb",
"assets/assets/icons/fav_collection/fav_pet.svg": "6ce6de13ece4e47255baa863b2d283d8",
"assets/assets/icons/fav_collection/fav_burger.svg": "519fe30f6ce8a3a003aa474c80ad8822",
"assets/assets/icons/fav_collection/fav_work.svg": "9b2bbf39ff26178bedfff7d2ae55010a",
"assets/assets/icons/fav_collection/fav_football.svg": "fd85c088bc417e1bb9b0edd4a533002b",
"assets/assets/icons/fav_collection/fav_flag.svg": "cdd8e208fd61945a05652c046ca2ba8a",
"assets/assets/icons/notfound_search.png": "0d41ab64885253013512460365ee4f9a",
"assets/assets/icons/accessibility_blue.png": "10ac4dbd7ed3a717af3053a3e37eac35",
"assets/assets/icons/recycle-bin-2--remove-delete-empty-bin-trash-garbage-1.png": "cf15cb8dbded34ee23d0fa0faecfda82",
"assets/assets/icons/scroll_down_blue.png": "c60f49873c570eee6ef9184b45691402",
"assets/assets/icons/work_fav_blue.png": "b78a4db0f1be80af7af6e8253d88da5e",
"assets/assets/icons/profile_navbar_selected.png": "cc3ad4e88525fe14995eed6946ebe98a",
"assets/assets/icons/contribute_navbar_selected.png": "c566d78cc4a9ae33c8ebc7016faa77c3",
"assets/assets/icons/trafic_state_yellow.png": "eebd2d14cad3230f80d262019011c2b0",
"assets/assets/icons/lit_back_icon.png": "4b1c3bb99b815af54368e847367508c6",
"assets/assets/icons/stop_crowded.png": "383fd6dc88977f91b1c732b38d5b73ff",
"assets/assets/icons/trafic_state_red%25201.png": "3cf9e3acb6f7a12657332a11d4c0c462",
"assets/assets/icons/road_blue.png": "a251eb2f7695f7a2a2be8a5dc78bd8a2",
"assets/assets/icons/single_bus_red.png": "394774db63f24f83b3fba1b9560e3137",
"assets/assets/icons/translate.png": "bee13243e28999520e2d3cdb1ac42c44",
"assets/assets/icons/trafic_state_green.png": "d9eaa6dc819a7a23b1dddaee238cdeb2",
"assets/assets/icons/print_marker.png": "9df8f144876ad842be2f5766f3ceb69e",
"assets/assets/icons/home_fav_blue.png": "0f1c92480f4973006ec2d881d73b1b2f",
"assets/assets/icons/heart_red.png": "bb1252daa0044cdeeb99da20e56b1cb9",
"assets/assets/icons/yeemap2.png": "954e81822d1705c246f499c304d06480",
"assets/assets/icons/filled_heart.png": "aade85e0ea8191826d72366ce8df6cda",
"assets/assets/icons/bus_onward.png": "cbf0d19abad9c80c279f6fbf7b26afef",
"assets/assets/icons/arrow_left_up_black.png": "2f7c4c503c813692ba5324e9e40cfd1c",
"assets/assets/icons/saved_navbar_selected.png": "ede94945f6184f206cae0adf35a9bdb6",
"assets/assets/icons/more_vertical.png": "5452d51b851b7c48911083a2288db627",
"assets/assets/icons/subs.png": "dd55f4e4b9d3a806a6a4c25e3226ada4",
"assets/assets/icons/single_bus_yellow.png": "f92587d56e43b8a14fd670849938604e",
"assets/assets/icons/search.png": "bdb3445448b6309247385d48debb8bd7",
"assets/assets/icons/cross_circle.png": "ce9c1932be88171ee6dd8a72965901f2",
"assets/assets/icons/trash_red.png": "b73aa55a07118ddb0b3bd5974d0b9ec7",
"assets/assets/icons/crowded_bus.png": "9868960adb93e7c8f81738e7b1d14a91",
"assets/assets/icons/accessibility.png": "f523dc25f05c07658575ec30b3af65c1",
"assets/assets/icons/yeebus_flat_logo.png": "badcfa79c8cf56ed6eed736e0575d53e",
"assets/assets/icons/history.png": "1a550aae1f4f5e335d3c849fd36f2b57",
"assets/assets/icons/bus_stop.png": "2b75ed0855b36747a1011d05afd15044",
"assets/assets/icons/mic_bold.png": "f31adeab0443251fbbb4695ad2f61758",
"assets/assets/icons/infirmerie_marker.png": "506cd0e8646a37557cbbfb363452cff8",
"assets/assets/icons/incubateur_marker.png": "9c975ce64534d6ebf3354ddb633fdc7e",
"assets/assets/icons/menu.png": "755c4ff323664510adbde84d98eae779",
"assets/assets/icons/more_lit_icon.png": "982a14aab33f5004133de8ce0c92c876",
"assets/assets/icons/bus_backward.png": "84ad420d8bfe9b7f62cd60e2eeb40ca1",
"assets/assets/icons/labo_marker.png": "077d9e9c848f507fa45e798fb877afc6",
"assets/assets/icons/help.png": "25d0fab52f42fa6baaa45e8f909829a6",
"assets/assets/icons/trans_tata.png": "7f064a8ad9ae32010b489d0bae297b2b",
"assets/assets/icons/time_blue.png": "1ffb2ed3679e9a31251b29d4664af752",
"assets/assets/icons/location_search.png": "77339aa786183bf068a4c34fc9de9580",
"assets/assets/icons/trafic_state_red.png": "33b6a48d01031875f3a5e50331fb9e8b",
"assets/assets/icons/user_position_small.png": "08aa402ef88ac7fb6aeb44a35e10077c",
"assets/assets/icons/bus_stop_big.png": "73f1136a6c83bd247e1b3bc6252390da",
"assets/assets/icons/profile.png": "bce217daca2144724a33e7e8d64a026c",
"assets/assets/icons/fcfa_blue.png": "46b69265d9b750053ad8388c291b4c13",
"assets/assets/icons/filter_outlined.png": "0124851c7ab3bd9043beeda3301b4512",
"assets/assets/icons/star_rating_blue.png": "3502e0c238e39c1f322948815cea01af",
"assets/assets/icons/floating_map_maroon.png": "3957246bbaef1cb4a2a544b6dd17c7df",
"assets/assets/icons/delete.png": "525e3c4a2fb07a7ca07a8c20a690755d",
"assets/assets/icons/audio.png": "11a68c72df35eaaf08c5db3fc7fe43d6",
"assets/assets/icons/unknown_bus.png": "8ad97132c2e021aa3298bb968d61ea48",
"assets/assets/icons/back_left_icon_black.png": "8ddad54e79d338c4936620b0416d32d1",
"assets/assets/icons/arrow_key.png": "fe446708ac31de1b326681721cd16212",
"assets/assets/icons/time_maroon.png": "e442fe82d99cfd68cc5f6975734e7771",
"assets/assets/icons/home_navbar.png": "27db1b74b7bc72c14bb817d6646a7b69",
"assets/assets/icons/bus_green.png": "97b1d2c4ad52143f8b5290b86476ab6b",
"assets/assets/icons/bus_stop_small.png": "e9180a33956168b0268acf90bb99d72f",
"assets/assets/icons/stop_empty.png": "7ba4393ff289fe79f52dbcae8f8a91f9",
"assets/assets/icons/edit.png": "6c487b06d75e0b16af5ca5ef6c326bc2",
"assets/assets/icons/pray_marker.png": "1eb94b37dc84fbb90cce7f9d42e86a3f",
"assets/assets/icons/more.png": "8b06438acc12e9666b4c68e299d0c22c",
"assets/assets/icons/user_map_position.png": "20d236d56b726b04afc2314df04e4e72",
"assets/assets/icons/yeechat_navbar.png": "feaa1312ec3de029f2e432ab06b95288",
"assets/assets/icons/home_fav_white.png": "32fbf3c1f02ae57fbfa06cc96e2893f7",
"assets/assets/icons/warning_yellow.png": "2b504843045f539ac7c52c7d121b8efa",
"assets/assets/icons/yeechat_navbar_selected.png": "198a5e1c82d3047d94f01764e9fdf294",
"assets/assets/icons/voice.png": "e81cb154bff9080b323d494bbeb2cf81",
"assets/assets/icons/home_navbar_selected.png": "51940abd0bd41b4b7db1e483fb36b1a9",
"assets/assets/icons/camera.png": "aaafafcf89ee08f71147432db5531586",
"assets/assets/icons/empty_bus.png": "81f27d7bb3edcc30f5284106c5e3cac5",
"assets/assets/icons/shortcut_blue.png": "78df2ee51df47dfb26919139400a101b",
"assets/assets/icons/trans_carapide.png": "b05af62f0b732436bf35c9abf1a209a6",
"assets/assets/icons/message.png": "69c8f72c2f26df007c3b5cbcd0452339",
"assets/assets/icons/opportunities.png": "34986e9bfa20ac1bf3972b006405a705",
"assets/assets/icons/profile_navbar.png": "6fa27d7b3a71212a878edaa117fb6375",
"assets/assets/icons/male_marker.png": "79dd9d1adad0d1d6316b25ef67b65cca",
"assets/assets/icons/female_marker.png": "cbe9a93f3ea2a1273d74b7047cdced2e",
"assets/assets/icons/clock_dark.png": "600c8985450d95b274da070ab95506e7",
"assets/assets/icons/call_lit_icon.png": "e580e1db408c119ba12041d7f248a83e",
"assets/assets/icons/comment_rating_blue.png": "a96a167f366b94c133d49338911af8df",
"assets/assets/icons/amicale_marker.png": "c6b2b66bf7d82fc4c922c38f1ea67de5",
"assets/assets/yeeguides/issa_guide.png": "55cdb3b3853ca28942b1a7991a36864c",
"assets/assets/yeeguides/issa_guide_square.png": "f8d09b0cdb854c7e128f68d3223261eb",
"assets/assets/yeeguides/rita_guide_square.png": "3b3c3b5a10da60543a2a3e716c72f3fa",
"assets/assets/yeeguides/domsa_guide.png": "55c483633057f15650d6234dbab8b28a",
"assets/assets/yeeguides/songo_guide.png": "03d9a6c62153df9cee68b40708792f16",
"assets/assets/yeeguides/vaidewish_guide_square.png": "be24b2f86d3195ebfa49fad1b0af1799",
"assets/assets/yeeguides/vaidewish_guide.png": "48854c7e2c0010d947c442c4ad19e685",
"assets/assets/yeeguides/domsa_guide_square.png": "933f1944b9ff4b501dbbd4a62c458e17",
"assets/assets/yeeguides/madio_guide.png": "6b489bb2bcd48fefbb335f1b4d564d23",
"assets/assets/yeeguides/songo_guide_square.png": "420b2592e625b615dda48749a899ecc5",
"assets/assets/yeeguides/rita_guide.png": "efd16657a8c4009f0382a791947b693d",
"assets/assets/yeeguides/raruto_guide.png": "f11f3dadf1beeb48b0899bcb52684dc9",
"assets/assets/yeeguides/madio_guide_square.png": "4f727cfd3a58e553e4d373a4f1cd83f4",
"assets/assets/yeeguides/raruto_guide_square.png": "c94f4f3bb3945b7f6327617ea9d3a7d9",
"assets/assets/animations/yeelogo.json": "5b2e823bf7fd39361db24489e6816469",
"assets/assets/animations/swipe_left.json": "6727bcd32b3c375e9ba7239d5cd20c46",
"assets/assets/animations/yeelogo.gif": "a7eed370afe44fd5de0ef715844fbeee",
"assets/assets/animations/typing.json": "ce8f5082a662ef0b3b91030d00041b9b",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
