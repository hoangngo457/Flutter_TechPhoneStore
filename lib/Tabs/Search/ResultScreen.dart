import 'package:flutter/material.dart';
import 'package:storesalephone/Model/Category.dart';
import 'package:storesalephone/Model/OptionProduct.dart';

import 'SearchBarApp.dart';
import 'SortChipsProduct.dart';
import 'SearchCategorie.dart';
import 'SearchListProduct.dart';
import 'package:storesalephone/Tabs/Home/HomeSetup.dart';

class ResultSearch extends StatefulWidget {
  final String searchQuery;

  const ResultSearch({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<ResultSearch> createState() => _ResultSearchState();
}

class _ResultSearchState extends State<ResultSearch> {
  String product = 'ALL';
  String priceOrder = '';
  int brandId = 0;
  List<Category> brands = [];
  List<OptionProduct> products = [];
  List<OptionProduct> filteredProducts = [];
  String currentSearchQuery = "";
  int currentPage = 1;
  int productsPerPage = 6;

  void _handleSortSelection(String sortOption) {
    setState(() {
      priceOrder = sortOption;
      if (priceOrder == 'Tất cả') {
        brandId = 0;
      }
    });

    setUpProcess();
  }

  void _handleBrandSelection(int selectedBrandId, int trangthai) {
    setState(() {
      if (trangthai == 0) {
        brandId = trangthai;
      } else {
        brandId = selectedBrandId;
      }
    });
    setUpProcess();
  }

  Future<void> setUpProcess() async {
    SetUpData setUpData = SetUpData();
    List<Category> listCategoryApi = await setUpData.getDataCategory();
    List<OptionProduct> listProducts =
        await setUpData.getDataFilterProduct(product, priceOrder, brandId);

    setState(() {
      brands = listCategoryApi;
      products = listProducts;
      if (priceOrder == 'Tất cả') {
        filteredProducts = listProducts;
      } else {
        filteredProducts = listProducts
            .where((product) => product.product!.name!
                .toLowerCase()
                .contains(widget.searchQuery.toLowerCase()))
            .toList();
      }
      currentPage = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    currentSearchQuery = widget.searchQuery;
    setUpProcess();
  }

  void _handleSearch(String query) {
    setState(() {
      currentSearchQuery = query;
      if (priceOrder == 'Tất cả') {
        filteredProducts = products;
      } else {
        filteredProducts = products
            .where((product) => product.product!.name!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
      currentPage = 1;
    });
  }

  List<OptionProduct> getCurrentPageProducts() {
    final startIndex = (currentPage - 1) * productsPerPage;
    final endIndex = startIndex + productsPerPage;
    return filteredProducts.sublist(
      startIndex,
      endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
    );
  }

  void _nextPage() {
    setState(() {
      if (currentPage * productsPerPage < filteredProducts.length) {
        currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (currentPage > 1) {
        currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedProducts = getCurrentPageProducts();
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 340,
                decoration: const BoxDecoration(
                  color: Colors.indigoAccent,
                ),
                child: Column(
                  children: [
                    SearchBarApp(onSearch: _handleSearch),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: currentSearchQuery == ''
                          ? Text(
                              'Có tất cả ${filteredProducts.length} sản phẩm',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          : Text(
                              'Có tất cả ${filteredProducts.length} sản phẩm cho từ khóa "$currentSearchQuery"',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                    HomeCategories(
                      brands: brands,
                      onBrandSelected: _handleBrandSelection,
                    ),
                    SortChips(onSortSelected: _handleSortSelection),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade100),
                child: Column(
                  children: [
                    HomeListProduct(products: displayedProducts),
                    if (filteredProducts.length > productsPerPage)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: _previousPage,
                          ),
                          Text('Trang $currentPage'),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: _nextPage,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
