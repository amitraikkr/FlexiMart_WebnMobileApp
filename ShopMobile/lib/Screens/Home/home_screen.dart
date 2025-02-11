import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Products/Model/product_model.dart';
import 'package:mobile_pos/Screens/Products/Providers/category,brans,units_provide.dart';
import 'package:mobile_pos/Screens/Sales/add_sales.dart';
import 'package:mobile_pos/currency.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';
import '../../Const/api_config.dart';
import '../../Provider/add_to_cart.dart';
import '../../Provider/profile_provider.dart';
import '../../constant.dart';
import '../../model/add_to_cart_model.dart';
import '../../model/business_info_model.dart' as business;
import '../../GlobalComponents/no_data_found.dart';
import '../Products/Model/category_model.dart';
import 'Model/drawer_manu_tile_model.dart';

import '../../Screens/Report/customer_orders_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../Repository/constant_functions.dart';


// Update the orderProvider to handle count
final orderProvider = StateNotifierProvider<OrderNotifier, AsyncValue<int>>((ref) {
  return OrderNotifier();
});

class OrderNotifier extends StateNotifier<AsyncValue<int>> {
  OrderNotifier() : super(const AsyncValue.loading()) {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      state = const AsyncValue.loading();
      
      final uri = Uri.parse('${APIConfig.url}/orders/count');
      print('Fetching orders from: $uri');

      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
        'Authorization': await getAuthToken(),
      });
      
      print('Response status: ${response.statusCode}'); // Debug status code
      print('Response body: ${response.body}'); // Debug response data

      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body) as Map<String, dynamic>;
        final count = parsedData['data'] as int;
        print('Parsed count: $count'); // Debug parsed count
        
        state = AsyncValue.data(count);
      } else {
        throw Exception('Failed to fetch order count');
      }
    } catch (e, stack) {
      print('Error fetching orders: $e'); // Debug errors
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await fetchOrders();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<DrawerManuTileModel> get drawerMenuList => [
        DrawerManuTileModel(title: lang.S.current.home, image: 'assets/grocery/home.svg', route: 'Home'),
        DrawerManuTileModel(title: lang.S.current.salesList, image: 'assets/grocery/sales_list.svg', route: 'Sales List'),
        DrawerManuTileModel(title: lang.S.current.parties, image: 'assets/grocery/parties.svg', route: 'Parties'),
        DrawerManuTileModel(title: lang.S.current.items, image: 'assets/grocery/items.svg', route: 'Products'),
        DrawerManuTileModel(title: lang.S.current.purchase, image: 'assets/grocery/purchase.svg', route: 'Purchase'),
        DrawerManuTileModel(
            title: lang.S.current.purchaseList, image: 'assets/grocery/sales_list.svg', route: 'Purchase List'), // Assuming you intended to use 'sales_list.svg' here
        //DrawerManuTileModel(title: lang.S.current.dueList, image: 'assets/grocery/due_list.svg', route: 'Due List'),
        //DrawerManuTileModel(title: lang.S.current.lossProfit, image: 'assets/grocery/loss_profit.svg', route: 'Loss/Profit'),
        //DrawerManuTileModel(title: lang.S.current.stock, image: 'assets/grocery/stock.svg', route: "Stock"),
        //DrawerManuTileModel(title: lang.S.current.income, image: 'assets/incomeReport.svg', route: 'Income'),
        //DrawerManuTileModel(title: lang.S.current.expense, image: 'assets/grocery/expense.svg', route: 'Expense'),
        DrawerManuTileModel(title: lang.S.current.reports, image: 'assets/grocery/reports.svg', route: 'Reports'),
      ];
  bool checkPermission({required String item, required business.Visibility? visibility}) {
    if (item == 'Sales' && (visibility?.salePermission ?? true)) {
      return true;
    } else if (item == 'Parties' && (visibility?.partiesPermission ?? true)) {
      return true;
    } else if (item == 'Purchase' && (visibility?.purchasePermission ?? true)) {
      return true;
    } else if (item == 'Products' && (visibility?.productPermission ?? true)) {
      return true;
    } else if (item == 'Due List' && (visibility?.dueListPermission ?? true)) {
       return true;
    } else if (item == 'Stock' && (visibility?.stockPermission ?? true)) {
      return true;
    } else if (item == 'Reports' && (visibility?.reportsPermission ?? true)) {
      return true;
    } else if (item == 'Sales List' && (visibility?.salesListPermission ?? true)) {
      return true;
    } else if (item == 'Purchase List' && (visibility?.purchaseListPermission ?? true)) {
      return true;
    } else if (item == 'Loss/Profit' && (visibility?.lossProfitPermission ?? true)) {
      return true;
    } else if (item == 'Income' && (visibility?.addIncomePermission ?? true)) {
      return true;
    } else if (item == 'Expense' && (visibility?.addExpensePermission ?? true)) {
      return true;
    }
    return false;
  }

  num? selectedCategoryId = 0;
  bool isListView = false;

  TextEditingController productSearchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    productSearchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (_, ref, __) {
        final orders = ref.watch(orderProvider); // Fetch latest orders

        final businessInfo = ref.watch(businessInfoProvider);
        final category = ref.watch(categoryProvider);
        final product = ref.watch(productProvider(selectedCategoryId));
        final cartData = ref.watch(cartNotifier);
        return businessInfo.when(data: (details) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: kBackgroundColor,

            ///______Drawer__________________________
            drawer: Drawer(
              backgroundColor: Colors.white,
              child: SafeArea( // Added for safer UI rendering
                child: Column(
                  children: [

  

                      /// **🔹 Categories Section (Existing Feature)**
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Categories",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: kGreyTextColor.withOpacity(0.2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/logo.png',
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  appsName,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _scaffoldKey.currentState?.closeDrawer();
                            },
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                    ),


                    /// Wrapping with Expanded to prevent overflow
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: drawerMenuList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              if (drawerMenuList[index].route == 'Home') {
                                _scaffoldKey.currentState?.closeDrawer();
                                return;
                              }
                              if (checkPermission(
                                  item: drawerMenuList[index].route,
                                  visibility: details.user?.visibility)) {
                                Navigator.of(context)
                                    .pushNamed('/${drawerMenuList[index].route}');
                              } else {
                                EasyLoading.showError(
                                  lang.S.of(context).permissionNotGranted,
                                );
                              }
                            },
                            leading: SvgPicture.asset(
                              drawerMenuList[index].image,
                              height: 25,
                              width: 25,
                            ),
                            title: Text(drawerMenuList[index].title),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ///______App_Bar__________________________
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: kMainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                ),
                child: AppBar(
                  toolbarHeight: 100,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  leading: IconButton(
                    splashColor: Colors.white,
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        // border: Border.all(width: 1, color: Colors.white.withOpacity(0.5)),
                      ),
                      child: const Icon(Icons.menu),
                    ),
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        details.user?.role == 'staff' ? '${details.companyName ?? ''} [${details.user?.name ?? ''}]' : details.companyName ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: Colors.white.withOpacity(0.2),
                      //       borderRadius: const BorderRadius.all(Radius.circular(50)),
                      //       border: Border.all(width: 1, color: Colors.white.withOpacity(0.5))),
                      //   // child: Padding(
                      //   //   padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      //   //   child: Text(
                      //   //     "${details.enrolledPlan?.plan?.subscriptionName ?? ''} ${lang.S.of(context).plan}",
                      //   //     style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                      //   //   ),
                      //   // ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            resizeToAvoidBottomInset: true,

            ///______Body________________________________
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///_______Cart_________________________________
                          Visibility(
                            visible: cartData.cartItemList.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddSalesScreen(customerModel: null),
                                      ));
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: kMainColor, borderRadius: BorderRadius.all(Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 47,
                                          width: 62,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 40,
                                                  width: 55,
                                                  decoration:
                                                      BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(8)), border: Border.all(color: Colors.white, width: 2)),
                                                ),
                                              ),
                                              Container(
                                                height: 40,
                                                width: 55,
                                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: Colors.white),
                                                child: Center(
                                                    child: Text(
                                                  '${cartData.cartItemList.length}',
                                                  style: const TextStyle(fontSize: 20, color: Colors.black),
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '$currency ${cartData.getTotalAmount()}',
                                          style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 22,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                         
                                                  ///______Order Notification Section_______________________________
                          Consumer(
                            builder: (_, ref, __) {
                              final orderCount = ref.watch(orderProvider);
                              return orderCount.when(
                                data: (count) {
                                  if (count == 0) return const SizedBox.shrink();
                                  return NotificationCard(
                                    orderCount: count,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CustomerOrdersScreen(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                loading: () => const CircularProgressIndicator(),
                                error: (_, __) => const SizedBox.shrink(),
                              );
                            },
                          ),





                          ///______category_______________________________
                          Text(
                            lang.S.of(context).categories,
                            // 'Categories',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            child: category.when(
                              data: (data) {
                                ///________Add default 'All' category______________________
                                List<CategoryModel> categories = [
                                  CategoryModel(id: 0, categoryName: lang.S.of(context).all),
                                  ...data,
                                ];

                                return ListView.builder(
                                  itemCount: categories.length,
                                  shrinkWrap: true,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            ref.refresh(productProvider(selectedCategoryId));
                                            selectedCategoryId = categories[index].id;
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            categories[index].icon != null
                                                ? Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        border: selectedCategoryId == categories[index].id ? Border.all(color: kMainColor, width: 2) : null,
                                                        color: kMainColor,
                                                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                        image: DecorationImage(image: NetworkImage('${APIConfig.domain}${categories[index].icon}'), fit: BoxFit.cover)),
                                                  )
                                                : Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      border: selectedCategoryId == categories[index].id ? Border.all(color: kMainColor, width: 2) : null,
                                                      color: kMainColor,
                                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                      image: DecorationImage(fit: BoxFit.cover, image: AssetImage(noProductImageUrl)),
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 70,
                                              child: Center(
                                                child: Text(
                                                  categories[index].categoryName.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: selectedCategoryId == categories[index].id ? kMainColor : null,
                                                    fontWeight: selectedCategoryId == categories[index].id ? FontWeight.bold : null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              //error: (error, stackTrace) => const Text('Could not fetch the categories'),
                              error: (error, stackTrace) => Text(lang.S.of(context).couldNotFetchTheCategories),
                              loading: () => const SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///________Search_____________________________________
                  product.when(
                    data: (products) {
                      List<ProductModel> productsList =
                          products.where((element) => element.productName!.toLowerCase().contains(productSearchController.text.toLowerCase())).toList();
                      return Column(
                        children: [
                          ///________Search___________________________________
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: productSearchController,
                              decoration:
                                  InputDecoration(border: const OutlineInputBorder(), hintText: '${lang.S.of(context).searchHere}....', suffixIcon: const Icon(IconlyLight.search)),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '${productsList.length} ${lang.S.of(context).all}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                                      TextSpan(
                                          //text: ' items For',
                                          text: ' ${lang.S.of(context).itemsFor}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade600,
                                          )),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isListView = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.grid_view_rounded,
                                          color: isListView ? Colors.grey.shade600 : kMainColor,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isListView = true;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.menu,
                                          color: isListView ? kMainColor : Colors.grey.shade600,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                          productsList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: isListView
                                        ? ListView.builder(
                                            itemCount: productsList.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                onTap: () {
                                                  AddToCartModel cartItem = AddToCartModel(
                                                    productName: productsList[index].productName,
                                                    price: productsList[index].productSalePrice,
                                                    productId: productsList[index].productCode,
                                                    productBrandName: productsList[index].brand?.brandName,
                                                    productPurchasePrice: productsList[index].productPurchasePrice,
                                                    stock: (productsList[index].productStock ?? 0),
                                                    uuid: productsList[index].id ?? 0,
                                                    unitName: productsList[index].unit?.unitName,
                                                    imageUrl: productsList[index].productPicture,
                                                  );
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(20),
                                                      ),
                                                    ),
                                                    builder: (context) => ItemDetailsModal(
                                                      product: cartItem,
                                                      ref: ref,
                                                    ),
                                                  );
                                                },
                                                leading: productsList[index].productPicture == null
                                                    ? SizedBox(
                                                        height: 60,
                                                        width: 60,
                                                        child: Image.asset(noProductImageUrl, fit: BoxFit.cover),
                                                      )
                                                    : SizedBox(
                                                        height: 60,
                                                        width: 60,
                                                        child: Image.network('${APIConfig.domain}${productsList[index].productPicture!}', fit: BoxFit.cover),
                                                      ),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      productsList[index].productName ?? '',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    Visibility(
                                                      visible: cartData.getAProductQuantity(uid: productsList[index].id ?? 0) != null,
                                                      child: CircleAvatar(
                                                        backgroundColor: kMainColor,
                                                        minRadius: 5,
                                                        child: SizedBox(
                                                            height: 24,
                                                            width: 24,
                                                            child: Center(
                                                                child: Text(
                                                              '${cartData.getAProductQuantity(uid: productsList[index].id ?? 0)}',
                                                              style: const TextStyle(fontSize: 12, color: Colors.white),
                                                            ))),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${productsList[index].productStock} ${productsList[index].unit?.unitName ?? ''}"),
                                                    Text('\$${productsList[index].productSalePrice?.toStringAsFixed(2)}'),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : GridView.builder(
                                            // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 3,childAspectRatio: 2,crossAxisSpacing: 0.4,mainAxisExtent: 20,mainAxisSpacing: 30),
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7),
                                            itemCount: productsList.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return SizedBox(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      AddToCartModel cartItem = AddToCartModel(
                                                        productName: productsList[index].productName,
                                                        price: productsList[index].productSalePrice,
                                                        productId: productsList[index].productCode,
                                                        productBrandName: productsList[index].brand?.brandName,
                                                        productPurchasePrice: productsList[index].productPurchasePrice,
                                                        stock: (productsList[index].productStock ?? 0),
                                                        uuid: productsList[index].id ?? 0,
                                                        unitName: productsList[index].unit?.unitName,
                                                        imageUrl: productsList[index].productPicture,
                                                      );
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled: true,
                                                        shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(20),
                                                          ),
                                                        ),
                                                        builder: (context) => ItemDetailsModal(
                                                          product: cartItem,
                                                          ref: ref,
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        productsList[index].productPicture == null
                                                            ? SizedBox(
                                                                height: 80,
                                                                width: 500,
                                                                child: Image.asset(
                                                                  noProductImageUrl,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                height: 80,
                                                                width: 500,
                                                                child: Image.network(
                                                                  '${APIConfig.domain}${productsList[index].productPicture!}',
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                        const SizedBox(height: 5.0),
                                                        Text(
                                                          productsList[index].productName ?? '',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        // const SizedBox(height: 2.0),
                                                        Text("${productsList[index].productStock} ${productsList[index].unit?.unitName ?? ''}"),
                                                        // const SizedBox(height: 2.0),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('\$${productsList[index].productSalePrice?.toStringAsFixed(2)}'),
                                                            Visibility(
                                                              visible: cartData.getAProductQuantity(uid: productsList[index].id ?? 0) != null,
                                                              child: CircleAvatar(
                                                                backgroundColor: kMainColor,
                                                                minRadius: 5,
                                                                child: SizedBox(
                                                                    height: 24,
                                                                    width: 24,
                                                                    child: Center(
                                                                        child: Text(
                                                                      '${cartData.getAProductQuantity(uid: productsList[index].id ?? 0)}',
                                                                      style: const TextStyle(fontSize: 12, color: Colors.white),
                                                                    ))),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                )
                              : EmptyListWidget(
                                  //title: 'No Product Found',
                                  title: lang.S.of(context).noProductFound,
                                ),
                        ],
                      );
                    },
                    // error: (error, stackTrace) => const Text('Could not fetch products'),
                    error: (error, stackTrace) => Text(lang.S.of(context).couldNotFetchProducts),
                    loading: () => const Padding(padding: EdgeInsets.all(10.0), child: CircularProgressIndicator()),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        }, error: (e, stack) {
          return Text(e.toString());
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        });
      }),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final int orderCount;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.orderCount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4FF),  // Light purple background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.notifications_active_outlined,
              color: const Color(0xFF6C63FF),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'You have $orderCount new order${orderCount > 1 ? 's' : ''} to process',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDetailsModal extends StatefulWidget {
  ItemDetailsModal({Key? key, required this.product, required this.ref}) : super(key: key);

  AddToCartModel product;
  final WidgetRef ref;

  @override
  State<ItemDetailsModal> createState() => _ItemDetailsModalState();
}

class _ItemDetailsModalState extends State<ItemDetailsModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isAlreadyInCart = false;

  @override
  void initState() {
    super.initState();
    for (var element in widget.ref.watch(cartNotifier).cartItemList) {
      if (element.uuid == widget.product.uuid) {
        setState(() {
          widget.product = element;
          isAlreadyInCart = true;
        });
      }
    }
    quantityController.text = '${widget.product.quantity}';
    priceController.text = '${widget.product.price}';
  }

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 15,
        right: 15,
        top: 10,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Item Details Header______________________________
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.S.of(context).itemDetails,
                  //'Item Details',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.clear),
                  ),
                ),
              ],
            ),
            const Divider(),

            ///_________ Item Name and Price_________________________
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product.productName ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                //const Text('Unit price'),
                Text(lang.S.of(context).unitPirce),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.product.stock} ${widget.product.unitName ?? ''}'),
                Text(
                  '$currency ${widget.product.price}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Unit Input Field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: quantityController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    decoration: InputDecoration(
                      // labelText: 'Quantity',
                      labelText: lang.S.of(context).quantity,
                      //hintText: 'Enter unit quantity',
                      hintText: lang.S.of(context).enterUnitQuantity,
                      border: const OutlineInputBorder(),
                      suffixIcon: (widget.product.unitName.isEmptyOrNull)
                          ? null
                          : Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(color: kBorderColorTextField.withOpacity(.5), borderRadius: const BorderRadius.all(Radius.circular(5))),
                                child: Center(child: Text(widget.product.unitName ?? '')),
                              ),
                            ),
                      suffixIconColor: Colors.red,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final quantity = num.tryParse(value ?? '') ?? 0;
                      if (quantity <= 0) {
                        // return 'Quantity must be greater than 0';
                        return '${lang.S.of(context).quantityMustBeGreaterThan} 0';
                      }
                      if (quantity > (widget.product.stock ?? 0)) {
                        //return 'Quantity exceeds available stock';
                        return lang.S.of(context).quantityExceedsAvailableStock;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Price Input Field
            TextFormField(
              controller: priceController,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              decoration: InputDecoration(
                //labelText: 'Sales Price',
                labelText: lang.S.of(context).salesPrice,
                //hintText: 'Please enter sales price',
                hintText: lang.S.of(context).pleaseEnterSalesPrice,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                final price = num.tryParse(value ?? '') ?? 0;
                if (price <= 0) {
                  //return 'Price must be greater than 0';
                  return '${lang.S.of(context).priceMustBeGreaterThan} 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Add to Cart Button
            Row(
              children: [
                Visibility(
                  visible: isAlreadyInCart,
                  child: SizedBox(
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          widget.ref.watch(cartNotifier).deleteToCart(widget.ref.watch(cartNotifier).cartItemList.indexWhere(
                                (element) => element.uuid == widget.product.uuid,
                              ));

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kMainColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      '${lang.S.of(context).addToCart} - ${lang.S.of(context).total}: $currency ${(num.tryParse(quantityController.text) ?? 1) * (num.tryParse(priceController.text) ?? 0)}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final quantity = num.tryParse(quantityController.text) ?? 1;
                        final price = num.tryParse(priceController.text) ?? 0;

                        widget.product.quantity = quantity;
                        widget.product.price = price;

                        isAlreadyInCart ? widget.ref.watch(cartNotifier).updateProductInCart(widget.product) : widget.ref.watch(cartNotifier).addToCart(widget.product);

                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


