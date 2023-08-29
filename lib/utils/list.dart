import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: '', child: Text('Select addiction')),
    const DropdownMenuItem(
        value: 'My addiction (other)', child: Text('My addiction (other)')),
    const DropdownMenuItem(value: 'Self-harm', child: Text('Self-harm')),
    const DropdownMenuItem(value: 'Coffee', child: Text('Coffee')),
    const DropdownMenuItem(
        value: 'Energy Drinks', child: Text('Energy Drinks')),
    const DropdownMenuItem(value: 'Smoking', child: Text('Smoking')),
    const DropdownMenuItem(value: 'Meds', child: Text('Meds')),
    const DropdownMenuItem(value: 'Pills', child: Text('Pills')),
    const DropdownMenuItem(value: 'Weed', child: Text('Weed')),
    const DropdownMenuItem(
        value: 'Other drugs...', child: Text('Other drugs...')),
    const DropdownMenuItem(value: 'Television', child: Text('Television')),
    const DropdownMenuItem(value: 'Video Games', child: Text('Video Games')),
    const DropdownMenuItem(value: 'Porn', child: Text('Porn')),
    const DropdownMenuItem(value: 'Facebook', child: Text('Facebook')),
    const DropdownMenuItem(value: 'Instagram', child: Text('Instagram')),
    const DropdownMenuItem(value: 'YouTube', child: Text('YouTube')),
    const DropdownMenuItem(value: 'TikTok', child: Text('TikTok')),
    const DropdownMenuItem(value: 'Meat', child: Text('Meat')),
    const DropdownMenuItem(value: 'Sugar', child: Text('Sugar')),
  ];
  return menuItems;
}
