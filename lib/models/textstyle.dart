import 'package:flutter/material.dart';

dynamic textInputDecoration = InputDecoration(
  labelStyle: const TextStyle(
    color: Colors.black,
  ),
  fillColor: Colors.black,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(width: 1, color: Colors.black),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(width: 1, color: Colors.black),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: const BorderSide(),
  ),
);
