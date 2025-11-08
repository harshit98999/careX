// lib/screens/settings/language_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageSettingsScreen
    extends
        StatefulWidget {
  const LanguageSettingsScreen({
    super.key,
  });
  @override
  State<
    LanguageSettingsScreen
  >
  createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState
    extends
        State<
          LanguageSettingsScreen
        > {
  String _selectedLanguage = 'English';
  final List<
    String
  >
  _languages = [
    'English',
    'Español',
    'Français',
    'Deutsch',
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(
          context,
        ).primaryColor,
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
                        ) => setState(
                          () => _selectedLanguage = value!,
                        ),
                    activeColor: Theme.of(
                      context,
                    ).primaryColor,
                  ),
            );
          },
        ).toList(),
      ),
    );
  }
}
