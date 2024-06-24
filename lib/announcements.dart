
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'announcements_provider.dart';
import 'common/components/custom_dialog.dart';
import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'common/const/widgets.dart';
import 'list_model.dart';
import 'model.dart';

class Announcements extends ConsumerWidget {
  final String shopDomain;

  const Announcements({
    super.key,
    required this.shopDomain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopAnnouncementsState =
    ref.watch(shopAnnouncementsProvider(shopDomain));
    if (shopAnnouncementsState is ListLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (shopAnnouncementsState is ListError) {
      return Center(
        child: Text(shopAnnouncementsState.data),
      );
    }
    final announcements =
    shopAnnouncementsState as ListModel<ShopAnnouncementsModel>;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.sizeOf(context).width > 500
            ? 500.0
            : MediaQuery.sizeOf(context).width;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: announcements.data.length,
          itemBuilder: (context, index) {
            final announcement = announcements.data[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      width: width,
                      subject: announcement.announcementType.name == 'notice'
                          ? 'NOTICE'
                          : 'EVENT',
                      title: announcement.title,
                      child: Text(
                        announcement.content,
                        style: TextDesign.regular14G,
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: width * 312 / 389,
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                padding: const EdgeInsets.all(16.0),
                decoration: CommonWidgets.commonDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 21,
                          decoration: const BoxDecoration(
                            color: BrandColors.orange,
                          ),
                          child: Center(
                            child: Text(
                              announcement.announcementType.name == 'notice'
                                  ? 'NOTICE'
                                  : 'EVENT',
                              style: TextDesign.bold12W,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            announcement.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextDesign.bold16B,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: Text(
                        announcement.content,
                        style: TextDesign.regular14G,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
