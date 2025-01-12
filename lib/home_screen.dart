import 'package:ecommerce_jam_tangan/custom_scaffold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CardItem> cardItems = [];

  @override
  void initState() {
    super.initState();
    cardItems = [
      CardItem(title: 'Casio - G-Shock Seri 2100', pricing: 'Rp. 2.450.000', images: 'images/watch1.jpg'),
      CardItem(title: 'Fossil - Defender Solar-Powered Stainless Steel Watch', pricing: 'Rp. 3.945.000', images: 'images/watch2.jpg'),
      CardItem(title: 'Seiko - SNE573', pricing: 'Rp. 5.200.000', images: 'images/watch3.jpg'),
      CardItem(title: ' Alba - Mechanical AL4537X1', pricing: 'Rp. 1.560.000', images: 'images/watch4.jpg'),
      CardItem(title: 'Daniel Wellington - Elan Green Malachite Lumine Rose Gold', pricing: 'Rp. 2.690.000', images: 'images/watch5.jpg')
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body : SafeArea(
        child: Column(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.blue[700]),
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    IconButton(
                    onPressed: () {}, 
                    icon: Icon(Icons.filter_list),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: cardItems.map((cardItem){
                  return buildCard(cardItem);
                }).toList(),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(CardItem cardItem){
    return Card(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: PageView.builder(
              itemBuilder : (context, index) {
                return Image.asset(
                  cardItem.images[index],
                  fit: BoxFit.cover,
                );
              }
            ),
          ),
          ListTile(
            title: Text(
              cardItem.title,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(cardItem.pricing),
            trailing: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text('Premium',
              style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }

}

class CardItem{
  final String title;
  final String pricing;
  final String images;

  CardItem({required this.title, required this.pricing, required this.images});
}