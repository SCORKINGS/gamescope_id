import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/news_api_service.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';
import '../widgets/empty_state.dart';
import '../utils/app_colors.dart';
import '../routes/app_routes.dart';
import 'package:get/get.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _service = NewsApiService();

  // Cache pencarian agar keyword yang sama tidak request ulang
  final Map<String, Future<List<ArticleModel>>> _searchCache = {};

  late final String _keyword;

  // Future disimpan di State, bukan dibuat di build()
  late Future<List<ArticleModel>> _futureArticles;

  @override
  void initState() {
    super.initState();
    // Ambil keyword dari Get.arguments
    _keyword = (Get.arguments as String?) ?? '';
    _futureArticles = _getOrSearch(_keyword);
  }

  Future<List<ArticleModel>> _getOrSearch(String keyword) {
    if (!_searchCache.containsKey(keyword)) {
      _searchCache[keyword] = _service.searchNews(keyword);
    }
    return _searchCache[keyword]!;
  }

  Future<void> _onRefresh() async {
    _searchCache.remove(_keyword);
    final newFuture = _getOrSearch(_keyword);
    setState(() {
      _futureArticles = newFuture;
    });
    try {
      await newFuture;
    } catch (_) {}
  }

  void _retry() {
    _searchCache.remove(_keyword);
    setState(() {
      _futureArticles = _getOrSearch(_keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hasil Pencarian',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              _keyword,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.accentLime,
        backgroundColor: AppColors.bgElevated,
        child: FutureBuilder<List<ArticleModel>>(
          future: _futureArticles,
          builder: _buildBody,
        ),
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
        onRetry: _retry,
      );
    }

    // Filter sekunder defensif untuk menjamin tampilan hasil pencarian 100% aman
    final rawArticles = snapshot.data ?? [];
    final articles = NewsApiService.filterAndDeduplicate(rawArticles);

    // 3. Empty
    if (articles.isEmpty) {
      return ListView(
        // ListView agar pull-to-refresh tetap bisa dipakai saat empty
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: EmptyState(
              message: 'Tidak ada berita untuk "$_keyword".',
              suggestion: 'Coba kata kunci lain atau periksa ejaan.',
            ),
          ),
        ],
      );
    }

    // 4. Data
    final count = articles.length;
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: count + 1, // +1 untuk header jumlah hasil
      separatorBuilder: (_, index) {
        if (index == 0) return const SizedBox.shrink();
        return const Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: AppColors.divider,
        );
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              '$count artikel ditemukan',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          );
        }
        final article = articles[index - 1];
        return ArticleCard(
          article: article,
          onTap: () => Get.toNamed(AppRoutes.detail, arguments: article),
        );
      },
    );
  }
}
