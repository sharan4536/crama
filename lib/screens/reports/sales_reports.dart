import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalesReportsPage extends StatefulWidget {
  const SalesReportsPage({super.key});

  @override
  State<SalesReportsPage> createState() => _SalesReportsPageState();
}

class _SalesReportsPageState extends State<SalesReportsPage> {
  String _selectedFilter = 'Weekly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF58A39B), // 41%
              Color(0xFF92B3A9), // 81%
            ],
            stops: [0.41, 0.81],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildDateFilter(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      _buildHeroChartCard(),
                      const SizedBox(height: 20),
                      _buildBestSellers(),
                      const SizedBox(height: 20),
                      _buildPaymentBreakdown(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          Text(
            'Sales Reports',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.015,
            ),
          ),
          _buildIconButton(
            icon: Icons.share,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildFilterOption('Daily'),
            _buildFilterOption('Weekly'),
            _buildFilterOption('Monthly'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label) {
    final isSelected = _selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = label),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF57a29b) : Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroChartCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Revenue',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹4,250.00',
                      style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF121716),
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.trending_up, color: Color(0xFF078830), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '+12%',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF078830),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Chart Visualization
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size.infinite,
                  painter: ChartPainter(),
                ),
                // Tooltip Overlay
                Positioned(
                  top: 20,
                  left: 235, // Approximate relative position
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121716),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹1,200',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // X-Axis Labels
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAxisLabel('Mon'),
                _buildAxisLabel('Tue'),
                _buildAxisLabel('Wed'),
                _buildAxisLabel('Thu'),
                _buildAxisLabel('Fri', isSelected: true),
                _buildAxisLabel('Sat'),
                _buildAxisLabel('Sun'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAxisLabel(String text, {bool isSelected = false}) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? const Color(0xFF57a29b) : Colors.grey[400],
      ),
    );
  }

  Widget _buildBestSellers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Best Sellers',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'View All',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildBestSellerItem(
                  title: 'Silk Floral Scarf',
                  sold: '42 sold',
                  price: '₹840.00',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDxvdGYeWXIMAnnMSYtvKYN-VYFfA94OcrN6SbCNV-eqUHmCx2vpaCen_iVvcxyPHLgtwZYZfq_bowtT3b9F6PGsAM-ZYP48-0waE9538Tz87-jpWV0qhImnf9_0U1ufYThPyizh3Bw1xmUkTfxuJpO0Cf9u9ubN4bYRhU3Oe6cg9aNeiC421qkKZXfcGUEowVWXkawsHClanTgccCowJeQVWx2SgoK8snGMN9Q10X3CfJdCdyMurN0MtjTnyXTgQGx2jB5MNd0qxYc',
                  isLast: false,
                ),
                _buildBestSellerItem(
                  title: 'Leather Belt',
                  sold: '30 sold',
                  price: '₹1,200.00',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAeY2ltlyFMtQuAefOsXXzxixyOczjjJ1-YYmHbNg6b4W0llzxnEs76eR-gMFm23vMBTSE9OSpvHhPfoU96vdy0OGotsF4RuoklHtYlkitYFTdKmGhzZbhHyz3ZJ5rMHc-V2te4UCo6vRe8a94erJvR1d32bV8nLZvaULMHtm4qwzK3JqvySdhD3r9322QpDexB3afj15S045DRvaHkbKuBj3MUT_MXGIHIPhRlHOumOra-eNCODrjhE7E10Te3ZCudqZ1VXOs71TUl',
                  isLast: false,
                ),
                _buildBestSellerItem(
                  title: 'Evening Dress',
                  sold: '12 sold',
                  price: '₹1,800.00',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBoZRClVU7mYf82VlxYX7Z_Y_y650nwjB2zi00CKAgT8eRsE1vmGEGUQSD9EvfpOJn9Be4K6uOogJwLOVx6BFYBkEilBh1g5GfLN5SyP4cRS7d_9XyoLIAmigalEwUBMLTm9rBnywIHv1xdtfnZddLJ64Wq3jyzyJ60Q9vvErsDEURnQu1TJsDTFFd3Fc1wipggrSg3SaoUUjjvRpPG5JW7Beon5UF_3bWadVGihF_FpQwrHnONcoz_GufG0hctmGjV_geS1ClQJCCV',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellerItem({
    required String title,
    required String sold,
    required String price,
    required String imageUrl,
    required bool isLast,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF121716),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  sold,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF121716),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBreakdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              'Sales by Payment',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPaymentItem(
                  icon: Icons.credit_card,
                  label: 'Credit Card',
                  percentage: '60%',
                  color: Colors.indigo,
                  bgColor: Colors.indigo[100]!,
                  progressValue: 0.6,
                ),
                const SizedBox(height: 16),
                _buildPaymentItem(
                  icon: Icons.payments,
                  label: 'Cash',
                  percentage: '30%',
                  color: Colors.green,
                  bgColor: Colors.green[100]!,
                  progressValue: 0.3,
                ),
                const SizedBox(height: 16),
                _buildPaymentItem(
                  icon: Icons.account_balance_wallet,
                  label: 'Digital Wallet',
                  percentage: '10%',
                  color: Colors.orange,
                  bgColor: Colors.orange[100]!,
                  progressValue: 0.1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem({
    required IconData icon,
    required String label,
    required String percentage,
    required MaterialColor color,
    required Color bgColor,
    required double progressValue,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color[600]),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF121716),
                  ),
                ),
              ],
            ),
            Text(
              percentage,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF121716),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(100),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progressValue,
            child: Container(
              decoration: BoxDecoration(
                color: color[500],
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF57a29b)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF57a29b).withOpacity(0.2),
          const Color(0xFF57a29b).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Approximating the curve from the SVG
    final path = Path();
    // Assuming size 375x220 relative scale
    final w = size.width;
    final h = size.height;
    
    // Scale points from 375x220 coordinate system
    double sx(double x) => x * w / 375;
    double sy(double y) => y * h / 220;

    path.moveTo(sx(0), sy(160));
    path.cubicTo(sx(40), sy(160), sx(50), sy(80), sx(90), sy(80));
    path.cubicTo(sx(130), sy(80), sx(140), sy(140), sx(180), sy(140));
    path.cubicTo(sx(220), sy(140), sx(230), sy(60), sx(270), sy(60));
    path.cubicTo(sx(310), sy(60), sx(320), sy(120), sx(375), sy(100));

    // Draw fill first
    final fillPath = Path.from(path);
    fillPath.lineTo(sx(375), sy(220));
    fillPath.lineTo(sx(0), sy(220));
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw stroke
    canvas.drawPath(path, paint);

    // Interactive Dot
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotStroke = Paint()
      ..color = const Color(0xFF57a29b)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotCenter = Offset(sx(270), sy(60));
    canvas.drawCircle(dotCenter, 6, dotPaint);
    canvas.drawCircle(dotCenter, 6, dotStroke);
    
    // Tooltip simulation can be added as an Overlay or just positioned text, 
    // but doing it in paint is hard for text. 
    // I already added the tooltip in the HTML structure to the widget tree? 
    // No, I need to add the tooltip in the widget tree above the CustomPaint.
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
