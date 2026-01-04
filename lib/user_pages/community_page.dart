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
  bool _isGridView = true;

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

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isGridView ? '⊞ Grid View' : '☰ List View'),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Komunitas"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCommunities,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: _toggleView,
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
          const UserDropdownButton(),
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
            child: _isGridView
                ? _buildGridView(communities)
                : _buildListView(communities),
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

  Widget _buildListView(List<Community> communities) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: communities.length,
      itemBuilder: (context, index) {
        final community = communities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(community.name[0].toUpperCase()),
            ),
            title: Text(
              community.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              community.description ?? 'Tidak ada deskripsi',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              '${community.memberCount ?? 0}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
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
    );
  }

  Widget _buildGridView(List<Community> communities) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: communities.length,
      itemBuilder: (context, index) {
        final community = communities[index];
        return Card(
          elevation: 2,
          child: InkWell(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      community.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              community.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              community.description ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.group, size: 14, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(
                              '${community.memberCount ?? 0}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
