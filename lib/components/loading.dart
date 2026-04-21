import 'package:flutter/material.dart';

Widget loader() => const SizedBox(
      height: 400,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
