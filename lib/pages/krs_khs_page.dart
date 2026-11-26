import 'package:flutter/material.dart';
import '../models/academic_models.dart';
import '../theme/app_theme.dart';
import '../widgets/studylog_charts.dart';

class StudyLogKrsKhsPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final List<MataKuliah> daftarMataKuliah;
  final int totalSksDipilih;
  final void Function(int index, bool? value) onToggleMk;
  final List<RiwayatSemester> riwayatSemester;
  final List<NilaiMataKuliah> transkripTerbaru;

  const StudyLogKrsKhsPage({
    super.key,
    required this.mahasiswa,
    required this.daftarMataKuliah,
    required this.totalSksDipilih,
    required this.onToggleMk,
    required this.riwayatSemester,
    required this.transkripTerbaru,
  });

  @override
  State<StudyLogKrsKhsPage> createState() => _StudyLogKrsKhsPageState();
}

class _StudyLogKrsKhsPageState extends State<StudyLogKrsKhsPage> {
  int _subTabIndex = 0; // 0 = KRS, 1 = KHS

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _subTabIndex == 0
                          ? 'PENGISIAN RENCANA STUDI'
                          : 'HASIL STUDI & TRANSKRIP',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: StudyLogColors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _subTabIndex == 0
                          ? 'Kartu Rencana Studi (KRS)'
                          : 'Kartu Hasil Studi (KHS)',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: StudyLogColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Segmented Tab Switcher KRS / KHS
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: StudyLogColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: StudyLogColors.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          _buildSubTabButton(
                            index: 0,
                            icon: Icons.menu_book_rounded,
                            label: 'KRS (Rencana Studi)',
                          ),
                          const SizedBox(width: 4),
                          _buildSubTabButton(
                            index: 1,
                            icon: Icons.description_rounded,
                            label: 'KHS (Hasil Studi)',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _subTabIndex == 0
                    ? _buildKrsContent(context)
                    : _buildKhsContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubTabButton({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _subTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _subTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? StudyLogColors.orangeBright
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : StudyLogColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : StudyLogColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKrsContent(BuildContext context) {
    final ratio =
        (widget.totalSksDipilih / widget.mahasiswa.maxSksKrs).clamp(0.0, 1.0);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: StudyLogColors.surfaceWhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: StudyLogColors.borderSubtle),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.mahasiswa.namaLengkap} · ${widget.mahasiswa.kelas}',
                        style: const TextStyle(
                          color: StudyLogColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.totalSksDipilih} / ${widget.mahasiswa.maxSksKrs} SKS',
                      style: const TextStyle(
                        color: StudyLogColors.orange,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      StudyLogColors.orangeBright,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            itemCount: widget.daftarMataKuliah.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final mk = widget.daftarMataKuliah[index];
              return Container(
                decoration: BoxDecoration(
                  color: StudyLogColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: mk.dipilih
                        ? StudyLogColors.orangeBright
                        : StudyLogColors.borderSubtle,
                    width: mk.dipilih ? 1.5 : 1,
                  ),
                ),
                child: CheckboxListTile(
                  value: mk.dipilih,
                  onChanged: (val) => widget.onToggleMk(index, val),
                  activeColor: StudyLogColors.orangeBright,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          mk.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: StudyLogColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: StudyLogColors.orangeSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${mk.sks} SKS',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: StudyLogColors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${mk.kode} · ${mk.jadwalLengkap} (${mk.ruang})\nDosen: ${mk.dosen}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: StudyLogColors.textSecondary,
                      ),
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: StudyLogColors.orangeBright,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: widget.totalSksDipilih == 0
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'KRS berhasil disimpan (${widget.totalSksDipilih} SKS) & grafik Beban SKS diperbarui!',
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: Text(
                'Simpan KRS (${widget.totalSksDipilih} SKS)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKhsContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
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
              _stat('IPK', widget.mahasiswa.ipkFormatted),
              _stat('SKS Lulus', '${widget.mahasiswa.totalSksLulus}'),
              _stat('Predikat', widget.mahasiswa.predikat),
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
                ipsValues: widget.riwayatSemester.map((e) => e.ips).toList(),
                labels: widget.riwayatSemester.map((e) => e.label).toList(),
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
        ...widget.riwayatSemester.map(
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
        ...widget.transkripTerbaru.map(
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
