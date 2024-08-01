import 'package:flutter/material.dart';
import 'package:storesalephone/Model/Category.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key, required this.brands});
  final List<Category> brands;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            alignment: Alignment.bottomLeft,
            child: const Text("Thương hiệu phổ biến",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: brands.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.1), // Shadow color
                              spreadRadius: 5, // Spread radius
                              blurRadius: 7, // Blur radius
                              offset: const Offset(0,
                                  3), // Offset in x and y axis from the shadow
                            )
                          ]),
                      child: Center(
                        child: Image.network(
                          brands[index].img.toString(),
                          fit: BoxFit.contain,
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 2),
                    // SizedBox(
                    //     width: 50,
                    //     child: Text(
                    //       brands[index].name.toString(),
                    //       style: const TextStyle(color: Colors.white),
                    //       overflow: TextOverflow.ellipsis,
                    //     ))
                  ],
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
