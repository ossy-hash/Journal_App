import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/journal_model.dart';
import '../../providers/journal_provider.dart';
import '../../../auth/providers/auth_provider.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String? journalId;
  
  const EditorScreen({super.key, this.journalId});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  late QuillController _quillController;
  final _titleController = TextEditingController();
  final _tagController = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _tags = [];
  bool _isFavorite = false;
  bool _isSaving = false;
  
  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    
    if (widget.journalId != null) {
      _loadJournal();
    }
  }
  
  void _loadJournal() {
    final journals = ref.read(journalProvider).journals;
    final journal = journals.firstWhere(
      (j) => j.id == widget.journalId,
      orElse: () => JournalModel(
        title: '',
        content: '',
        userId: '',
      ),
    );
    
    _titleController.text = journal.title;
    _tags = List.from(journal.tags);
    _isFavorite = journal.isFavorite;
    
    try {
      final document = Document.fromJson(jsonDecode(journal.content));
      _quillController = QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      _quillController = QuillController.basic();
    }
  }
  
  Future<void> _saveJournal() async {
    if (_titleController.text.trim().isEmpty) return;
    
    setState(() => _isSaving = true);
    
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    
    final content = jsonEncode(_quillController.document.toDelta().toJson());
    
    final journal = JournalModel(
      id: widget.journalId,
      title: _titleController.text.trim(),
      content: content,
      tags: _tags,
      isFavorite: _isFavorite,
      userId: user.id,
    );
    
    if (widget.journalId != null) {
      await ref.read(journalProvider.notifier).updateJournal(journal);
    } else {
      await ref.read(journalProvider.notifier).createJournal(journal);
    }
    
    setState(() => _isSaving = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Journal saved successfully'),
          backgroundColor: AppTheme.goldAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      context.go('/');
    }
  }
  
  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _tagController.dispose();
    _quillController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/'),
        ),
        title: Text('Ossy', style: TextStyle(color: AppTheme.goldAccent)),
        actions: [
          // Favorite Toggle
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _isFavorite ? AppTheme.goldAccent : AppTheme.textSecondary,
            ),
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.goldAccent,
                    AppTheme.goldAccent.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.goldAccent.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isSaving ? null : _saveJournal,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryBlack,
                              ),
                            ),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_rounded,
                                color: AppTheme.primaryBlack,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Save',
                                style: TextStyle(
                                  color: AppTheme.primaryBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Title Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _titleController,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              decoration: const InputDecoration(
                hintText: 'Untitled',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          
          // Tags Section
          if (_tags.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _tags.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: InputChip(
                      label: Text(_tags[index]),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() => _tags.removeAt(index));
                      },
                      backgroundColor: AppTheme.goldAccent.withOpacity(0.1),
                      labelStyle: const TextStyle(
                        color: AppTheme.goldLight,
                        fontSize: 12,
                      ),
                      deleteIconColor: AppTheme.goldAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: AppTheme.goldAccent.withOpacity(0.2),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          
          // Add Tag Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Add tag...',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppTheme.goldAccent.withOpacity(0.2),
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addTag,
                  icon: const Icon(Icons.add_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.goldAccent.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Rich Text Editor Toolbar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceBlack,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.goldAccent.withOpacity(0.1),
                ),
              ),
            ),
            child: QuillSimpleToolbar(
              controller: _quillController,
            ),
          ),
          
          // Editor
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: QuillEditor.basic(
                controller: _quillController,
                config: const QuillEditorConfig(
                  placeholder: 'Start writing your thoughts...',
                  autoFocus: true,
                  expands: true,
                  scrollable: true,
                  showCursor: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}