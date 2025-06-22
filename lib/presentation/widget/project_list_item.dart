import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:your_career_app/domain/model/project_experience.dart';

class ProjectListItem extends ConsumerWidget {
  const ProjectListItem({super.key, required this.experience});
  final ProjectExperience experience;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM');
    final dateRange =
        '${dateFormat.format(experience.startDate)} - ${experience.endDate != null ? dateFormat.format(experience.endDate!) : '現在'}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/upsert-project', extra: experience),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(experience.projectName, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                '$dateRange  |  ${experience.role}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                experience.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              if (experience.technologies.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children:
                      experience.technologies
                          .map(
                            (tech) => Chip(
                              label: Text(tech),
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              labelStyle: TextStyle(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
