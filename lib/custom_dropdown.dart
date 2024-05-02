import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:test1/cache.dart';
import 'package:test1/refreshable.dart';


class CustomDropdownWithSearch extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String itemName;
  final int dState;
  final String labelText;
  final bool isAddNewPatient;
  final void Function()? onAddNewPatient;
  final void Function(String)? onSelected;

  const CustomDropdownWithSearch({
    Key? key,
    required this.items,
    required this.itemName,
    required this.dState,
    required this.labelText,
    this.isAddNewPatient = false,
    this.onAddNewPatient,
    this.onSelected,
  }) : super(key: key);

  @override
  _CustomDropdownWithSearchState createState() => _CustomDropdownWithSearchState();
}

class _CustomDropdownWithSearchState extends State<CustomDropdownWithSearch> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> listData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  
            Future<List<Map<String, dynamic>>> getPhoneNumberList() async {
    return await SharedPrefCache.listData();
  }

      void reFetchData() async {
          print('refetching');

  listData = await getPhoneNumberList();
            
  }



    RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    reFetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }
  
  Map<String, String> selected = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () => _showItemsList(context),
          child: AbsorbPointer(
            child: Padding(padding: const EdgeInsets.all(0.0),
              child: 

              // final Map<String, String> itemDetails = item.values.first;
              
              TextFormField(
  controller: TextEditingController(
    text: "${selected['name']} - ${selected['number']}" ?? ''),
  style: TextStyle(
    color: Colors.black, // Text color inside the field
  ),
  decoration: InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never, // Keeps the floating label text above the field
    filled: true, // Enables the fillColor property
    fillColor: Color(0xFFC3C3C3), // Background color for the TextFormField
    labelText: widget.itemName,
    labelStyle: TextStyle(
      color: Colors.black, // Color for the label when it is above the TextFormField
    ),
    border: OutlineInputBorder( // Outline border when TextFormField is enabled
      borderSide: BorderSide.none, // No border side
      borderRadius: BorderRadius.circular(5.0), // Rounded corners like the CustomDropdownButton
    ),
    enabledBorder: OutlineInputBorder( // Outline border when TextFormField is enabled and not focused
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(5.0),
    ),
    focusedBorder: OutlineInputBorder( // Outline border when TextFormField is focused
      borderSide: BorderSide(
        color: Colors.black, // Color for the focused border
      ),
      borderRadius: BorderRadius.circular(5.0),
    ),
    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black), // Change to the icon you want
  ),
),

            ),
          ),
    );
  }

  void _showItemsList(BuildContext context) {
  List<Map<String, Map<String, String>>> filteredItems = listData.map((item) {
  Map<String, Map<String, String>> newItem = {};
  item.forEach((key, value) {
    newItem[key] = Map<String, String>.from(value);
  });
  return newItem;
}).toList();
  print('_showItemsList');

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        height: 800,
        color: const Color.fromARGB(255, 31, 33, 38),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
             Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
                            Text(
                              widget.labelText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
const SizedBox(height: 24),
TextFormField(
          cursorColor: Colors.black,
          controller: searchController,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: const Color(0xFFC3C3C3),
            labelStyle: const TextStyle(
              color: Colors.transparent,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          filteredItems = listData.map((item) {
  Map<String, Map<String, String>> newItem = {};
  item.forEach((key, value) {
    newItem[key] = Map<String, String>.from(value);
  });
  return newItem;
}).toList();
                          (context as Element).markNeedsBuild();
                          setState(() {
                            selected = {};
                          });
                        },
                        icon: Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
                        onChanged: (String value) {
filteredItems= listData.map((item) {
  Map<String, Map<String, String>> newItem = {};
  item.forEach((key, value) {
    newItem[key] = Map<String, String>.from(value);
  });
  return newItem;
}).toList();

                (context as Element).markNeedsBuild();
              },
        ),
          
            const SizedBox(height: 8),
            Expanded(
              child:     
              Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
            ListView.builder(
  itemCount: filteredItems.length,
  itemBuilder: (context, index) {
    // Access the item directly, no need for index here
    final Map<String, Map<String, String>> item = filteredItems[index];
    // Get the inner map containing name and number
    final Map<String, String> itemDetails = item.values.first;
    
    return ListTile(
      title: Text(
        "${itemDetails['name']} - ${itemDetails['number']}",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          searchController.text = '';
          selected = itemDetails; // Consider using itemDetails instead if you only need name and number
        });
        widget.onSelected!(itemDetails['number']!);
      },
    );
  },
),
            ),
            ),
            // add patient button
            if (widget.isAddNewPatient)
                          Column(
                            children: [
                              SizedBox(
                  height: 24,
),
                            SizedBox(
                  width: double.infinity,
                  child:
          ElevatedButton(
  onPressed: widget.onAddNewPatient,
  style: ElevatedButton.styleFrom(
    // elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
      side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: Text(
    "Add New Phone Number",
  ),
),
),
SizedBox(
                  height: 48,
),
                            ],
                          ),
          ],
        ),
      );
    },
  );
}

}