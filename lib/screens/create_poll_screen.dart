import 'package:flutter/material.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key, required this.onCreate});

  final void Function(String title, String question, List<String> options, bool multiChoice, {bool isDraft}) onCreate;

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final titleController = TextEditingController();
  final questionController = TextEditingController();
  final List<TextEditingController> optionControllers = [TextEditingController(), TextEditingController()];
  bool multiChoice = false;

  void addOption() {
    setState(() {
      optionControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Poll')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Poll Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 16),
            const Text('Options:'),
            ...optionControllers.map((c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextField(
                    controller: c,
                    decoration: const InputDecoration(labelText: 'Option'),
                  ),
                )),
            TextButton.icon(
              onPressed: addOption,
              icon: const Icon(Icons.add),
              label: const Text('Add Option'),
            ),
            SwitchListTile(
              value: multiChoice,
              onChanged: (val) => setState(() => multiChoice = val),
              title: const Text('Allow multiple choices'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final options = optionControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList();
                    widget.onCreate(
                      titleController.text,
                      questionController.text,
                      options,
                      multiChoice,
                      isDraft: true,
                    );
                  },
                  child: const Text('Taslak Kaydet'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final options = optionControllers.map((c) => c.text).where((t) => t.isNotEmpty).toList();
                    widget.onCreate(
                      titleController.text,
                      questionController.text,
                      options,
                      multiChoice,
                      isDraft: false,
                    );
                  },
                  child: const Text('Yayınla'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 