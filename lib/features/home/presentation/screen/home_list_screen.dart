import 'package:demo_prc_skynet_tech/core/session/session_manager.dart';
import 'package:demo_prc_skynet_tech/features/auth/presentation/screen/login/login_screen.dart';
import 'package:demo_prc_skynet_tech/features/home/data/repositories/home_repository_im.dart';
import 'package:demo_prc_skynet_tech/features/home/entity/product_model.dart';
import 'package:demo_prc_skynet_tech/features/home/presentation/bloc/home_bloc.dart';
import 'package:demo_prc_skynet_tech/features/home/presentation/screen/product_details_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeListScreen extends StatelessWidget {
  final String userEmail;

  const HomeListScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(HomeRepositoryIm())..add(HomeLoadProducts()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Fruits & Veg - $userEmail'),
              actions: [
                IconButton(
                  onPressed: () async {
                    await SessionManager.clearSession();
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: _HomeBody(state: state),
          );
        },
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final HomeState state;

  const _HomeBody({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.status == HomeStatus.loading ||
        state.status == HomeStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == HomeStatus.error) {
      return Center(child: Text(state.errorMessage));
    }

    if (state.products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;
        final isTablet = width >= 700 && width < 1100;

        final content = isMobile
            ? ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.products.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _ProductCard(item: state.products[index], isGrid: false),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 2 : 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isTablet ? 1.08 : 0.98,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) =>
                    _ProductCard(item: state.products[index], isGrid: true),
              );

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: content,
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductItem item;
  final bool isGrid;

  const _ProductCard({required this.item, required this.isGrid});

  @override
  Widget build(BuildContext context) {
    final imageAspect = isGrid ? 16 / 10 : 16 / 9;
    final imageUrl = (item.imageurl);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ProductDetailsScreen(product: item),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: imageAspect,
              child: imageUrl.isEmpty
                  ? const ColoredBox(
                      color: Color(0xFFE6E8FF),
                      child: Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    )
                  : Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) => ColoredBox(
                        color: Color(0xFFE6E8FF),
                        child: Center(
                          child: Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.tfvname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.botname,
                    style: const TextStyle(color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
