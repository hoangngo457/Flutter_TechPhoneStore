import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:storesalephone/Model/OptionProduct.dart';

import 'package:storesalephone/Model/SQLite/DatabaseHistorySearch.dart';

import 'package:storesalephone/MyAppScreen.dart';
import 'package:storesalephone/Tabs/Home/HomeSetup.dart';
import 'package:storesalephone/Tabs/Search/ResultScreen.dart';

import 'SearchListProduct.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBarScreen(
              onSearch: (query) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultSearch(searchQuery: query),
                  ),
                );
              },
            ),
            const SearchHistory(),
            const FeaturedProducts()
          ],
        ),
      ),
    );
  }
}

class SearchBarScreen extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarScreen({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.indigoAccent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 60, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.back,
                      size: 40,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyAppScreen()));
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Nhập tên điện thoại tại đây',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () async {
                        final query = _searchController.text;
                        await DatabaseHelper.instance
                            .insertSearchHistory(query);
                        widget.onSearch(query);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchHistory extends StatefulWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  List<SearchItem> items = [];
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _fetchSearchHistory();
  }

  void _toggleShowAll() {
    setState(() {
      _showAll = !_showAll;
    });
  }

  Future<void> _fetchSearchHistory() async {
    final fetchedItems = await DatabaseHelper.instance.fetchSearchHistory();
    setState(() {
      items = fetchedItems;
    });
  }

  void _clearHistory() async {
    await DatabaseHelper.instance.clearSearchHistory();
    setState(() {
      items.clear();
    });
  }

  void _removeItem(int index) async {
    final id = items[index].id;
    await DatabaseHelper.instance.removeSearchHistory(id);
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = _showAll ? items : items.take(3).toList();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.start, // Căn chỉnh phần tử bắt đầu từ trên cùng
        children: [
          if (items.isNotEmpty)
            ListView.separated(
              padding: EdgeInsets.zero, // Đảm bảo không có padding
              shrinkWrap: true,
              itemCount: displayItems.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(displayItems[index].query),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _removeItem(index),
                  ),
                );
              },
            ),

          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton(
                onPressed: _showAll ? _clearHistory : _toggleShowAll,
                child: Text(
                  _showAll ? 'Xóa lịch sử tìm kiếm' : 'Xem thêm',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          // Nếu bạn có widget khác để thêm vào đây, hãy thêm vào đây.
        ],
      ),
    );
  }
}

class FeaturedProducts extends StatefulWidget {
  const FeaturedProducts({Key? key}) : super(key: key);

  @override
  State<FeaturedProducts> createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  List<OptionProduct> products = [];

  Future<void> setUpProcess() async {
    SetUpData setUpData = SetUpData();

    List<OptionProduct> listProducts = await setUpData.getDataProduct();
    setState(() {
      products = listProducts;
    });
  }

  @override
  void initState() {
    super.initState();
    setUpProcess();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                'Sản phẩm nổi bật',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Add reload functionality here if needed
              },
              child: const Text(
                'Tải lại',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: HomeListProduct(products: products),
        ),
      ],
    );
  }
}
