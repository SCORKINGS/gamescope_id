import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../services/news_api_service.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_state.dart';
import '../utils/app_colors.dart';
import '../routes/app_routes.dart';

// Definisi 5 kategori utama portal berita (Top-headlines GNews)
class _Category {
  final String label;
  final String categoryKey;

  const _Category({required this.label, required this.categoryKey});
}

const List<_Category> _categories = [
  _Category(label: 'Technology', categoryKey: 'technology'),
  _Category(label: 'Science', categoryKey: 'science'),
  _Category(label: 'Entertainment', categoryKey: 'entertainment'),
  _Category(label: 'Sports', categoryKey: 'sports'),
  _Category(label: 'Business', categoryKey: 'business'),
];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _service = NewsApiService();

  // Cache Future per kategori: key = label kategori
  final Map<String, Future<List<ArticleModel>>> _topicCache = {};

  int _selectedIndex = 0;

  // Future aktif yang dikirim ke FutureBuilder
  late Future<List<ArticleModel>> _futureArticles;

  @override
  void initState() {
    super.initState();
    // Muat kategori pertama saat halaman dibuka
    _futureArticles = _getOrFetchCategory(0);
  }

  // Ambil Future dari cache atau buat baru jika belum ada
  Future<List<ArticleModel>> _getOrFetchCategory(int index) {
    final key = _categories[index].label;
    if (!_topicCache.containsKey(key)) {
      _topicCache[key] = _service.getTopHeadlines(
        category: _categories[index].categoryKey,
      );
    }
    return _topicCache[key]!;
  }

  void _selectCategory(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
      _futureArticles = _getOrFetchCategory(index);
    });
  }

  Future<void> _onRefresh() async {
    final key = _categories[_selectedIndex].label;
    // Hapus cache kategori aktif agar dibuat ulang
    _topicCache.remove(key);
    final newFuture = _getOrFetchCategory(_selectedIndex);
    setState(() {
      _futureArticles = newFuture;
    });
    // Tunggu request selesai sebelum indicator hilang
    try {
      await newFuture;
    } catch (_) {}
  }

  void _openSearchDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => _SearchDialog(
        controller: controller,
        onSearch: (keyword) {
          Navigator.of(ctx).pop();
          Get.toNamed(AppRoutes.search, arguments: keyword);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryBar(),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.divider,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.accentLime,
              backgroundColor: AppColors.bgElevated,
              child: FutureBuilder<List<ArticleModel>>(
                future: _futureArticles,
                builder: _buildBody,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgSurface,
      elevation: 0,
      title: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Game',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextSpan(
              text: 'Scope',
              style: TextStyle(
                color: AppColors.accentLime,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextSpan(
              text: ' ID',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textPrimary),
          tooltip: 'Cari berita',
          onPressed: _openSearchDialog,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final active = _selectedIndex == index;
          return GestureDetector(
            onTap: () => _selectCategory(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: active ? AppColors.chipActive : AppColors.chipInactive,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _categories[index].label,
                style: TextStyle(
                  color: active
                      ? AppColors.chipActiveText
                      : AppColors.chipInactiveText,
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<List<ArticleModel>> snapshot,
  ) {
    // 1. Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentLime),
        ),
      );
    }

    // 2. Error
    if (snapshot.hasError) {
      return ErrorView(
        error: snapshot.error!,
        onRetry: () {
          final key = _categories[_selectedIndex].label;
          _topicCache.remove(key);
          setState(() {
            _futureArticles = _getOrFetchCategory(_selectedIndex);
          });
        },
      );
    }

    // Filter sekunder defensif untuk menjamin tampilan 100% aman dan bebas spam
    final rawArticles = snapshot.data ?? [];
    final articles = NewsApiService.filterAndDeduplicate(rawArticles);

    // 3. Empty
    if (articles.isEmpty) {
      return const EmptyState(
        message: 'Berita tidak ditemukan untuk kategori ini.',
        suggestion:
            'Coba kategori lain atau gunakan pencarian untuk kata kunci spesifik.',
      );
    }

    // 4. Data
    return _buildArticleList(articles);
  }

  Widget _buildArticleList(List<ArticleModel> articles) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: articles.length,
      separatorBuilder: (_, index) {
        // Tidak ada separator setelah featured card (index 0)
        if (index == 0) return const SizedBox.shrink();
        return const Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: AppColors.divider,
        );
      },
      itemBuilder: (context, index) {
        final article = articles[index];
        return ArticleCard(
          article: article,
          featured: index == 0,
          onTap: () => Get.toNamed(AppRoutes.detail, arguments: article),
        );
      },
    );
  }
}

/// Dialog pencarian berita
class _SearchDialog extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearch;

  const _SearchDialog({
    required this.controller,
    required this.onSearch,
  });

  void _submit(BuildContext context) {
    final keyword = controller.text.trim();
    if (keyword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan kata kunci terlebih dahulu.'),
          backgroundColor: AppColors.bgElevated,
        ),
      );
      return;
    }
    onSearch(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text(
        'Cari Berita',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            maxLength: 200,
            style: const TextStyle(color: AppColors.textPrimary),
            cursorColor: AppColors.accentLime,
            decoration: InputDecoration(
              hintText: 'Contoh: AI, Robotik, Gadget, Startup...',
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              counterStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.bgElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: AppColors.accentLime),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onSubmitted: (_) => _submit(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Batal',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () => _submit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentLime,
            foregroundColor: AppColors.textOnAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            'Cari',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
