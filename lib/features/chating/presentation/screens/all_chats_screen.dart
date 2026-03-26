import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:second_hand_electronics_marketplace/configs/theme/theme_exports.dart';
import 'package:second_hand_electronics_marketplace/core/constants/constants_exports.dart';
import 'package:second_hand_electronics_marketplace/core/widgets/search_widget.dart';
import 'package:second_hand_electronics_marketplace/features/chating/presentation/widget/Component_Chat list item/chat_list_item.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.chats,
          style: AppTypography.h2_20SemiBold.copyWith(
            color: context.colors.titles,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: context.colors.icons,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Simple Search (Without Filter)
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: SearchWidget(
              controller: TextEditingController(),
              onChanged: (value) {},
            ),
          ),

          // Tabs
          const _ChatFilters(),

          // Divider
          Container(color: context.colors.border, height: 1),

          // Chats list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                ChatListItem(
                  name: 'Yara Yaseen',
                  lastMsg: 'Where can we meet?',
                  time: '28m',
                  unread: 0,
                  productName: 'Dell XPS 15',
                  imageUrl: 'https://i.pravatar.cc/150?img=1',
                  isSelected: true,
                  isPinned: true,
                  onTap: () => context.pushNamed(AppRoutes.chating),
                ),
                ChatListItem(
                  name: 'Liam Wang',
                  lastMsg: 'Is it still available?',
                  time: '1hr',
                  unread: 1,
                  productName: 'Canon EOS M50',
                  imageUrl: 'https://i.pravatar.cc/150?img=2',
                  isPinned: false,
                  onTap: () => context.pushNamed(AppRoutes.chating),
                ),
                ChatListItem(
                  name: 'John Doe',
                  lastMsg: 'Hello, how are you?',
                  time: '10:30 AM',
                  unread: 2,
                  productName: 'iPhone 12',
                  imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
                  isSelected: false,
                  isPinned: false,
                  onTap: () => context.pushNamed(AppRoutes.chating),
                ),
                ChatListItem(
                  name: 'Omar Ali',
                  lastMsg: 'We can definitely meet tomorrow',
                  time: '1w',
                  unread: 0,
                  productName: 'Redmi Note 12',
                  imageUrl: 'https://i.pravatar.cc/150?img=3',
                  isPinned: false,
                  onTap: () => context.pushNamed(AppRoutes.chating),
                ),
                ChatListItem(
                  name: 'Mohammed Said',
                  lastMsg: 'I want to know if is it still available?',
                  time: '1w',
                  unread: 0,
                  productName: 'iPhone 13 Pro Max',
                  imageUrl: 'https://i.pravatar.cc/150?img=4',
                  isPinned: false,
                  onTap: () => context.pushNamed(AppRoutes.chating),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatFilters extends StatefulWidget {
  const _ChatFilters();

  @override
  State<_ChatFilters> createState() => _ChatFiltersState();
}

class _ChatFiltersState extends State<_ChatFilters> {
  int _selectedIndex = 0;

  final List<String> _filters = [
    'All',
    'Unread',
    'Buying',
    'Selling',
    'Archived',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            _filters.length,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _selectedIndex == index
                            ? AppColors.mainColor
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _filters[index],
                    style: AppTypography.body14Regular.copyWith(
                      color:
                          _selectedIndex == index
                              ? AppColors.white
                              : AppColors.neutral,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
