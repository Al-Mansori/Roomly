import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/home/presentation/widget/section_title.dart';
import 'package:roomly/features/home/presentation/widget/workspace_card.dart';
import 'package:roomly/features/home/presentation/bloc/cubit/workspace_cubit.dart';

class NearbyWorkspaces extends StatelessWidget {
  const NearbyWorkspaces({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkspaceCubit, WorkspaceState>(
      listenWhen: (previous, current) => current is WorkspaceError,
      listener: (context, state) {
        if (state is WorkspaceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      buildWhen: (previous, current) =>
      current is WorkspaceLoading ||
          current is WorkspaceLoaded ||
          current is WorkspaceError,
      builder: (context, state) {
        debugPrint('Current state in NearbyWorkspaces: ${state.runtimeType}');

        if (state is WorkspaceLoading) {
          return _buildLoadingState();
        }
        else if (state is WorkspaceError) {
          return _buildErrorState(context, state);
        }
        else if (state is WorkspaceLoaded) {
          debugPrint('Nearby workspaces count: ${state.nearbyWorkspaces.length}');
          return _buildLoadedState(context, state);
        }

        // Initial state - trigger load
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<WorkspaceCubit>().loadInitialData();
        });
        return _buildLoadingState();
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WorkspaceError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
              ),
              onPressed: () => context.read<WorkspaceCubit>().loadInitialData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, WorkspaceLoaded state) {
    if (state.nearbyWorkspaces.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SectionTitle('Nearby Workspaces'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.nearbyWorkspaces.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final workspace = state.nearbyWorkspaces[index];
              return WorkspaceCard(
                workspaceId: workspace.id,
                key: ValueKey(workspace.id),
                title: workspace.name,
                distance: '${workspace.distanceKm} km',
                rating: workspace.rating.toStringAsFixed(1),
                imageUrls: state.workspaceImages[workspace.id] ?? [],
                type: workspace.type,
                city: workspace.city,
                onTap: () {
                  context.push('/workspace/${workspace.id}');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No nearby workspaces found',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).disabledColor,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<WorkspaceCubit>().loadInitialData(),
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}