import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/edge_to_edge.dart';
import '../viewmodel/profile_view_model.dart';
import '../widgets/home_shimmer.dart';

class ProfileScreen extends StatefulWidget {

  final VoidCallback onLogout;

  const ProfileScreen({

    super.key,

    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  @override
  void initState() {

    super.initState();

    /// =========================
    /// DYNAMIC USER ID
    /// =========================
    int userId = 1;

    Future.microtask(() {

      context
          .read<ProfileViewModel>()
          .getUserProfile(
        userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ProfileViewModel>(

      builder: (_, vm, child) {

        /// =========================
        /// SHIMMER LOADER
        /// =========================
        if (vm.isLoading) {

          return const HomeShimmer();
        }

        /// =========================
        /// ERROR STATE
        /// =========================
        if (vm.errorMessage.isNotEmpty) {

          return Center(

            child: Text(

              vm.errorMessage,

              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          );
        }

        /// =========================
        /// NULL CHECK
        /// =========================
        if (vm.user == null) {

          return const SizedBox();
        }

        final user = vm.user!;

        return EdgeToEdgeBody(

          bottom: false,

          child: SingleChildScrollView(

            child: Column(

              children: [

                /// =========================================
                /// TOP PROFILE HEADER
                /// =========================================
                Stack(

                  clipBehavior: Clip.none,

                  children: [

                    /// =====================================
                    /// BLUE GRADIENT BACKGROUND
                    /// =====================================
                    Container(

                      height: 320,

                      width: double.infinity,

                      decoration:
                      const BoxDecoration(

                        gradient:
                        LinearGradient(

                          colors: [

                            Color(0xff1565C0),

                            Color(0xff42A5F5),
                          ],

                          begin:
                          Alignment.topLeft,

                          end:
                          Alignment.bottomRight,
                        ),

                        borderRadius:
                        BorderRadius.only(

                          bottomLeft:
                          Radius.circular(
                            35,
                          ),

                          bottomRight:
                          Radius.circular(
                            35,
                          ),
                        ),
                      ),

                      child: Padding(

                        padding:
                        const EdgeInsets.only(
                          top: 60,
                          left: 20,
                          right: 20,
                        ),

                        child: Column(

                          children: [

                            /// =========================
                            /// TITLE + ICON
                            /// =========================
                            Row(

                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                              children: [

                                const Text(

                                  "My Profile",

                                  style: TextStyle(

                                    color:
                                    Colors.white,

                                    fontSize: 30,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                Container(

                                  padding:
                                  const EdgeInsets
                                      .all(10),

                                  decoration:
                                  BoxDecoration(

                                    color: Colors
                                        .white
                                        .withOpacity(
                                      0.2,
                                    ),

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      14,
                                    ),
                                  ),

                                  child: const Icon(

                                    Icons.person,

                                    color:
                                    Colors.white,

                                    size: 28,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                height: 30),

                            /// ===================================
                            /// ATTRACTIVE PROFILE IMAGE
                            /// ===================================
                            Center(

                              child: Stack(

                                alignment:
                                Alignment
                                    .bottomRight,

                                children: [

                                  /// GLOW EFFECT
                                  Container(

                                    padding:
                                    const EdgeInsets
                                        .all(5),

                                    decoration:
                                    BoxDecoration(

                                      shape:
                                      BoxShape
                                          .circle,

                                      gradient:
                                      const LinearGradient(

                                        colors: [

                                          Color(
                                              0xff42A5F5),

                                          Color(
                                              0xff1565C0),
                                        ],
                                      ),

                                      boxShadow: [

                                        BoxShadow(

                                          color: Colors
                                              .blue
                                              .withOpacity(
                                            0.45,
                                          ),

                                          blurRadius:
                                          18,

                                          spreadRadius:
                                          4,

                                          offset:
                                          const Offset(
                                            0,
                                            6,
                                          ),
                                        ),
                                      ],
                                    ),

                                    child: Container(

                                      padding:
                                      const EdgeInsets
                                          .all(4),

                                      decoration:
                                      BoxDecoration(

                                        shape:
                                        BoxShape
                                            .circle,

                                        border:
                                        Border.all(

                                          color:
                                          Colors
                                              .white,

                                          width:
                                          3,
                                        ),
                                      ),

                                      child:
                                      CircleAvatar(

                                        radius:
                                        58,

                                        backgroundColor:
                                        Colors
                                            .white,

                                        backgroundImage:
                                        NetworkImage(
                                          user.image,
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// CAMERA ICON
                                  Positioned(

                                    bottom: 4,
                                    right: 4,

                                    child:
                                    Container(

                                      height:
                                      42,

                                      width:
                                      42,

                                      decoration:
                                      BoxDecoration(

                                        gradient:
                                        const LinearGradient(

                                          colors: [

                                            Color(
                                                0xff1E88E5),

                                            Color(
                                                0xff1565C0),
                                          ],
                                        ),

                                        shape:
                                        BoxShape
                                            .circle,

                                        border:
                                        Border.all(

                                          color:
                                          Colors
                                              .white,

                                          width:
                                          3,
                                        ),

                                        boxShadow: [

                                          BoxShadow(

                                            color: Colors
                                                .black
                                                .withOpacity(
                                              0.2,
                                            ),

                                            blurRadius:
                                            10,

                                            offset:
                                            const Offset(
                                              0,
                                              4,
                                            ),
                                          ),
                                        ],
                                      ),

                                      child:
                                      const Icon(

                                        Icons
                                            .camera_alt,

                                        color:
                                        Colors
                                            .white,

                                        size:
                                        20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                                height: 18),

                            /// ===================================
                            /// NAME
                            /// ===================================
                            Text(

                              "${user.firstName} ${user.lastName}",

                              style:
                              const TextStyle(

                                color:
                                Colors.white,

                                fontSize: 26,

                                fontWeight:
                                FontWeight.bold,

                                letterSpacing:
                                0.6,
                              ),
                            ),

                            const SizedBox(
                                height: 8),

                            /// ===================================
                            /// USERNAME BADGE
                            /// ===================================
                            Container(

                              padding:
                              const EdgeInsets
                                  .symmetric(

                                horizontal:
                                16,

                                vertical: 7,
                              ),

                              decoration:
                              BoxDecoration(

                                color: Colors
                                    .white
                                    .withOpacity(
                                  0.18,
                                ),

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  25,
                                ),

                                border:
                                Border.all(

                                  color: Colors
                                      .white
                                      .withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),

                              child: Text(

                                "@${user.username}",

                                style:
                                const TextStyle(

                                  color:
                                  Colors.white,

                                  fontSize:
                                  14,

                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 10),

                            /// ===================================
                            /// EMAIL
                            /// ===================================
                            Text(

                              user.email,

                              style:
                              const TextStyle(

                                color:
                                Colors.white70,

                                fontSize: 15,

                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// =========================================
                    /// FLOATING INFO CARD
                    /// =========================================
                    Positioned(

                      bottom: -35,

                      left: 20,
                      right: 20,

                      child: Container(

                        padding:
                        const EdgeInsets.all(
                          18,
                        ),

                        decoration:
                        BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(
                            20,
                          ),

                          boxShadow: [

                            BoxShadow(

                              color: Colors.black
                                  .withOpacity(
                                0.08,
                              ),

                              blurRadius: 12,

                              offset:
                              const Offset(
                                0,
                                5,
                              ),
                            ),
                          ],
                        ),

                        child: Row(

                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,

                          children: [

                            buildTopInfo(
                              "Age",
                              "${user.age}",
                            ),

                            buildDivider(),

                            buildTopInfo(
                              "Gender",
                              user.gender,
                            ),

                            buildDivider(),

                            buildTopInfo(
                              "Blood",
                              user.bloodGroup,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                /// =========================================
                /// DETAILS SECTION
                /// =========================================
                buildProfileTile(

                  Icons.person_outline,

                  "Username",

                  user.username,
                ),

                buildProfileTile(

                  Icons.phone_outlined,

                  "Phone Number",

                  user.phone,
                ),

                buildProfileTile(

                  Icons.school_outlined,

                  "University",

                  user.university,
                ),

                buildProfileTile(

                  Icons.remove_red_eye_outlined,

                  "Eye Color",

                  user.eyeColor,
                ),

                buildProfileTile(

                  Icons.email_outlined,

                  "Email",

                  user.email,
                ),

                const SizedBox(height: 25),

                /// =========================================
                /// LOGOUT BUTTON
                /// =========================================
                Padding(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),

                  child: SizedBox(

                    width: double.infinity,

                    height: 58,

                    child:
                    ElevatedButton.icon(

                      onPressed:
                      widget.onLogout,

                      icon: const Icon(
                        Icons.logout,
                        size: 24,
                      ),

                      label: const Text(

                        "Logout",

                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      style:
                      ElevatedButton
                          .styleFrom(

                        backgroundColor:
                        Colors.redAccent,

                        foregroundColor:
                        Colors.white,

                        elevation: 4,

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius
                              .circular(
                            18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  /// =========================================
  /// TOP INFO UI
  /// =========================================
  Widget buildTopInfo(
      String title,
      String value) {

    return Column(

      children: [

        Text(

          value,

          style: const TextStyle(

            fontSize: 20,

            fontWeight:
            FontWeight.bold,

            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 4),

        Text(

          title,

          style: const TextStyle(

            fontSize: 14,

            color: Colors.grey,

            fontWeight:
            FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// =========================================
  /// DIVIDER
  /// =========================================
  Widget buildDivider() {

    return Container(

      height: 40,

      width: 1,

      color: Colors.grey.shade300,
    );
  }

  /// =========================================
  /// PROFILE TILE
  /// =========================================
  Widget buildProfileTile(

      IconData icon,
      String title,
      String value) {

    return Container(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(
              0.05,
            ),

            blurRadius: 10,

            offset:
            const Offset(0, 5),
          ),
        ],
      ),

      child: Row(

        children: [

          /// ICON
          Container(

            padding:
            const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color: Colors.blue
                  .withOpacity(0.1),

              borderRadius:
              BorderRadius.circular(
                14,
              ),
            ),

            child: Icon(

              icon,

              color: Colors.blue,

              size: 26,
            ),
          ),

          const SizedBox(width: 15),

          /// TEXT SECTION
          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: const TextStyle(

                    color: Colors.grey,

                    fontSize: 14,

                    fontWeight:
                    FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(

                  value,

                  style: const TextStyle(

                    color:
                    Colors.black87,

                    fontSize: 17,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}