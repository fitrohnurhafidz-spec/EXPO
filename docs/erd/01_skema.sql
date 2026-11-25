-- LesGo: skema relasional dari ERD P19 (crow's foot)
-- Kelompok 9 "Agak laen" | PABW P20
-- Dijalankan dari basis data kosong. MySQL 8.0.16+ (CHECK ditegakkan).

CREATE DATABASE IF NOT EXISTS lesgo DEFAULT CHARACTER SET utf8mb4;
USE lesgo;

-- Hapus dulu dari anak ke induk agar skrip bisa dijalankan ulang
DROP TABLE IF EXISTS hasil_kuis;
DROP TABLE IF EXISTS soal;
DROP TABLE IF EXISTS kuis;
DROP TABLE IF EXISTS progres_belajar;
DROP TABLE IF EXISTS indikator_kurikulum;
DROP TABLE IF EXISTS modul;
DROP TABLE IF EXISTS pengguna;
DROP TABLE IF EXISTS jenjang;

-- Urutan buat 1: tabel tanpa FK
CREATE TABLE jenjang (
  id_jenjang   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama_jenjang VARCHAR(50)  NOT NULL,
  rentang_kelas VARCHAR(30) NOT NULL,
  PRIMARY KEY (id_jenjang),
  UNIQUE KEY uk_jenjang_nama (nama_jenjang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pengguna (
  id_pengguna    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama           VARCHAR(100) NOT NULL,
  email          VARCHAR(150) NOT NULL,
  kata_sandi     VARCHAR(255) NOT NULL,
  peran          ENUM('siswa','guru','admin') NOT NULL DEFAULT 'siswa',
  status_akun    ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  tanggal_daftar DATE NOT NULL,
  PRIMARY KEY (id_pengguna),
  UNIQUE KEY uk_pengguna_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Urutan buat 2: bergantung pada jenjang
CREATE TABLE modul (
  id_modul   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_jenjang INT UNSIGNED NOT NULL,
  judul      VARCHAR(150) NOT NULL,
  tujuan     TEXT NOT NULL,
  materi     MEDIUMTEXT NOT NULL,
  kode_contoh TEXT NULL,
  urutan     INT UNSIGNED NOT NULL,
  PRIMARY KEY (id_modul),
  UNIQUE KEY uk_modul_urutan (id_jenjang, urutan),
  CHECK (urutan >= 1),
  CONSTRAINT fk_modul_jenjang
    FOREIGN KEY (id_jenjang) REFERENCES jenjang(id_jenjang)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Urutan buat 3: bergantung pada modul / pengguna
CREATE TABLE indikator_kurikulum (
  id_indikator      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_modul          INT UNSIGNED NOT NULL,
  deskripsi         TEXT NOT NULL,
  referensi_dokumen VARCHAR(255) NOT NULL,
  PRIMARY KEY (id_indikator),
  CONSTRAINT fk_indikator_modul
    FOREIGN KEY (id_modul) REFERENCES modul(id_modul)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE kuis (
  id_kuis    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_modul   INT UNSIGNED NOT NULL,
  judul_kuis VARCHAR(150) NOT NULL,
  PRIMARY KEY (id_kuis),
  UNIQUE KEY uk_kuis_modul (id_modul),
  CONSTRAINT fk_kuis_modul
    FOREIGN KEY (id_modul) REFERENCES modul(id_modul)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE progres_belajar (
  id_pengguna     INT UNSIGNED NOT NULL,
  id_modul        INT UNSIGNED NOT NULL,
  tanggal_selesai DATE NULL,
  PRIMARY KEY (id_pengguna, id_modul),
  CONSTRAINT fk_progres_pengguna
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_progres_modul
    FOREIGN KEY (id_modul) REFERENCES modul(id_modul)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Urutan buat 4: bergantung pada kuis
CREATE TABLE soal (
  id_soal       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_kuis       INT UNSIGNED NOT NULL,
  pertanyaan    TEXT NOT NULL,
  pilihan_a     VARCHAR(255) NOT NULL,
  pilihan_b     VARCHAR(255) NOT NULL,
  pilihan_c     VARCHAR(255) NOT NULL,
  pilihan_d     VARCHAR(255) NOT NULL,
  kunci_jawaban CHAR(1) NOT NULL,
  PRIMARY KEY (id_soal),
  CHECK (kunci_jawaban IN ('A','B','C','D')),
  CONSTRAINT fk_soal_kuis
    FOREIGN KEY (id_kuis) REFERENCES kuis(id_kuis)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Urutan buat 5: bergantung pada pengguna dan kuis
CREATE TABLE hasil_kuis (
  id_hasil      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_pengguna   INT UNSIGNED NOT NULL,
  id_kuis       INT UNSIGNED NOT NULL,
  skor          DECIMAL(5,2) NOT NULL,
  tanggal_kirim DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_hasil),
  CHECK (skor BETWEEN 0 AND 100),
  CONSTRAINT fk_hasil_pengguna
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_hasil_kuis
    FOREIGN KEY (id_kuis) REFERENCES kuis(id_kuis)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SHOW TABLES;
