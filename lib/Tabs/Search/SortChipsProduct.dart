import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SortChips extends StatefulWidget {
  final Function(String) onSortSelected;

  const SortChips({Key? key, required this.onSortSelected}) : super(key: key);

  @override
  _SortChipsState createState() => _SortChipsState();
}

class _SortChipsState extends State<SortChips> {
  String _selectedSort = 'Tất cả';

  final List<String> _sortOptions = [
    'Tất cả',
    'Mới nhất',
    'Giá cao',
    'Giá thấp'
  ];

  void _onChipSelected(String sortOption) {
    setState(() {
      _selectedSort = sortOption;
    });
    widget.onSortSelected(sortOption);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              'Sắp xếp theo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5), // Khoảng cách giữa chữ và các lựa chọn
          Wrap(
            spacing: 5.0,
            children: _sortOptions.map((option) {
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option,
                      style: TextStyle(
                          color: _selectedSort == option
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14),
                    ),
                    if (option == 'Giá cao' || option == 'Giá thấp')
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          option == 'Giá cao'
                              ? CupertinoIcons.sort_up
                              : CupertinoIcons.sort_down,
                          color: _selectedSort == option
                              ? Colors.white
                              : Colors.black,
                          size: 14,
                        ),
                      ),
                  ],
                ),
                selected: _selectedSort == option,
                selectedColor: Colors.red, // Màu nền khi được chọn
                backgroundColor:
                    Colors.grey[200], // Màu nền khi không được chọn
                onSelected: (selected) {
                  if (selected) {
                    _onChipSelected(option);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
