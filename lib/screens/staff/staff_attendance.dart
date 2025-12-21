import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffAttendanceScreen extends StatelessWidget {
  const StaffAttendanceScreen({super.key});

  static const Color primaryColor = Color(0xFF58A39B);
  static const Color backgroundLight = Color(0xFFF6F7F7);
  static const Color textMain = Color(0xFF121716);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // Bottom padding for sticky nav or FAB
              children: [
                const SizedBox(height: 24),
                _buildStaffCard(
                  name: "Sarah Jenkins",
                  role: "Sales Associate",
                  imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuBMNWtbBzpzE8_bTwKvHYVlNVGdbZgBZ_FyQhc1A0WmQWpMjHjwlL9CwtY__PUfRvSQ-h8obbh-_oBa0BAgdzZSXZ-CAfBF6ghyElkqzGrdnKbvpN3c6kZca9YP7MDsPfhQ1nEE8vH9EzrZXFUByHgXCQ638nZbxfXfefZSrPqK2IDpcc8VG9zwM_MFMktAqitYwE1namKRHr58iQW24oXAlFWxXZZOs9LACl3X0vf4L-ra1ixV5rIdqxbTjXnKCl09Cjw9cB9R7K15",
                  status: "Present",
                  inTime: "09:15 AM",
                  outTime: "--:--",
                  activeTime: "4h 30m",
                  isLate: false,
                  isAbsent: false,
                  isHalfDay: false,
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: "Mike Ross",
                  role: "Store Manager",
                  imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCj1NpY7hQM5ozJzysnRkR6V_8S8hDrWlN0jICwlcwhQ-vxzSQXYoEBOZAsBYI1MV2vJLZCWN4VSY3huIxbZ2tK2rIA8-fS4SR-HCJtHxKxsc4NLZkdHyiQzQyevxcUxvp0x5ipPiS5DbcYLCCUCQ-eNCnmCqfX890qMuhASksVPatDMO2QpkGQgyVa0iPwAd5P8bMWY8mlybnG5MdlVAySzWBkIkjgKCQ7kKetzcShzPdukEEKSavdqcNgODRshhwuNqjFRww5T9x3",
                  status: "Present",
                  inTime: "10:30 AM",
                  outTime: "--:--",
                  activeTime: "3h 15m",
                  isLate: true,
                  isAbsent: false,
                  isHalfDay: false,
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: "Jessica Pearson",
                  role: "Inventory Lead",
                  imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuA-j3K-3vZEk6tQ-NWj2q29yw5rJDL7u01f7TuVW1BWSiwLSo0a7NSsWa2PIpIOJZEjUg-T-QWe90SfVjK2DqpafwRx5y_l9dwkvAzA47lHZJ94xkpy6Si4n9LG2QyCeJ3CZqzIpKxw8-sTV-awODQjxxa1qq7PL7godnHmiaQ4LRYHA5SodGHi1loRDRZAC_7ALq6vp09lQtTIXiTbGzGWlmZRUdrooFwMQ53LQ8ocjP39oobiOlQfsuzKyWWkuPr-ICBt1fJsJg5f",
                  status: "Absent",
                  inTime: "--:--",
                  outTime: "--:--",
                  activeTime: "",
                  isLate: false,
                  isAbsent: true,
                  isHalfDay: false,
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: "Alex Wong",
                  role: "Intern",
                  imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCIIT1Xoo8r2dEAMA4JejCU3QBRdDPtqAa2fnF2UKUXHhsDz6qQWHkxDp_yW4e49xrjLWrlRA3-aY1xDC9Qey1pcBrHJMnErGC_3UJqMaGhqD3rGYQKkU3inuowk7cdzCrrn4dibtz8MehjxZ1bzm8P3xtd_eYoG9CLMWjF2AU0b-24u5UokOK60jRsz5XLexF9jSggQgJZPUP9myKwReY-mIg4GMOFMhFmZPz54KLL3Jej4576ndxO9sNCyJMihF3o6YcmwGm5rE21",
                  status: "Half-day",
                  inTime: "09:00 AM",
                  outTime: "01:30 PM",
                  activeTime: "4h 30m",
                  isLate: false,
                  isAbsent: false,
                  isHalfDay: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.41, 0.81],
          colors: [
            Color(0xFF58A39B),
            Color(0xFF92B3A9),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                    Text(
                      "Staff Attendance",
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    _buildIconButton(
                      icon: Icons.calendar_today,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              // Date Headline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TODAY",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Monday, Oct 24",
                      style: GoogleFonts.manrope(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              // Summary Stats
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _buildStatCard("Total Staff", "12", Colors.white.withOpacity(0.1)),
                    const SizedBox(width: 12),
                    _buildStatCard("Present", "10", Colors.white.withOpacity(0.2)),
                    const SizedBox(width: 12),
                    _buildStatCard("Absent", "2", Colors.white.withOpacity(0.1)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color bgColor) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard({
    required String name,
    required String role,
    required String imageUrl,
    required String status,
    required String inTime,
    required String outTime,
    required String activeTime,
    required bool isLate,
    required bool isAbsent,
    required bool isHalfDay,
  }) {
    Color statusColor = Colors.green;
    Color statusBgColor = Colors.green.shade50;
    if (isAbsent) {
      statusColor = Colors.red;
      statusBgColor = Colors.red.shade50;
    } else if (isHalfDay) {
      statusColor = Colors.blue;
      statusBgColor = Colors.blue.shade50;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isLate ? Colors.orange.shade200 : (isAbsent ? Colors.transparent : primaryColor),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.grey.shade200,
                      child: isAbsent ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                        child: CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl)),
                      ) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textMain,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            role,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          if (isLate) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "LATE",
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (status == "Present")
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      status,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isAbsent)
             Align(
              alignment: Alignment.centerRight,
               child: TextButton(
                 onPressed: () {},
                 style: TextButton.styleFrom(
                   backgroundColor: primaryColor,
                   foregroundColor: Colors.white,
                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                 ),
                 child: Text("Mark Present", style: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 14)),
               ),
             )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: isLate ? Border.all(color: Colors.orange.shade100) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.login, size: 16, color: isLate ? Colors.orange.shade400 : Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              "In Time",
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            inTime,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textMain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isHalfDay ? Icons.check_circle : Icons.logout,
                              size: 16,
                              color: isHalfDay ? primaryColor : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Out Time",
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            outTime,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textMain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 18, color: Colors.grey.shade400),
                      const SizedBox(width: 6),
                      Text(
                        isHalfDay ? "Total: $activeTime" : "Active: $activeTime",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  if (isHalfDay)
                    Text(
                      "Shift completed",
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade400,
                      ),
                    )
                  else
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Check Out",
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textMain,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
