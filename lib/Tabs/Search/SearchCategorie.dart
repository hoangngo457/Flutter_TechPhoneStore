import 'package:flutter/material.dart';
import 'package:storesalephone/Model/Category.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({
    Key? key,
    required this.brands,
    required this.onBrandSelected,
  }) : super(key: key);

  final List<Category> brands;
  final Function(int, int) onBrandSelected;

  @override
  _HomeCategoriesState createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  int? selectedBrandId;

  void _handleBrandSelection(int id) {
    setState(() {
      if (selectedBrandId == id) {
        selectedBrandId = null; // Deselect if already selected
      } else {
        selectedBrandId = id; // Select the clicked brand
      }
    });
    widget.onBrandSelected(id, selectedBrandId == null ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            alignment: Alignment.bottomLeft,
            child: const Text(
              "Thương hiệu phổ biến",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.brands.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    _handleBrandSelection(widget.brands[index].id!);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selectedBrandId == widget.brands[index].id
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Center(
                            child: Image.network(
                              widget.brands[index].img.toString(),
                              fit: BoxFit.contain,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        // Uncomment the following lines if you want to show brand names
                        // const SizedBox(height: 2),
                        // SizedBox(
                        //     width: 50,
                        //     child: Text(
                        //       widget.brands[index].name.toString(),
                        //       style: const TextStyle(color: Colors.white),
                        //       overflow: TextOverflow.ellipsis,
                        //     ))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
