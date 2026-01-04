import 'package:flutter/material.dart';
import '../components/user_dropdown.dart';
import '../services/api_service.dart';
import '../models/community_model.dart';
import 'edit_community_page.dart';

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
  bool _isJoined = false;

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

  void _showEditConfirmationDialog(Community community) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Komunitas'),
        content: Text('Yakin ingin edit komunitas "${community.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCommunityPage(community: community),
                ),
              ).then((result) {
                if (result != null) {
                  _refreshCommunity();
                }
              });
            },
            child: const Text('Edit', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(Community community) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Komunitas'),
        content: Text('Yakin ingin menghapus komunitas "${community.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              setState(() => _isDeleting = true);

              try {
                final result = await ApiService.deleteCommunity(community.id);
                if (result && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('✓ Komunitas berhasil dihapus!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  // Tunggu snackbar selesai sebelum pop detail page
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) {
                    Navigator.pop(context);
                  }
                } else if (mounted) {
                  setState(() => _isDeleting = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('✗ Gagal menghapus komunitas'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _isDeleting = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✗ Error: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
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
                // Community header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: Text(
                          community.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        community.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Member count
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.group, color: Colors.blue, size: 28),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Anggota',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${community.memberCount ?? 0} orang',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
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
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    community.description ?? 'Tidak ada deskripsi',
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
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
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(Icons.person, color: Colors.blue),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (community.userName != null)
                                  Text(
                                    community.userName!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if (community.userEmail != null)
                                  Text(
                                    community.userEmail!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isDeleting
                            ? null
                            : () => _showEditConfirmationDialog(community),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isJoined = !_isJoined;
                          });
                          String message = _isJoined ? '✓ Bergabung dengan komunitas!' : '✓ Keluar dari komunitas';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icon(_isJoined ? Icons.check : Icons.add),
                        label: Text(_isJoined ? 'Sudah Bergabung' : 'Gabung'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: _isJoined ? Colors.green : Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isDeleting ? null : () => _showDeleteConfirmationDialog(community),
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus Komunitas'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
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
