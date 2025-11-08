// lib/screens/settings/language_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageScreen
    extends
        StatefulWidget {
  const LanguageScreen({
    super.key,
  });

  @override
  State<
    LanguageScreen
  >
  createState() => _LanguageScreenState();
}

class _LanguageScreenState
    extends
        State<
          LanguageScreen
        > {
  String _selectedLanguage = 'English';
  final List<
    String
  >
  _languages = [
    'English',
    'Spanish',
    'French',
    'German',
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Language",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(
          context,
        ).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          8.0,
        ),
        children: _languages.map(
          (
            language,
          ) {
            return Card(
              elevation: 1.0,
              shadowColor: Colors.black.withOpacity(
                0.08,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child:
                  RadioListTile<
                    String
                  >(
                    title: Text(
                      language,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    value: language,
                    groupValue: _selectedLanguage,
                    onChanged:
                        (
                          String? value,
                        ) {
                          setState(
                            () {
                              _selectedLanguage = value!;
                            },
                          );
                        },
                    activeColor: Theme.of(
                      context,
                    ).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
            );
          },
        ).toList(),
      ),
    );
  }
}
