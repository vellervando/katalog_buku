import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';

// 1. Provider Identitas Mahasiswa (Ganti dengan Nama & NPM Anda)
final nameProvider = Provider<String>((ref) => 'Velka Ervando N Y');
final npmProvider = Provider<String>((ref) => '085024001');

// 2. Provider Daftar Buku
final booksProvider = Provider<List<Book>>((ref) {
  return const [
    Book(
      id: 'b1',
      title: 'Filosofi Teras',
      author: 'Henry Manampiring',
      year: 2018,
      description:
          'Buku pengantar filsafat Stoa yang relevan untuk mengatasi emosi negatif dan membangun mental tangguh di era modern.',
    ),
    Book(
      id: 'b2',
      title: 'Clean Code',
      author: 'Robert C. Martin',
      year: 2008,
      description:
          'Panduan praktis menulis kode perangkat lunak yang bersih, mudah dibaca, dan mudah dipelihara oleh tim pengembang.',
    ),
    Book(
      id: 'b3',
      title: 'Laskar Pelangi',
      author: 'Andrea Hirata',
      year: 2005,
      description: null, // Contoh buku tanpa deskripsi
    ),
    Book(
      id: 'b4',
      title: 'Atomic Habits',
      author: 'James Clear',
      year: 2018,
      description:
          'Perubahan kecil yang memberikan hasil luar biasa melalui pembentukan sistem kebiasaan harian yang konsisten.',
    ),
  ];
});

// 3. Info Provider (Menggabungkan data identitas dan jumlah buku)
final infoProvider = Provider<String>((ref) {
  final nama = ref.watch(nameProvider);
  final npm = ref.watch(npmProvider);
  final totalBuku = ref.watch(booksProvider).length;

  return '$nama ($npm) • Total Koleksi: $totalBuku Buku';
});

// 4. Notifier untuk mengelola ID buku yang deskripsinya ditampilkan
class ExpandedBookIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }
}

final expandedBookIdsProvider =
    NotifierProvider<ExpandedBookIdsNotifier, Set<String>>(
  ExpandedBookIdsNotifier.new,
);