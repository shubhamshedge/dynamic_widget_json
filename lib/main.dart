import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<String> items = [
    'Item 1',
    'Item 2sdnaLKF NELFHEBWKLGBLRWAEGBOBSUORBAOBRTBSHIBRLEI EIUHGIUOSEHRGBJKERIGBEUR REIUGTIREI BIRBGIURUIEGBIQREI R GRGIERJHVBHRBE BRBIRBGFBRUEGVYBAGVDUYFVAGU YGRYGUY VUGRVBYGBYW YUBER GUYRUGFVUER HUJGQVRYEGVUY QURE REWUYGVFUR VRUGVQUVBG UYEWRGVUY VURQ',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('List of Items'),
        ),
        body: ListView.builder(
          itemCount: (items.length / 2).ceil(),
          itemBuilder: (context, index) {
            final int firstIndex = index * 2;
            final int secondIndex = index * 2 + 1;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: Text(items[firstIndex]),
                        onTap: () {
                          // Handle item tap
                          print('Tapped ${items[firstIndex]}');
                        },
                      ),
                    ),
                  ),

                  if (secondIndex < items.length)
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: Text(items[secondIndex]),
                          onTap: () {
                            // Handle item tap
                            print('Tapped ${items[secondIndex]}');
                          },
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
