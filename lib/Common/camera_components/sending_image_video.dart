import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/resources/resources.dart';
import '../theme.dart';

class SendingImageVideoBottomRowWidget extends StatelessWidget {
  final Function(bool) onStoryChanged;
  final bool isFeed;
  const SendingImageVideoBottomRowWidget({
    super.key,
    required this.onSendButtonTaped,
    required this.onStoryChanged,
    required this.isFeed,
  });

  final VoidCallback onSendButtonTaped;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.black.withOpacity(0.699999988079071),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
      ),
      child: Row(
        children: [
          16.spacingW,
          FeedButton(
            isSelected: isFeed,
            onTap: () {
              onStoryChanged(true);
            },
            icon: SvgPicture.asset(SpiderSvgAssets.upload),
            text: 'Feed',
          ),
          16.spacingW,
          FeedButton(
            isSelected: !isFeed,
            onTap: () {
              onStoryChanged(false);
            },
            icon: SvgPicture.asset(SpiderSvgAssets.storyPlus),
            text: 'Story',
          ),
          const Spacer(),
          InkWell(
            onTap: onSendButtonTaped,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: ShapeDecoration(
                color: const Color(0xFF202020),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Next',
                    style: CustomTextStyle.large16.w700.white,
                  ),
                  5.spacingW,
                  SvgPicture.asset(SpiderSvgAssets.next)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FeedButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget icon;
  final String text;
  const FeedButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: ShapeDecoration(
          color: Color(isSelected ? 0xFF353535 : 0xFF202020),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            5.spacingW,
            Text(
              text,
              style: CustomTextStyle.small12.w500.white,
            )
          ],
        ),
      ),
    );
  }
}
