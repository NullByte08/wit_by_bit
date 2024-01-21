import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wit_by_bit/models/application_model.dart';
import 'package:wit_by_bit/models/pizza_model.dart';
import 'package:wit_by_bit/screens/search_screen.dart';
import 'package:wit_by_bit/utils/constants.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ConsumerState<HomePageScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var screenWidth = constraints.maxWidth;
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 160.0,
              collapsedHeight: 70,
              toolbarHeight: 50,
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.network(
                      "https://www.foodandwine.com/thmb/Wd4lBRZz3X_8qBr69UOu2m7I2iw=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/classic-cheese-pizza-FT-RECIPE0422-31a2c938fc2546c9a07b7011658cfd05.jpg",
                      fit: BoxFit.cover,
                      color: Colors.black.withAlpha(100),
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  )
                ],
              ),
              actions: [
                InkWell(
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.search,
                    ),
                  ),
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabAlignment: TabAlignment.start,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(
                      text: "Recommended",
                    ),
                    Tab(
                      text: "Regulars",
                    ),
                    Tab(
                      text: "Combos",
                    ),
                    Tab(
                      text: "Special",
                    ),
                  ],
                ),
                SizedBox(
                  height: 600,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SizedBox(
                        width: screenWidth,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: listOfPizzas.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FoodItemCard(
                              id: index,
                            );
                          },
                        ),
                      ),
                      Container(),
                      Container(),
                      Container(),
                    ],
                  ),
                )
              ]),
            ),
          ],
        ),
        bottomNavigationBar: Builder(builder: (context) {
          var show = ref.watch(applicationModelProvider).mapOfSelectedPizzas.isNotEmpty;
          int numberOfItems = 0;
          ref.watch(applicationModelProvider).mapOfSelectedPizzas.values.forEach((element) {
            numberOfItems += element;
          });
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: show ? 50 : 0,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, -1),
                  blurRadius: 10,
                )
              ],
            ),
            child: show
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          numberOfItems != 1 ? "$numberOfItems items" : "1 item",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text("View cart"),
                        ),
                      ],
                    ),
                  )
                : null,
          );
        }),
      );
    });
  }
}

class FoodItemCard extends ConsumerWidget {
  const FoodItemCard({super.key, required this.id});

  final int id;

  @override
  Widget build(context, ref) {
    var applicationModel = ref.watch(applicationModelProvider);
    return Container(
      height: 150,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 130,
                  height: 130,
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    "https://www.tasteofhome.com/wp-content/uploads/2018/01/Homemade-Pizza_EXPS_FT23_376_EC_120123_3.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listOfPizzas[id],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Cheesy pizza",
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Text(
                            "₹ 209",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Builder(
                                builder: (context) {
                                  bool enabled =
                                      applicationModel.mapOfSelectedPizzas.containsKey(id) && applicationModel.mapOfSelectedPizzas[id]! > 0;
                                  return InkWell(
                                    onTap: () {
                                      ref.read(applicationModelProvider.notifier).removePizza(
                                            PizzaModel(id: id),
                                          );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: enabled ? Colors.lightGreenAccent.shade700 : Colors.grey,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: enabled ? Colors.lightGreenAccent.shade700 : Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              Text(
                                applicationModel.mapOfSelectedPizzas[id]?.toString() ?? "0",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  ref.read(applicationModelProvider.notifier).addPizza(
                                        PizzaModel(id: id),
                                      );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreenAccent.shade100,
                                    border: Border.all(
                                      color: Colors.lightGreenAccent.shade700,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.lightGreenAccent.shade700,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            color: Colors.grey.shade300,
            height: 0,
          ),
        ],
      ),
    );
  }
}
