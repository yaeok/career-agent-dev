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
    final dateFormat = DateFormat('yyyy/MM');
    final dateRange =
        '${dateFormat.format(experience.startDate)} - ${experience.endDate != null ? dateFormat.format(experience.endDate!) : '現在'}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => context.push('/upsert-project', extra: experience),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                experience.projectName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '$dateRange  |  ${experience.role}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                experience.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (experience.technologies.isNotEmpty)
                Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children:
                      experience.technologies
                          .map((tech) => Chip(label: Text(tech)))
                          .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
