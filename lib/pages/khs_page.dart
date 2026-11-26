import 'package:flutter/material.dart';
import '../models/academic_models.dart';
import '../theme/app_theme.dart';
import '../widgets/studylog_charts.dart';

class StudyLogKhsPage extends StatelessWidget {
  final Mahasiswa mahasiswa;
  final List<RiwayatSemester> riwayatSemester;
  final List<NilaiMataKuliah> transkripTerbaru;

  const StudyLogKhsPage({
    super.key,
    required this.mahasiswa,
    required this.riwayatSemester,
    required this.transkripTerbaru,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'HASIL STUDI & TRANSKRIP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: StudyLogColors.orange,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Kartu Hasil Studi (KHS)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: StudyLogColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: StudyLogColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: StudyLogColors.borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('IPK', mahasiswa.ipkFormatted),
                    _stat('SKS Lulus', '${mahasiswa.totalSksLulus}'),
                    _stat('Predikat', mahasiswa.predikat),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: StudyLogColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: StudyLogColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tren IPS 4 Semester Terakhir',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: StudyLogColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TrenIpsLineChart(
                      ipsValues: riwayatSemester.map((e) => e.ips).toList(),
                      labels: riwayatSemester.map((e) => e.label).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'RINGKASAN IPS PER SEMESTER',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: StudyLogColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              ...riwayatSemester.map(
                (r) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: StudyLogColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: StudyLogColors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Semester ${r.semester} (${r.sks} SKS)',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: StudyLogColors.textPrimary,
                        ),
                      ),
                      Text(
                        'IPS: ${r.ips.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: StudyLogColors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'NILAI KHS SEMESTER 4',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: StudyLogColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              ...transkripTerbaru.map(
                (n) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: StudyLogColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: StudyLogColors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: StudyLogColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${n.kode} · ${n.sks} SKS',
                              style: const TextStyle(
                                fontSize: 12,
                                color: StudyLogColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: StudyLogColors.orangeSoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          n.nilaiHuruf,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: StudyLogColors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: StudyLogColors.orange,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: StudyLogColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
