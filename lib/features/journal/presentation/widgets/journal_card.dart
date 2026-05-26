import 'package:flutter/material.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/models/journal_model.dart';

class JournalCard extends StatelessWidget {
  final JournalModel journal;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  
  const JournalCard({
    super.key,
    required this.journal,
    required this.onTap,
    required this.onFavoriteToggle,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBlack,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.goldAccent.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.goldAccent.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and favorite
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.goldAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      DateFormatter.formatDate(journal.updatedAt),
                      style: const TextStyle(
                        color: AppTheme.goldLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: journal.isFavorite
                            ? AppTheme.goldAccent.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        journal.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: journal.isFavorite
                            ? AppTheme.goldAccent
                            : AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                journal.title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Preview
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  journal.content.stripHtml(),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            
            // Tags
            if (journal.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: journal.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.goldAccent.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.goldAccent.withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: AppTheme.goldLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}