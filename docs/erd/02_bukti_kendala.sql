-- Uji kendala LesGo: tiap baris di bawah HARUS gagal dengan galat.
USE lesgo;
INSERT INTO jenjang (nama_jenjang, rentang_kelas) VALUES ('SD','1-6');
INSERT INTO pengguna (nama,email,kata_sandi,tanggal_daftar) VALUES ('Uji','a@uii.ac.id','x','2026-11-25');
INSERT INTO modul (id_jenjang,judul,tujuan,materi,urutan) VALUES (1,'Dasar','t','m',1);
INSERT INTO kuis (id_modul,judul_kuis) VALUES (1,'Kuis 1');

-- 1. UNIQUE email -> ERROR 1062
INSERT INTO pengguna (nama,email,kata_sandi,tanggal_daftar) VALUES ('Dobel','a@uii.ac.id','x','2026-11-25');
-- 2. FK jenjang tidak ada -> ERROR 1452
INSERT INTO modul (id_jenjang,judul,tujuan,materi,urutan) VALUES (99,'Y','t','m',1);
-- 3. CHECK skor -> ERROR 3819
INSERT INTO hasil_kuis (id_pengguna,id_kuis,skor) VALUES (1,1,150);
-- 4. UNIQUE kuis per modul -> ERROR 1062
INSERT INTO kuis (id_modul,judul_kuis) VALUES (1,'Kuis dobel');
-- 5. NOT NULL kata_sandi -> ERROR 1048
INSERT INTO pengguna (nama,email,kata_sandi,tanggal_daftar) VALUES ('N','n@uii.ac.id',NULL,'2026-11-25');
