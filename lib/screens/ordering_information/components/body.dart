import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:untitled1/app_provider/utility_provider.dart';
import 'package:untitled1/components/socal_card.dart';
import 'package:untitled1/constants.dart';
import 'package:untitled1/size_config.dart';

import 'ordering_information_form.dart';

class Body extends HookConsumerWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReloading = useState<bool>(false);
    ref.listen<bool>(Utility.isLoading, (previous, next) {
      isReloading.value = next;
    });
    return Stack(
      children: [
        SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                    Text("Thông Tin Đặt Hàng", style: headingStyle),

                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    OrderingInformationForm(),

                    SizedBox(height: getProportionateScreenHeight(20)),
                    Text(
                      'By continuing your confirm that you agree \nwith our Term and Condition',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isReloading.value)
          SizedBox.expand(
            child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
