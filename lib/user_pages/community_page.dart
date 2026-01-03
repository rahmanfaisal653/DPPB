import 'package:flutter/material.dart';
import 'community_detail_page.dart';
import 'create_community_page.dart';
import '../components/user_dropdown.dart';
import '../services/api_service.dart';
import '../models/community_model.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late Future<List<Community>> _communitiesFuture;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  void _loadCommunities() {
    _communitiesFuture = ApiService.getAllCommunities();
  }

  void _refreshCommunities() {
    setState(() {
      _loadCommunities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Komunitas"),
        backgroundColor: Colors.blue,
        actions: const [
          UserDropdownButton(),
        ],
      ),
      body: FutureBuilder<List<Community>>(
        future: _communitiesFuture,
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
                    onPressed: _refreshCommunities,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // No data state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_open, size: 50, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Tidak ada komunitas'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshCommunities,
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          // Success state
          final communities = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _refreshCommunities();
              await _communitiesFuture;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      community.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      community.description ?? 'Tidak ada deskripsi',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      '${community.memberCount ?? 0} org',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommunityDetailPage(
                            communityId: community.id,
                          ),
                        ),
                      ).then((_) => _refreshCommunities());
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 28),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateCommunityPage(),
            ),
          );

          if (result != null) {
            _refreshCommunities();
          }
        },
      ),
    );
  }
}
