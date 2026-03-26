import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_hand_electronics_marketplace/core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/widgets/custom_tab_controller.dart';
import '../../../../../../core/widgets/faq_tile_widget.dart';
import '../../../bloc/settings_screen_bloc/help_center_bloc/help_center_bloc.dart';
import '../../../bloc/settings_screen_bloc/help_center_bloc/help_center_event.dart';
import '../../../bloc/settings_screen_bloc/help_center_bloc/help_center_state.dart';
import '../../../widgets/settings_widgets/help_center_contact_item.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HelpCenterBloc()..add(LoadHelpCenter()),
      child: BlocBuilder<HelpCenterBloc, HelpCenterState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Help center')),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
              ),
              child: CustomTabController(
                length: 2,
                tabs: const [Tab(text: 'FAQ'), Tab(text: 'Contact us')],
                children: [
                  // ---------------- FAQ Tab ----------------
                  ListView(
                    children: [
                      FAQWidget(
                        title: 'What is this app?',
                        description:
                            'This app is a marketplace for buying and selling used electronics. It allows users to list their devices, connect with nearby buyers or sellers, and communicate directly through in-app chat to agree on deals safely and easily.',
                      ),
                      FAQWidget(
                        title: 'How does it work?',
                        description:
                            'You can post your listings and communicate with buyers directly through chat.',
                      ),
                      FAQWidget(
                        title: 'How do I post a listing?',
                        description:
                            'Go to the “Post” section, fill in your item details and submit.',
                      ),
                      FAQWidget(
                        title: 'How can I contact a seller?',
                        description:
                            'Use the in-app chat to message the seller directly.',
                      ),
                      FAQWidget(
                        title: 'What should I do if I face a problem?',
                        description:
                            'Contact our support team via the Contact us tab.',
                      ),
                    ],
                  ),

                  // ---------------- Contact Us Tab ----------------
                  ListView(
                    children: [
                      HelpCenterContactItem(
                        svgPath: AppAssets.customerServiceSvg,
                        title: 'Customer Service',
                        onTap: () {},
                        context: context,
                      ),
                      HelpCenterContactItem(
                        title: 'Facebook',
                        onTap: () {
                          context.read<HelpCenterBloc>().add(
                            const TapContactItem('facebook'),
                          );
                        },
                        svgPath: AppAssets.facebookHelpIconSvg,
                        context: context,
                      ),
                      HelpCenterContactItem(
                        svgPath: AppAssets.globelHelpIconSvg,
                        context: context,
                        title: 'Website',
                        onTap: () {},
                      ),
                      HelpCenterContactItem(
                        svgPath: AppAssets.instagramHelpIconSvg,
                        context: context,
                        title: 'Instagram',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
