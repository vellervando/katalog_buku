import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../providers/book_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(nameProvider);
    final npm = ref.watch(npmProvider);
    final books = ref.watch(booksProvider);
    final infoSummary = ref.watch(infoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Buku Pribadi'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsif: Menentukan jumlah kolom berdasarkan lebar layar
          final isWideScreen = constraints.maxWidth >= 650;
          final crossAxisCount = constraints.maxWidth >= 1000 ? 3 : 2;

          return CustomScrollView(
            slivers: [
              // Bagian Header Identitas & Jumlah Buku
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text('NPM: $npm', style: Theme.of(context).textTheme.bodyMedium),
                          const Divider(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.menu_book, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  infoSummary,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bagian Daftar Buku (Responsif List vs Grid)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: isWideScreen
                    ? SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 230,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => BookItemCard(book: books[index]),
                          childCount: books.length,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: BookItemCard(book: books[index]),
                          ),
                          childCount: books.length,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BookItemCard extends ConsumerWidget {
  final Book book;

  const BookItemCard({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedIds = ref.watch(expandedBookIdsProvider);
    final isExpanded = expandedIds.contains(book.id);
    final hasDescription = book.description != null && book.description!.trim().isNotEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${book.author} • ${book.year}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Tombol Interaksi Tampil / Sembunyikan Deskripsi
                // Tombol Interaksi Tampil / Sembunyikan Deskripsi
                TextButton.icon(
                  onPressed: () {
                    ref.read(expandedBookIdsProvider.notifier).toggle(book.id);
                  },
                  // Implicit Animation 1: Rotasi ikon panah
                  icon: AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.expand_more),
                  ),
                  label: Text(isExpanded ? 'Sembunyikan' : 'Deskripsi'),
                ),
              ],
            ),

            // Implicit Animation 2: Perubahan ukuran kontainer deskripsi secara halus
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hasDescription
                              ? book.description!
                              : 'Tidak ada deskripsi untuk buku ini.',
                          style: TextStyle(
                            fontStyle: hasDescription ? FontStyle.normal : FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}