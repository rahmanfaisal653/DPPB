import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/community_model.dart';

class EditCommunityPage extends StatefulWidget {
  final Community community;

  const EditCommunityPage({
    super.key,
    required this.community,
  });

  @override
  State<EditCommunityPage> createState() => _EditCommunityPageState();
}

class _EditCommunityPageState extends State<EditCommunityPage> {
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.community.name);
    _deskripsiController = TextEditingController(text: widget.community.description ?? '');
  }

  Future<void> _updateCommunity() async {
    // Validate input
    if (_namaController.text.isEmpty || _deskripsiController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Nama dan deskripsi tidak boleh kosong';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final community = await ApiService.updateCommunity(
        widget.community.id,
        _namaController.text,
        _deskripsiController.text,
        null,
      );

      if (community != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✓ Komunitas berhasil diperbarui!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, community);
        }
      } else {
        setState(() {
          _errorMessage = 'Gagal memperbarui komunitas. Coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Komunitas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),
            // Nama komunitas
            const Text(
              'Nama Komunitas *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'Contoh: Flutter Indonesia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Deskripsi
            const Text(
              'Deskripsi *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _deskripsiController,
              enabled: !_isLoading,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Jelaskan tentang komunitas ini...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Update button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateCommunity,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
