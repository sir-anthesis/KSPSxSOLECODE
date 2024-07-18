// Tolong masukan parameters dengan format seperti ini HitungDenda("2024-08-19", "2024-09-24", ["satu", "dua", "tiga"], 14, 1000);

const HitungDenda = (
  tanggalKembali,
  tanggalPinjam,
  daftarBuku,
  batasMaxPeminjaman,
  dendaHarian
) => {
  let lamaPeminjaman = Math.abs(
    new Date(tanggalKembali) - new Date(tanggalPinjam)
  );
  lamaPeminjaman = Math.ceil(lamaPeminjaman / (1000 * 60 * 60 * 24));

  const telatHari = lamaPeminjaman - batasMaxPeminjaman;

  if (telatHari > 0) {
    const totalDenda = telatHari * daftarBuku.length * dendaHarian;
    console.log(
      `Anda telat mengembalikan ${daftarBuku.length} buku selama ${telatHari} hari. Total denda Anda adalah Rp. ${totalDenda}`
    );
  } else {
    console.log(
      "Terimakasih sudah meminjam dan mengembalikan buku dengan tepat waktu"
    );
  }
};

HitungDenda("2024-08-30", "2024-08-10", ["satu", "dua", "tiga"], 14, 1000);
