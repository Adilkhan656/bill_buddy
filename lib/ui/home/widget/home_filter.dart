// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../data/local/database.dart'; // For Tag stream
// import '../../../util/category_style_helper.dart';

// class HomeFilters extends StatefulWidget {
//   final Function(String) onSearchChanged;
//   final Function(DateTime?) onMonthChanged;
//   final Function(String) onCategoryChanged;
//   final DateTime? selectedMonth;
//   final String selectedCategory;

//   const HomeFilters({
//     super.key,
//     required this.onSearchChanged,
//     required this.onMonthChanged,
//     required this.onCategoryChanged,
//     required this.selectedMonth,
//     required this.selectedCategory,
//   });

//   @override
//   State<HomeFilters> createState() => _HomeFiltersState();
// }

// class _HomeFiltersState extends State<HomeFilters> {
//   bool _isSearching = false;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//         children: [
//           // 1. Search / Title Toggle
//           AnimatedCrossFade(
//             firstChild: _buildTitleRow(context),
//             secondChild: _buildSearchBar(context),
//             crossFadeState: _isSearching ? CrossFadeState.showSecond : CrossFadeState.showFirst,
//             duration: const Duration(milliseconds: 300),
//             firstCurve: Curves.easeOut,
//             secondCurve: Curves.easeIn,
//           ),
          
//           const SizedBox(height: 15),

//           // 2. Filters Row (Side by Side)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: _buildListMonthFilter(context)),
//               const SizedBox(width: 16),
//               Expanded(child: _buildCategoryFilter(context)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTitleRow(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text("Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           IconButton(
//             onPressed: () => setState(() => _isSearching = true),
//             icon: const Icon(Icons.search_rounded, size: 24),
//             style: IconButton.styleFrom(backgroundColor: Theme.of(context).cardColor, padding: const EdgeInsets.all(8)),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       child: TextField(
//         controller: _searchController,
//         autofocus: true,
//         onChanged: widget.onSearchChanged,
//         decoration: InputDecoration(
//           hintText: "Search merchant, date...",
//           hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
//           prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
//           suffixIcon: IconButton(
//             icon: const Icon(Icons.close_rounded),
//             onPressed: () {
//               setState(() {
//                 _isSearching = false;
//                 _searchController.clear();
//               });
//               widget.onSearchChanged(""); // Reset search
//             },
//           ),
//           filled: true,
//           fillColor: Theme.of(context).cardColor,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
//           contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
//         ),
//       ),
//     );
//   }

//   Widget _buildListMonthFilter(BuildContext context) {
//     final Color textColor = Theme.of(context).colorScheme.onSurface;
//     final cardColor = Theme.of(context).cardColor;
//     final iconColor = Theme.of(context).colorScheme.onSurface;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final months = <DateTime?>[null];
//     final now = DateTime.now();
//     for (int i = 0; i < 12; i++) {
//       months.add(DateTime(now.year, now.month - i, 1));
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 6),
//           child: Text(
//             "Period",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ),
//         Container(
//           height: 40,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: cardColor,
//             borderRadius: BorderRadius.circular(20), // ✅ RESTORED CURVE
//             border: Border.all(
//               color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//             ),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<DateTime?>(
//               isExpanded: true, // Ensures it fits in the Row
//               menuMaxHeight: 300,
//               borderRadius: BorderRadius.circular(12),
//               value: widget.selectedMonth,
//               isDense: true,
//               icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: iconColor),
//               onChanged: widget.onMonthChanged,
//               items: months.map((m) {
//                 return DropdownMenuItem(
//                   value: m,
//                   child: Text(
//                     m == null ? "All Time" : DateFormat('MMM yyyy').format(m),
//                     style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCategoryFilter(BuildContext context) {
//     final cardColor = Theme.of(context).cardColor;
//     final iconColor = Theme.of(context).colorScheme.onSurface;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 6),
//           child: Text(
//             "Category/Tags",
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ),
//         Container(
//           height: 40,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: cardColor,
//             borderRadius: BorderRadius.circular(20), // ✅ RESTORED CURVE
//             border: Border.all(
//               color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//             ),
//           ),
//           child: StreamBuilder<List<Tag>>(
//             stream: database.watchAllTags(),
//             builder: (_, snap) {
//               final tags = snap.data ?? [];
//               final items = ["All", ...tags.map((e) => e.name)];

//               return DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   isExpanded: true, // Ensures it fits in the Row
//                   menuMaxHeight: 300,
//                   borderRadius: BorderRadius.circular(12),
//                   value: widget.selectedCategory,
//                   isDense: true,
//                   icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: iconColor),
//                   onChanged: (val) => widget.onCategoryChanged(val!),
//                   items: items.map((e) {
//                     return DropdownMenuItem(
//                       value: e,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (e != "All") ...[
//                             CategoryStyleHelper.getTagIcon(e, size: 14),
//                             const SizedBox(width: 8),
//                           ],
//                           Flexible(
//                             child: Text(
//                               e, 
//                               style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/local/database.dart'; // For Tag stream
import '../../../util/category_style_helper.dart';

class HomeFilters extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(DateTime?) onMonthChanged;
  final Function(String) onCategoryChanged;
  final DateTime? selectedMonth;
  final String selectedCategory;

  const HomeFilters({
    super.key,
    required this.onSearchChanged,
    required this.onMonthChanged,
    required this.onCategoryChanged,
    required this.selectedMonth,
    required this.selectedCategory,
  });

  @override
  State<HomeFilters> createState() => _HomeFiltersState();
}

class _HomeFiltersState extends State<HomeFilters> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // 1. Search / Title Toggle
          AnimatedCrossFade(
            firstChild: _buildTitleRow(context),
            secondChild: _buildSearchBar(context),
            crossFadeState: _isSearching ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeIn,
          ),
          
          const SizedBox(height: 15),

          // 2. Filters Row (Side by Side)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildListMonthFilter(context)),
              const SizedBox(width: 16),
              Expanded(child: _buildCategoryFilter(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          IconButton(
            onPressed: () => setState(() => _isSearching = true),
            icon: const Icon(Icons.search_rounded, size: 24),
            style: IconButton.styleFrom(backgroundColor: Theme.of(context).cardColor, padding: const EdgeInsets.all(8)),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: "Search merchant, date...",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
              widget.onSearchChanged(""); // Reset search
            },
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildListMonthFilter(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;
    final iconColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final months = <DateTime?>[null];
    final now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      months.add(DateTime(now.year, now.month - i, 1));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            "Period",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DateTime?>(
              isExpanded: true, 
              menuMaxHeight: 300,
              borderRadius: BorderRadius.circular(12),
              value: widget.selectedMonth,
              isDense: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: iconColor),
              onChanged: widget.onMonthChanged,
              items: months.map((m) {
                return DropdownMenuItem(
                  value: m,
                  // ✅ CONTAINER WITH BOTTOM BORDER (DIVIDER)
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200, 
                          width: 1 // Very thin divider
                        )
                      )
                    ),
                    child: Text(
                      m == null ? "All Time" : DateFormat('MMM yyyy').format(m),
                      style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final iconColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            "Category/Tags",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          child: StreamBuilder<List<Tag>>(
            stream: database.watchAllTags(),
            builder: (_, snap) {
              final tags = snap.data ?? [];
              final items = ["All", ...tags.map((e) => e.name)];

              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  menuMaxHeight: 300,
                  borderRadius: BorderRadius.circular(12),
                  value: widget.selectedCategory,
                  isDense: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: iconColor),
                  onChanged: (val) => widget.onCategoryChanged(val!),
                  items: items.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      // ✅ CONTAINER WITH BOTTOM BORDER (DIVIDER)
                      child: Container(
                         width: double.infinity,
                         alignment: Alignment.centerLeft,
                         decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200, 
                                width: 1
                              )
                            )
                          ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (e != "All") ...[
                              CategoryStyleHelper.getTagIcon(e, size: 14),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Text(
                                e, 
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}