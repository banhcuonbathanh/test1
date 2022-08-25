import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled1/app_provider/state_provider.dart';
import 'package:untitled1/app_provider/utility_provider.dart';
import 'package:untitled1/components/custom_buttom.dart';
import 'package:untitled1/components/custom_container.dart';
import 'package:untitled1/constants.dart';
import 'package:untitled1/model/productdetail_model.dart';
import 'package:untitled1/model/topping_model.dart';
import 'package:untitled1/size_config.dart';

import 'topping_with_inform_home.dart';

class ProductDetailOneHome extends HookConsumerWidget {
  const ProductDetailOneHome({
    required this.restart,
    required this.productId,
    Key? key,
    required this.ProductDetailData,
  }) : super(key: key);

  final ProductDetailModel ProductDetailData;

  final String productId;
  final Function restart;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countConsitionForAnimation = useState<int>(0);
    // print('ProductDetailOneHome');
    // final listCartItem = ref.watch(CartItemNotifierProvider);
    final user = ref.watch(AppStateProvider.userNotifier);
    bool isFavorite = false;
    for (final String i in user!.favouriteProductDetails!) {
      if (ProductDetailData.productdetaiId == i) {
        isFavorite = true;
      }
    }
    final allToppings =
        ref.watch(AppStateProvider.toppingEditMapNotifier).values.toList();
    final toppingsProductdetail = allToppings
        .where(((element) =>
            element.productDetailId == ProductDetailData.productdetaiId))
        .toList();
    final isShowTopping = useState(true);
    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenHeight(20)),
      child: CustomContainer(
        bottompadding: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Picture(ProductDetailData: ProductDetailData),
                  SizedBox(
                    width: getProportionateScreenWidth(10),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Text(ProductDetailData.productdetaitName!),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Text('Thanh Phan'),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      FavoriteButton(
                        iconColor: Colors.blue,
                        isFavorite: isFavorite,
                        iconSize: 13,
                        // iconDisabledColor: Colors.white,
                        valueChanged: (_isFavorite) {
                          if (_isFavorite == true) {
                            // print('this true');
                            ref
                                .read(AppStateProvider.userNotifier.notifier)
                                .addFavouriteProductDetails(
                                    productDetailId:
                                        ProductDetailData.productdetaiId!);
                            ProductDetailData.productdetaiIsFavourite;
                          }
                          if (_isFavorite == false) {
                            // print('this false');
                            ref
                                .read(AppStateProvider.userNotifier.notifier)
                                .removeFavouriteProductDetails(
                                    productDetailId:
                                        ProductDetailData.productdetaiId!);
                            ProductDetailData.productdetaiIsFavourite;
                          }
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Text(ProductDetailData.productdetaiPrice!.toString()),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Text(ProductDetailData.productdetailBill.toString()),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Row(
                        children: [
                          AddButton(
                            restart: restart,
                            ProductDetailData: ProductDetailData,
                            productId: productId,
                            ref: ref,
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(10),
                          ),
                          Text(ProductDetailData.productdetailQuantity
                              .toString()),
                          SizedBox(
                            width: getProportionateScreenWidth(10),
                          ),
                          RemoveButton(
                            restart: restart,
                            ProductDetailData: ProductDetailData,
                            ref: ref,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              CustomerButton(
                backgoundColor: null,
                BorderRadiuscircular: 10,
                buttonHeight: getProportionateScreenHeight(30),
                buttonWidth: double.infinity,
                press: () {
                  isShowTopping.value = !isShowTopping.value;
                },
                text: 'Tuỳ Chọn',
              ),
              if (isShowTopping.value)
                for (var index = 0;
                    index < toppingsProductdetail.length;
                    index++)
                  ToppingWithInformHome(
                    toppingModel: toppingsProductdetail.elementAt(index),
                    restartFunc: () {},
                  ),

              // ToppingWithInformHome(
              //   restartFunc: () {}, toppingModel: null,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class Picture extends StatelessWidget {
  const Picture({
    Key? key,
    required this.ProductDetailData,
  }) : super(key: key);

  final ProductDetailModel ProductDetailData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(110),
      height: getProportionateScreenHeight(110),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          ProductDetailData.productdetaiImage!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class RemoveButton extends StatelessWidget {
  const RemoveButton({
    Key? key,
    required this.ProductDetailData,
    required this.ref,
    required this.restart,
  }) : super(key: key);

  final ProductDetailModel ProductDetailData;
  final WidgetRef ref;
  final Function restart;
  @override
  Widget build(BuildContext context) {
    return CustomerButton(
      backgoundColor: kPrimaryColor,
      BorderRadiuscircular: 8,
      buttonHeight: getProportionateScreenHeight(20),
      buttonWidth: getProportionateScreenWidth(30),
      press: () async {
        ref.read(Utility.showAnimationForBuying1.notifier).minusOne();
        restart();
        ref
            .read(AppStateProvider.productdetailMapNotifier.notifier)
            .editProductDetailRemove(
              productdetaiId: ProductDetailData.productdetaiId!,
              productId: ProductDetailData.productId!,
            );
        // ref
        //     .read(productDetailNotifierProvider.notifier)
        //     .editProductDetailRemove(
        //         productdetaiId: ProductDetailData.productdetaiId,
        //         productdetaiPrice: ProductDetailData.productdetaiPrice,
        //         productdetailQuantity:
        //             ProductDetailData.productdetailQuantity!);
      },
      text: '+',
      child: Icon(
        Icons.remove,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
    required this.ProductDetailData,
    required this.productId,
    required this.ref,
    required this.restart,
  }) : super(key: key);

  final ProductDetailModel ProductDetailData;
  final String productId;
  final WidgetRef ref;
  final Function restart;
  @override
  Widget build(BuildContext context) {
    return CustomerButton(
      backgoundColor: kPrimaryColor,
      BorderRadiuscircular: 8,
      buttonHeight: getProportionateScreenHeight(20),
      buttonWidth: getProportionateScreenWidth(30),
      press: () {
        ref.read(Utility.showAnimationForBuying1.notifier).addOne();
        // ref.read(CartItemNotifierProvider.notifier).addItem(
        //         cartItem: CartItemModel(
        //       cartdetaiIsFavourite: null,
        //       cartdetaiIsPopular: null,
        //       cartdetailBill: null,
        //       cartdetailQuantity: 1,
        //       cartdetaiPrice: ProductDetailData.productdetaiPrice,
        //       cartdetaiRating: ProductDetailData.productdetaiRating,
        //       cartitemDescription: ProductDetailData.productdetaiDescription,
        //       cartitemiId: '',
        //       cartitemImage: ProductDetailData.productdetaiImage,
        //       cartitemName: ProductDetailData.productdetaitName,
        //       productdetailId: ProductDetailData.productdetaiId,
        //       productdetailIdList: ProductDetailData.productdetailIdList,
        //       productId: ProductDetailData.productId,
        //       productName: ProductDetailData.productName,
        //       restaurantId: ProductDetailData.restaurantId,
        //       restaurantName: ProductDetailData.restaurantName,
        //     ));

        // ------------------
        // ref
        //     .read(productDetailNotifierProvider.notifier)
        //     .editProductDetailAdd(
        //         productdetaiId:
        //             ProductDetailData.productdetaiId,
        //         productdetaiPrice:
        //             ProductDetailData.productdetaiPrice,
        //         productdetailQuantity:
        //             ProductDetailData.productdetailQuantity!);
// -----------------------------
        ref
            .read(AppStateProvider.productdetailMapNotifier.notifier)
            .editProductDetailAdd(
              productdetaiId: ProductDetailData.productdetaiId!,
              productId: productId,
            );
        restart();
        // ------------------
        // await ref
        //     .read(DataNotifierProvider.productdetailTest.notifier)
        //     .searchingProductDetailWithProductId(
        //         searchingKey: ProductDetailData.productId!);
      },
      text: '',
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

//   TextButton(
//                           onPressed: () async {
//                             // ref.read(EditProductProvider.notifier).changetoState();
//                             // xoa san pham
//                             // ref
//                             //     .read(EditProductProvider.notifier)
//                             //     .changetoState();

//                             await ref
//                                 .read(DataNotifierProvider
//                                     .productdetailTest.notifier)
//                                 .deleteProductDetailWithId(
//                                     productdetaiId:
//                                         ProductDetailData.productdetaiId!,
//                                     productId: ProductDetailData.productId!);
//                             // await ref
//                             //     .read(productDetailNotifierProvider.notifier)
//                             //     .deleteProductDetailWithId(
//                             //         productdetaiId:
//                             //             ProductDetailData.productdetaiId!,
//                             //         productId: ProductDetailData.productId!);
//                             // Navigator.of(context).pop();
//                             await ref
//                                 .read(productDetailNotifierProvider.notifier)
//                                 .searchingProductDetailproductId(
//                                     searchingKey: ProductDetailData.productId!);

//                             // await ref
//                             //     .read(productNotifierProvider.notifier)
//                             //     .deleteProduct(
//                             //         productId: serverProductId,
//                             //         restaurantId: serverRestaurantId);
//                             // final restaruatdata = await ref
//                             //     .read(restaurantsNotifierProvider.notifier)
//                             //     .searchRestaurantsUserId(
//                             //         searchingkey: user!.restaurantId!);
//                             Navigator.of(context).pop();
// // cap nhat thong tin san pham

//                             //        await ref
//                             // .read(restaurantsNotifierProvider.notifier)
//                             // .searchUserSId(userId: restaurantData.userId!);
//                           },
//                           child: Text("Đồng Ý"),
//                         ),
