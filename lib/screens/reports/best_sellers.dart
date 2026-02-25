import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BestSellersScreen extends StatelessWidget {
  const BestSellersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF58A39B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Best Sellers',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                  isLast: false,
                ),
                _buildBestSellerItem(
                  title: 'Cotton Shirt',
                  sold: '10 sold',
                  price: '₹950.00',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDxvdGYeWXIMAnnMSYtvKYN-VYFfA94OcrN6SbCNV-eqUHmCx2vpaCen_iVvcxyPHLgtwZYZfq_bowtT3b9F6PGsAM-ZYP48-0waE9538Tz87-jpWV0qhImnf9_0U1ufYThPyizh3Bw1xmUkTfxuJpO0Cf9u9ubN4bYRhU3Oe6cg9aNeiC421qkKZXfcGUEowVWXkawsHClanTgccCowJeQVWx2SgoK8snGMN9Q10X3CfJdCdyMurN0MtjTnyXTgQGx2jB5MNd0qxYc',
                  isLast: false,
                ),
                _buildBestSellerItem(
                  title: 'Summer Hat',
                  sold: '8 sold',
                  price: '₹450.00',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAeY2ltlyFMtQuAefOsXXzxixyOczjjJ1-YYmHbNg6b4W0llzxnEs76eR-gMFm23vMBTSE9OSpvHhPfoU96vdy0OGotsF4RuoklHtYlkitYFTdKmGhzZbhHyz3ZJ5rMHc-V2te4UCo6vRe8a94erJvR1d32bV8nLZvaULMHtm4qwzK3JqvySdhD3r9322QpDexB3afj15S045DRvaHkbKuBj3MUT_MXGIHIPhRlHOumOra-eNCODrjhE7E10Te3ZCudqZ1VXOs71TUl',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
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
                ),
                const SizedBox(height: 4),
                Text(
                  sold,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
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
}
