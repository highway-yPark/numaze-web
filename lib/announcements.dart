import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/const/colors.dart';
import 'common/const/icons.dart';
import 'common/const/text.dart';
import 'common/const/widgets.dart';
import 'components/custom_dialog.dart';
import 'model/model.dart';

class Announcements extends ConsumerWidget {
  final List<ShopAnnouncementsModel> announcements;
  final String shopDomain;

  const Announcements({
    super.key,
    required this.announcements,
    required this.shopDomain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final shopAnnouncementsState =
    //     ref.watch(shopAnnouncementsProvider(shopDomain));
    // if (shopAnnouncementsState is ListLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    //
    // if (shopAnnouncementsState is ListError) {
    //   return Center(
    //     child: Text(shopAnnouncementsState.data),
    //   );
    // }
    // final announcements =
    //     shopAnnouncementsState as ListModel<ShopAnnouncementsModel>;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.sizeOf(context).width > 500
            ? 500.0
            : MediaQuery.sizeOf(context).width;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
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
                      content: announcement.content,
                    );
                  },
                );
              },
              child: Container(
                width: width * 312 / 389,
                // height: 500,
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                padding: const EdgeInsets.all(16),
                decoration: CommonWidgets.commonDecoration(),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 64,
                                height: 21,
                                color: BrandColors.pink,
                                child: Center(
                                  child: Text(
                                    announcement.announcementType.name ==
                                            'notice'
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
                                  style: TextDesign.bold14B,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Expanded(
                            child: Text(
                              announcement.content,
                              style: TextDesign.regular12G,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    CommonIcons.rightArrow(),
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
