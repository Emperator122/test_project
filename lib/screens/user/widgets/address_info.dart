import 'package:flutter/material.dart';
import 'package:test_project/network/models/user.dart';

class AddressInfo extends StatelessWidget {
  final Address address;

  const AddressInfo({
    super.key,
    required this.address,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Address',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.map),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(address.addressString),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
