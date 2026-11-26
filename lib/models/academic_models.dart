class Mahasiswa {
  final String namaPanggilan;
  final String namaLengkap;
  final String nim;
  final String jurusan;
  final String jenjang;
  final String kelas;
  final String fakultas;
  final double ipk;
  final int semester;
  final int totalSksLulus;
  final int maxSksKrs;
  final String dosenWali;
  final String email;
  final String statusAktif;

  const Mahasiswa({
    required this.namaPanggilan,
    required this.namaLengkap,
    required this.nim,
    required this.jurusan,
    required this.jenjang,
    required this.kelas,
    required this.fakultas,
    required this.ipk,
    required this.semester,
    required this.totalSksLulus,
    required this.maxSksKrs,
    required this.dosenWali,
    required this.email,
    required this.statusAktif,
  });

  String get ipkFormatted => ipk.toStringAsFixed(2).replaceAll('.', ',');

  int get ipkPercentage => ((ipk / 4.0) * 100).round();

  String get predikat => ipk >= 3.51 ? 'Cum Laude' : 'Sangat Memuaskan';

  String get inisial {
    final parts = namaLengkap.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

class MataKuliah {
  final String kode;
  final String nama;
  final int sks;
  final String hari; // Senin, Selasa, Rabu, Kamis, Jumat, Sabtu
  final String jam;
  final String ruang;
  final String dosen;
  final int totalPertemuan;
  int pertemuanHadir;
  String statusSesi; // Sedang Berlangsung, Akan Datang, Selesai
  bool sudahAbsenHariIni;
  bool dipilih;

  MataKuliah({
    required this.kode,
    required this.nama,
    required this.sks,
    required this.hari,
    required this.jam,
    required this.ruang,
    required this.dosen,
    this.totalPertemuan = 16,
    this.pertemuanHadir = 15,
    this.statusSesi = 'Akan Datang',
    this.sudahAbsenHariIni = false,
    this.dipilih = false,
  });

  String get jadwalLengkap => '$hari, $jam';

  int get persentaseKehadiran {
    if (totalPertemuan <= 0) return 0;
    return ((pertemuanHadir / totalPertemuan) * 100).round().clamp(0, 100);
  }
}

class TugasKuliah {
  final String id;
  final String judul;
  final String mataKuliah;
  final String tenggat;
  final String prioritas; // Tinggi, Sedang, Rendah
  bool selesai;

  TugasKuliah({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
    this.prioritas = 'Sedang',
    this.selesai = false,
  });

  int get urgencyRank {
    switch (prioritas) {
      case 'Tinggi':
        return 0;
      case 'Sedang':
        return 1;
      default:
        return 2;
    }
  }
}

class RiwayatSemester {
  final int semester;
  final String label;
  final double ips;
  final int sks;

  const RiwayatSemester({
    required this.semester,
    required this.label,
    required this.ips,
    required this.sks,
  });
}

class NilaiMataKuliah {
  final String kode;
  final String nama;
  final int sks;
  final String nilaiHuruf;
  final double bobot;

  const NilaiMataKuliah({
    required this.kode,
    required this.nama,
    required this.sks,
    required this.nilaiHuruf,
    required this.bobot,
  });
}
