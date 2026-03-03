import 'package:demo_prc_skynet_tech/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          TextButton(
            onPressed: () => context.read<HomeBloc>().add(HomeClearCart()),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          final grouped = <String, int>{};
          for (final item in state.cartItems) {
            grouped[item.tfvname] = (grouped[item.tfvname] ?? 0) + 1;
          }
          final names = grouped.keys.toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;

              final child = isWide
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 4,
                      ),
                      itemCount: names.length,
                      itemBuilder: (context, index) => _CartTile(
                        name: names[index],
                        quantity: grouped[names[index]] ?? 0,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: names.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) => _CartTile(
                        name: names[index],
                        quantity: grouped[names[index]] ?? 0,
                      ),
                    );

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final String name;
  final int quantity;

  const _CartTile({required this.name, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('Quantity: $quantity'),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            context.read<HomeBloc>().add(
                  HomeRemoveFromCart(productName: name),
                );
          },
        ),
      ),
    );
  }
}
