import 'package:flutter/material.dart';
import 'package:test_project/network/models/user.dart';

class CompanyInfo extends StatelessWidget {
  final Company company;

  const CompanyInfo({
    super.key,
    required this.company,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Company',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'NAME',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(company.name),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'BS', // idk wtf
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(company.bs),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'CATCH PHRASE',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    company.catchPhrase,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
