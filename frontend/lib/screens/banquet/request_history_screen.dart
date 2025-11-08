import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/request_feed_item.dart';
import '../../models/request_type.dart';
import '../../providers/banquet_request_provider.dart' show RequestProvider;

class RequestHistoryScreen extends StatefulWidget {
  const RequestHistoryScreen({super.key});

  static const routeName = '/request-history';

  @override
  State<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  final _dateFormat = DateFormat('d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<RequestProvider>().loadRequests(),
          child: Builder(
            builder: (context) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.errorMessage != null) {
                return ListView(
                  children: [
                    const SizedBox(height: 120),
                    Center(child: Text(provider.errorMessage!)),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () => provider.loadRequests(),
                        child: const Text('Retry'),
                      ),
                    ),
                  ],
                );
              }
              if (provider.requests.isEmpty) {
                return ListView(
                  children: const [
                    SizedBox(height: 120),
                    Center(child: Text('You have not submitted any requests yet.')),
                  ],
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = provider.requests[index];
                  return _RequestCard(
                    item: item,
                    dateFormat: _dateFormat,
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: provider.requests.length,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.item,
    required this.dateFormat,
  });

  final RequestFeedItem item;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final status = switch (item.type) {
      RequestType.banquet => item.banquet?.status ?? 'pending',
      RequestType.travel => item.travel?.status ?? 'pending',
      RequestType.retail => item.retail?.status ?? 'pending',
    };

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2962FF).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    item.type.label,
                    style: const TextStyle(color: Color(0xFF2962FF), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._details,
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: _statusColor(status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _details {
    switch (item.type) {
      case RequestType.banquet:
        final request = item.banquet!;
        final dates = request.eventDates.map(dateFormat.format).join(', ');
        return [
          Text('${request.city}, ${request.state}, ${request.country}'),
          const SizedBox(height: 8),
          Text('Dates: $dates'),
          const SizedBox(height: 8),
          Text('Guests: ${request.adults} adults, ${request.children} children'),
          const SizedBox(height: 8),
          Text('Cuisines: ${request.cuisines.map((c) => c.name).join(', ')}'),
          const SizedBox(height: 8),
          Text('Budget: ${request.budgetCurrency} ${request.budgetAmount.toStringAsFixed(0)}'),
        ];
      case RequestType.travel:
        final request = item.travel!;
        return [
          Text('${request.destinationCity}, ${request.destinationCountry}'),
          const SizedBox(height: 8),
          Text(
              'Stay: ${dateFormat.format(request.checkIn)} - ${dateFormat.format(request.checkOut)}'),
          const SizedBox(height: 8),
          Text('Guests: ${request.adults} adults, ${request.children} children'),
          const SizedBox(height: 8),
          Text('Rooms: ${request.roomsNeeded}, Purpose: ${request.purpose.name}'),
          const SizedBox(height: 8),
          Text('Budget: ${request.budgetCurrency} ${request.budgetAmount.toStringAsFixed(0)}'),
        ];
      case RequestType.retail:
        final request = item.retail!;
        return [
          Text('${request.preferredCity}, ${request.preferredCountry}'),
          const SizedBox(height: 8),
          Text('Store Type: ${request.storeType.name}'),
          const SizedBox(height: 8),
          Text(
              'Categories: ${request.productCategories.map((category) => category.name).join(', ')}'),
          const SizedBox(height: 8),
          Text('Floor Area: ${request.floorArea.toStringAsFixed(0)} sq.ft'),
          const SizedBox(height: 8),
          Text('Budget: ${request.budgetCurrency} ${request.budgetAmount.toStringAsFixed(0)}'),
        ];
    }
  }

  String get _title {
    switch (item.type) {
      case RequestType.banquet:
        return item.banquet?.eventType.name ?? 'Banquet Request';
      case RequestType.travel:
        return item.travel?.accommodationType.name ?? 'Travel Request';
      case RequestType.retail:
        return '${item.retail?.storeType.name ?? 'Retail Request'}';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF2E7D32);
      case 'in_progress':
        return const Color(0xFFFFA000);
      default:
        return const Color(0xFF2962FF);
    }
  }
}

