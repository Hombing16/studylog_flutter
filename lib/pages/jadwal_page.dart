import 'package:flutter/material.dart';
import '../models/academic_models.dart';
import '../theme/app_theme.dart';

class StudyLogJadwalPage extends StatefulWidget {
  final Mahasiswa mahasiswa;
  final List<MataKuliah> daftarMataKuliah;
  final int tugasAktifCount;
  final VoidCallback onOpenTugas;
  final ValueChanged<MataKuliah> onScanAbsen;

  const StudyLogJadwalPage({
    super.key,
    required this.mahasiswa,
    required this.daftarMataKuliah,
    required this.tugasAktifCount,
    required this.onOpenTugas,
    required this.onScanAbsen,
  });

  @override
  State<StudyLogJadwalPage> createState() => _StudyLogJadwalPageState();
}

class _StudyLogJadwalPageState extends State<StudyLogJadwalPage> {
  static const List<Map<String, String>> _hariTabs = [
    {'short': 'Sen', 'full': 'Senin'},
    {'short': 'Sel', 'full': 'Selasa'},
    {'short': 'Rab', 'full': 'Rabu'},
    {'short': 'Kam', 'full': 'Kamis'},
    {'short': 'Jum', 'full': 'Jumat'},
    {'short': 'Sab', 'full': 'Sabtu'},
  ];

  late String _selectedFullHari = _defaultHariIni();

  String _defaultHariIni() {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      default:
        return 'Kamis';
    }
  }

  void _tampilkanDialogScanAbsen(MataKuliah mk) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: StudyLogColors.surfaceWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: StudyLogColors.orangeSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: StudyLogColors.orange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Scan QR Presensi',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: StudyLogColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: StudyLogColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: StudyLogColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.qr_code_2_rounded,
                      size: 86,
                      color: StudyLogColors.textPrimary,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pertemuan ke-${(mk.pertemuanHadir + 1).clamp(1, mk.totalPertemuan)} dari ${mk.totalPertemuan}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: StudyLogColors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                mk.nama,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: StudyLogColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${mk.ruang} · ${mk.jam}',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: StudyLogColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Batal',
                style: TextStyle(color: StudyLogColors.textSecondary),
              ),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: StudyLogColors.orangeBright,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                widget.onScanAbsen(mk);
                setState(() {});
              },
              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: const Text(
                'Konfirmasi Hadir',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jadwalHariIni = widget.daftarMataKuliah
        .where((m) => m.dipilih && m.hari == _selectedFullHari)
        .toList();

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header seperti gambar referensi: "Jadwal Kuliah" + Ikon Lonceng
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 14, 10),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Jadwal Kuliah',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: StudyLogColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: widget.onOpenTugas,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.notifications_rounded,
                              color: StudyLogColors.textPrimary,
                              size: 24,
                            ),
                            if (widget.tugasAktifCount > 0)
                              Positioned(
                                right: 1,
                                top: 1,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: StudyLogColors.orangeBright,
                                    shape: BoxShape.circle,
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
              // Bar Tab Hari: Sen, Sel, Rab, Kam, Jum, Sab dengan garis bawah aktif
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: StudyLogColors.borderSubtle,
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: _hariTabs.map((item) {
                    final full = item['full']!;
                    final shortLabel = item['short']!;
                    final isSelected = _selectedFullHari == full;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _selectedFullHari = full),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? StudyLogColors.orangeBright
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                shortLabel,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : StudyLogColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              height: 3,
                              width: isSelected ? 42 : 0,
                              decoration: BoxDecoration(
                                color: StudyLogColors.orangeBright,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Daftar Kartu Mata Kuliah (16 Pertemuan + Kehadiran + Scan Absen)
              Expanded(
                child: jadwalHariIni.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: const BoxDecoration(
                                  color: StudyLogColors.orangeSoft,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.event_available_rounded,
                                  color: StudyLogColors.orange,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tidak ada jadwal kuliah hari $_selectedFullHari',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: StudyLogColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Gunakan waktu luang untuk sesi Fokus Belajar di Beranda.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: StudyLogColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        itemCount: jadwalHariIni.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final mk = jadwalHariIni[index];
                          return _buildCourseAttendanceCard(mk);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseAttendanceCard(MataKuliah mk) {
    final persen = mk.persentaseKehadiran;
    final ratio = (mk.pertemuanHadir / mk.totalPertemuan).clamp(0.0, 1.0);
    final isBerlangsung = mk.statusSesi == 'Sedang Berlangsung';
    final isSelesai = mk.statusSesi == 'Selesai' || mk.sudahAbsenHariIni;

    Color statusBg;
    Color statusFg;
    String statusText;

    if (mk.sudahAbsenHariIni) {
      statusBg = StudyLogColors.successBg;
      statusFg = StudyLogColors.success;
      statusText = 'Hadir Tercatat';
    } else if (isBerlangsung) {
      statusBg = const Color(0xFFFDBA74);
      statusFg = const Color(0xFF431407);
      statusText = 'Sedang Berlangsung';
    } else if (mk.statusSesi == 'Selesai') {
      statusBg = StudyLogColors.successBg;
      statusFg = StudyLogColors.success;
      statusText = 'Selesai';
    } else {
      statusBg = const Color(0xFFD4D4D8);
      statusFg = const Color(0xFF27272A);
      statusText = 'Akan Datang';
    }

    return Container(
      decoration: BoxDecoration(
        color: StudyLogColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: StudyLogColors.borderSubtle, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Atas Kartu: Jam, Status Pill, Nama Matkul, Ruang & Dosen
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mk.jam,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: StudyLogColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: statusFg,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  mk.nama,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: StudyLogColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${mk.ruang} • Dosen: ${mk.dosen}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: StudyLogColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: StudyLogColors.borderSubtle),
          // Bagian Bawah Kartu: Kehadiran 16 Pertemuan + Progress Bar + Tombol Scan Absen
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kehadiran: $persen% (${mk.pertemuanHadir}/${mk.totalPertemuan} Pertemuan)',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: StudyLogColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 5.5,
                          backgroundColor: const Color(0xFFE5E7EB),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            StudyLogColors.orangeBright,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (isBerlangsung && !mk.sudahAbsenHariIni)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: StudyLogColors.orangeBright,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => _tampilkanDialogScanAbsen(mk),
                    icon: const Icon(Icons.qr_code_scanner_rounded, size: 17),
                    label: const Text(
                      'Scan Absen',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else if (isSelesai)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: StudyLogColors.successBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 15,
                          color: StudyLogColors.success,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Tercatat',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: StudyLogColors.success,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Presensi ${mk.nama} dibuka pada ${mk.jam}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFA1A1AA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Belum Dibuka',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
