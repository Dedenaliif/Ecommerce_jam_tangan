import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:ecommerce_jam_tangan/models/product.dart';
import 'package:ecommerce_jam_tangan/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Fungsi untuk format harga dalam Rupiah
String formatRupiah(double harga) {
  final NumberFormat currencyFormatter = NumberFormat.simpleCurrency(locale: 'id_ID');
  return currencyFormatter.format(harga);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Daftar produk yang akan ditampilkan
  List<Product> products = [];
  List<Product> filteredProducts = []; // Daftar produk yang sudah difilter berdasarkan pencarian
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Menginisialisasi daftar produk
    products = [
      Product(
        title: 'Casio - G-Shock Seri 2100',
        pricing: 2450000,
        images: ['images/watch1.jpg'],
        description: 'Jam tangan Casio G-Shock dengan desain kokoh.',
      ),
      Product(
        title: 'Fossil - Defender Solar-Powered Stainless Steel Watch',
        pricing: 3945000,
        images: ['images/watch2.jpg'],
        description: 'Jam tangan dengan tenaga surya dan material stainless steel.',
      ),
      Product(
        title: 'Seiko - SNE573',
        pricing: 5200000,
        images: ['images/watch3.jpg'],
        description: 'Jam tangan Seiko dengan desain elegan dan daya tahan lama.',
      ),
      Product(
        title: 'Alba - Mechanical AL4537X1',
        pricing: 1560000,
        images: ['images/watch4.jpg'],
        description: 'Jam tangan Alba dengan mesin mekanik yang presisi.',
      ),
      Product(
        title: 'Daniel Wellington - Elan Green Malachite Lumine Rose Gold',
        pricing: 2690000,
        images: ['images/watch5.jpg'],
        description: 'Jam tangan Daniel Wellington dengan desain klasik yang elegan.',
      ),
    ];
    filteredProducts = products; // Menampilkan semua produk pada awalnya
  }

  void filterProducts(String query) {
    final filtered = products.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.blue[700]),
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: filterProducts, // Memanggil fungsi filter setiap ada perubahan di TextField
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                    ),
                  ],
                ),
              ),
            ),
            // Grid View untuk menampilkan produk yang sudah difilter
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3 / 4, // Menyesuaikan aspek rasio kartu
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return buildCard(filteredProducts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun kartu produk
  Widget buildCard(Product product) {
    return GestureDetector(
      onTap: () async {
        // Arahkan ke halaman ProductDetail dengan mengirim objek product
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                product.images[0], // Menggunakan gambar pertama dari list
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan judul produk
                  Text(
                    product.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  // Menampilkan harga produk
                  Text(
                    formatRupiah(product.pricing),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
