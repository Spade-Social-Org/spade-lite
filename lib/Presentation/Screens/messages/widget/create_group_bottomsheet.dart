import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/resources/resources.dart';

class CreateGroupBottomsheet extends ConsumerStatefulWidget {
  const CreateGroupBottomsheet({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateGroupBottomsheetState();
}

class _CreateGroupBottomsheetState
    extends ConsumerState<CreateGroupBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.black,
      ),
      child: Column(
        children: [
          10.spacingH,
          Container(
            width: 107,
            height: 6,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ).alignCenter,
          70.spacingH,
          SizedBox(
            height: (80 * 4) + (16 * 3),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                    children: List.generate(
                      20,
                      (index) => Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(SpiderImageAssets.avatar),
                          ),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            width: 3,
                            color: const Color(0xffD9D9D9),
                          ),
                        ),
                      ).pOnly(r: 16),
                    ),
                  ).pOnly(l: 80 + 16),
                  16.spacingH,
                  Row(
                    children: List.generate(
                      20,
                      (index) => Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(SpiderImageAssets.avatar),
                          ),
                          border: Border.all(
                            width: 3,
                            color: const Color(0xffD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ).pOnly(r: 16),
                    ),
                  ),
                  16.spacingH,
                  Row(
                    children: List.generate(
                      20,
                      (index) => Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(SpiderImageAssets.avatar),
                          ),
                          border: Border.all(
                            width: 3,
                            color: const Color(0xffD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ).pOnly(r: 16),
                    ),
                  ).pOnly(l: 80 + 16),
                  16.spacingH,
                  Row(
                    children: List.generate(
                      20,
                      (index) => Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(SpiderImageAssets.avatar),
                          ),
                          border: Border.all(
                            width: 3,
                            color: const Color(0xffD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ).pOnly(r: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          50.spacingH,
          Container(
            width: 174,
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Create Group',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
