import 'package:flutter/material.dart';

class CategoryIconHelper {
  static IconData getIcon(String category) {
    switch (category.toLowerCase().trim()) {
      case 'food':
      case 'dining':
      case 'restaurant':
        return Icons.restaurant_rounded;
      
      case 'groceries':
      case 'grocery':
      case 'supermarket':
        return Icons.shopping_cart_rounded;
        
      case 'fuel':
      case 'gas':
      case 'transport':
        return Icons.local_gas_station_rounded;
        
      case 'bill payments':
      case 'bills':
      case 'electric bill':
        return Icons.receipt_long_rounded;
        
      case 'money transfer':
      case 'transfer':
        return Icons.currency_exchange_rounded;
        
      case 'shopping':
      case 'electronics':
        return Icons.shopping_bag_rounded;
        
      case 'entertainment':
      case 'movie':
        return Icons.movie_rounded;
        
      case 'health':
      case 'medical':
        return Icons.medical_services_rounded;

      default:
        return Icons.category_rounded; // Default icon
    }
  }

  static Color getColor(String category) {
    // Optional: Returns a specific color for the icon background if needed
    // For now, we return a generic pleasant color or you can randomize
    return const Color(0xFFF3F4F6); // Light Grey background for the icon container
  }
}