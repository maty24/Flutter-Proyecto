import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  //
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductsNotifier(productsRepository: productsRepository);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  //solo lectura para hacer el tipado
  final ProductsRepository productsRepository;

  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    //cuando sea crear, utiliza o se invoca, envio el loadnextpage
    loadNextPage();
  }

  Future loadNextPage() async {
    //pregunto si esta cargando o
    if (state.isLoading || state.isLastPage) return;

    //estamos cargando pra hacer la peticion
    state = state.copyWith(isLoading: true);

    //haciendo la peticion
    final products = await productsRepository.getProductsByPage(
        limit: state.limit, offset: state.offset);

    //si despues de hacer la peticion y viene vacios no hay nada mas
    if (products.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    //despues de hacer la peticion actualizamos el state
    state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
        products: [...state.products, ...products]);
  }
}

class ProductsState {
  //deter el infity scroll
  final bool isLastPage;
  final int limit;
  final int offset;

  //
  final bool isLoading;
  final List<Product> products;

  ProductsState(
      {this.isLastPage = false,
      this.limit = 10,
      this.offset = 0,
      this.isLoading = false,
      this.products = const []});

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
      );
}
