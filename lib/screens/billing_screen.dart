// lib/screens/billing_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import supporting files
import 'core/custom_app_bar.dart';
import 'core/app_drawer.dart';

class BillingScreen
    extends
        StatefulWidget {
  const BillingScreen({
    super.key,
  });

  @override
  State<
    BillingScreen
  >
  createState() => _BillingScreenState();
}

class _BillingScreenState
    extends
        State<
          BillingScreen
        > {
  late final ScrollController _scrollController;
  bool _isScrolled = false;

  // Mock data for billing history
  final List<
    Map<
      String,
      dynamic
    >
  >
  billingHistory = [
    {
      "title": "Cardiology Consultation",
      "doctor": "Dr. Evelyn Reed",
      "date": "October 25, 2025",
      "amount": 150.00,
      "status": "Paid",
    },
    {
      "title": "Lipid Panel Lab Test",
      "doctor": "Pathology Labs",
      "date": "September 12, 2025",
      "amount": 75.50,
      "status": "Paid",
    },
    {
      "title": "Dermatology Follow-up",
      "doctor": "Dr. Marcus Chen",
      "date": "August 30, 2025",
      "amount": 120.00,
      "status": "Due",
    },
    {
      "title": "Annual Physical Exam",
      "doctor": "Dr. Sofia Reyes",
      "date": "July 10, 2025",
      "amount": 250.00,
      "status": "Paid",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(
      _onScroll,
    );
  }

  void _onScroll() {
    if (_scrollController.offset >
            10 &&
        !_isScrolled) {
      setState(
        () {
          _isScrolled = true;
        },
      );
    } else if (_scrollController.offset <=
            10 &&
        _isScrolled) {
      setState(
        () {
          _isScrolled = false;
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(
      _onScroll,
    );
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: CustomAppBar(
        isScrolled: _isScrolled,
        title: "Billing & Payments",
      ),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: _buildBalanceSummaryCard(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                24,
                16,
                8,
              ),
              child: Text(
                "Payment History",
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (
                context,
                index,
              ) {
                final item = billingHistory[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6.0,
                  ),
                  child: InvoiceCard(
                    title: item['title'],
                    subtitle: item['doctor'],
                    date: item['date'],
                    amount: item['amount'],
                    status: item['status'],
                  ),
                );
              },
              childCount: billingHistory.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(
        16,
      ),
      padding: const EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).primaryColor,
        borderRadius: BorderRadius.circular(
          16,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(
                  context,
                ).primaryColor.withOpacity(
                  0.3,
                ),
            blurRadius: 10,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Balance Due",
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.white.withOpacity(
                0.8,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "\$120.00",
            style: GoogleFonts.lato(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(
                context,
              ).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text(
              "Pay Now",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceCard
    extends
        StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final double amount;
  final String status;

  const InvoiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final bool isPaid =
        status ==
        'Paid';
    final Color statusColor = isPaid
        ? Colors.green.shade700
        : Colors.orange.shade800;

    return Card(
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(
        0.08,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: statusColor.withOpacity(
                0.1,
              ),
              child: Icon(
                isPaid
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                color: statusColor,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "$subtitle • $date",
                    style: GoogleFonts.lato(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${amount.toStringAsFixed(2)}",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  status,
                  style: GoogleFonts.lato(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
