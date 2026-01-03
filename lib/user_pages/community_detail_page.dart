import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';
import '../services/api_service.dart';
import '../models/community_model.dart';

class CommunityDetailPage extends StatefulWidget {
  final int communityId;

  const CommunityDetailPage({
    super.key,
    required this.communityId,
  });

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  late Future<Community?> _communityFuture;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _communityFuture = ApiService.getCommunityById(widget.communityId);
  }

  void _refreshCommunity() {
    setState(() {
      _communityFuture = ApiService.getCommunityById(widget.communityId);
    });
  }

  void _deleteCommunity(Community community) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Komunitas'),
        content: Text('Yakin ingin menghapus komunitas "${community.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isDeleting = true);

              try {
                final result = await ApiService.deleteCommunity(community.id);
                if (result && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Komunitas berhasil dihapus!')),
                  );
                  Navigator.pop(context);
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menghapus komunitas')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() => _isDeleting = false);
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Komunitas"),
        backgroundColor: Colors.blue,
        actions: const [
          UserDropdownButton(),
        ],
      ),
      body: FutureBuilder<Community?>(
        future: _communityFuture,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshCommunity,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // No data state
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Komunitas tidak ditemukan'),
            );
          }

          final community = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Community name
                Text(
                  community.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Member count
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.group, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        '${community.memberCount ?? 0} Anggota',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Description
                const Text(
                  'Deskripsi:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  community.description ?? 'Tidak ada deskripsi',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Creator info
                if (community.userName != null || community.userEmail != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pembuat Komunitas:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (community.userName != null)
                              Text(
                                'Nama: ${community.userName}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            if (community.userEmail != null)
                              Text(
                                'Email: ${community.userEmail}',
                                style: const TextStyle(fontSize: 14),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),

                // Created date
                if (community.createdAt != null)
                  Text(
                    'Dibuat: ${community.createdAt}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(height: 32),

                // Action buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isDeleting ? null : () => _deleteCommunity(community),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.red,
                    ),
                    child: _isDeleting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Hapus Komunitas',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
