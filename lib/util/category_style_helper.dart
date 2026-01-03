import 'package:flutter/material.dart';

class CategoryStyleHelper {
  
  static Widget getTagIcon(String category, {double size = 24}) {
    // 1. Get the correct filename for the category
    String filename = _getFilenameForCategory(category);
    
    return Image.asset(
      'assets/icon/$filename',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback if image fails loading
        return Icon(Icons.category, size: size, color: Colors.grey.shade400);
      },
    );
  }

  // ✅ MAP CATEGORIES TO YOUR SPECIFIC FILENAMES
  static String _getFilenameForCategory(String category) {
    // Normalize string (trim spaces, make lowercase)
    final key = category.trim().toLowerCase();

    switch (key) {
      case 'food':
      case 'dining':
        return 'fast-food.png'; // Matches your "fast-food.png"
      
      case 'grocery':
      case 'groceries':
        return 'vegetables.png'; // Matches your "vegetables.png"
      
      case 'electronics':
      case 'gadgets':
        return 'electronic.png'; // Matches your "electronic.png"
        
      case 'electric bill':
      case 'electricity':
        return 'electric_bill.png'; // Matches your "electric_bill.png"
        
      case 'general':
      case 'other':
        return 'genral.png'; // Matches your misspelled "genral.png"
        
      case 'medical':
      case 'health':
        return 'medicine.png'; // Matches your "medicine.png"
        
      case 'personal':
      case 'profile':
        return 'user.png'; // Matches your "user.png"
        
      case 'entertainment':
      case 'movie':
      case 'cinema':
        return 'cinema.png'; // Matches your "cinema.png"
        
      case 'pets':
      case 'pet':
        return 'pet.png'; // Matches your "pet.png"

      case 'house':
      case 'maintenance':
        return 'house.png'; // Matches your "house.png"

      // These usually match directly, but good to be explicit
      case 'education': return 'education.png';
      case 'fuel': return 'fuel.png';
      case 'gym': return 'gym.png';
      case 'investment': return 'investment.png';
      case 'office': return 'office.png';
      case 'rent': return 'rent.png';
      case 'salary': return 'salary.png';
      case 'shopping': return 'shopping.png';
      case 'travel': return 'travel.png';

      // Default fallback
      default: return 'genral.png'; 
    }
  }
}