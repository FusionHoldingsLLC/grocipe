import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/ui/provider/grocery_provider/order_provider.dart';

final sortOptionProvider = StateProvider<String>((ref) => 'By Aisle');

class SortBottomSheet extends ConsumerWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderNotifier = ref.read(orderProvider.notifier);
    final selectedSortOption = ref.watch(sortOptionProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Sort Options',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('By Name'),
                  trailing: Radio<String>(
                    value: 'By Name',
                    groupValue: selectedSortOption,
                    onChanged: (value) {
                      ref.read(sortOptionProvider.notifier).state = value!;
                    },
                  ),
                  onTap: () {
                    ref.read(sortOptionProvider.notifier).state = 'By Name';
                  },
                ),
                ListTile(
                  title: const Text('By Aisle'),
                  trailing: Radio<String>(
                    value: 'By Aisle',
                    groupValue: selectedSortOption,
                    onChanged: (value) {
                      ref.read(sortOptionProvider.notifier).state = value!;
                    },
                  ),
                  onTap: () {
                    ref.read(sortOptionProvider.notifier).state = 'By Aisle';
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Handle "Reset" tap
                    ref.read(sortOptionProvider.notifier).state = 'By Aisle';
                  },
                  child: const Text('Reset'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final sortOption = ref.read(sortOptionProvider);
                    orderNotifier.sortOrders(sortOption);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
