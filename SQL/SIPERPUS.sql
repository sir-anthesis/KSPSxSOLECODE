CREATE DATABASE siperpus;

CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    alamat TEXT NOT NULL,
    no_ktp VARCHAR(20) NOT NULL,
    no_hp VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    tanggal_terdaftar DATE NOT NULL DEFAULT (CURDATE())
);

CREATE TABLE Kategori (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL
);

CREATE TABLE Buku (
    id INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    pengarang VARCHAR(100) NOT NULL,
    penerbit VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    tahun_terbit YEAR NOT NULL,
    jumlah_tersedia INT NOT NULL,
    kategori_id INT,
    FOREIGN KEY (kategori_id) REFERENCES Kategori(id)
);

CREATE TABLE Peminjaman (
    id INT AUTO_INCREMENT PRIMARY KEY,
    anggota_id INT,
    buku_id INT,
    tanggal_pinjam DATE NOT NULL,
    tanggal_batas_kembali DATE NOT NULL,
    tanggal_kembali DATE,
    denda INT DEFAULT 0,
    FOREIGN KEY (anggota_id) REFERENCES User(id),
    FOREIGN KEY (buku_id) REFERENCES Buku(id)
);

-- INITIAL DATA
INSERT INTO Kategori (nama) VALUES
('Fiksi'),
('Non-Fiksi'),
('Teknologi'),
('Sejarah'),
('Kesehatan');

INSERT INTO User (nama, alamat, no_ktp, no_hp, email) VALUES
('User 1', 'Jl. Pinang', '1234567890123456', '081234567890', 'user1@gmail.com'),
('User 2', 'Jl. Belimbing', '2345678901234567', '082345678901', 'user2@gmail.com'),
('User 3', 'Jl. Sengon', '3456789012345678', '083456789012', 'user3@gmail.com'),
('User 4', 'Jl. Kedondong', '4567890123456789', '084567890123', 'user4@gmail.com'),
('User 5', 'Jl. Sultan', '5678901234567890', '085678901234', 'user5@gmail.com');

INSERT INTO Buku (judul, pengarang, penerbit, isbn, tahun_terbit, jumlah_tersedia, kategori_id) VALUES
('To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.', '9780446310789', 1960, 5, 1),
('1984', 'George Orwell', 'Secker & Warburg', '9780451524935', 1949, 3, 1),
('Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 'Harvill Secker', '9780062316097', 2011, 4, 2),
('Educated', 'Tara Westover', 'Random House', '9780399590504', 2018, 2, 2),
('The Innovators: How a Group of Hackers, Geniuses, and Geeks Created the Digital Revolution', 'Walter Isaacson', 'Simon & Schuster', '9781476708706', 2014, 6, 3),
('Clean Code: A Handbook of Agile Software Craftsmanship', 'Robert C. Martin', 'Prentice Hall', '9780132350884', 2008, 7, 3),
('Guns, Germs, and Steel: The Fates of Human Societies', 'Jared Diamond', 'W.W. Norton & Company', '9780393317558', 1997, 3, 4),
('The History of the Ancient World: From the Earliest Accounts to the Fall of Rome', 'Susan Wise Bauer', 'W.W. Norton & Company', '9780393059748', 2007, 5, 4),
('The China Study: The Most Comprehensive Study of Nutrition Ever Conducted', 'T. Colin Campbell', 'BenBella Books', '9781932100662', 2005, 8, 5),
('How Not to Die: Discover the Foods Scientifically Proven to Prevent and Reverse Disease', 'Michael Greger', 'Flatiron Books', '9781250066114', 2015, 1, 5);

INSERT INTO Peminjaman (anggota_id, buku_id, tanggal_pinjam, tanggal_batas_kembali, tanggal_kembali, denda) VALUES
(1, 1, '2024-01-01', '2024-01-15', '2024-01-10', 0),
(1, 2, '2024-01-05', '2024-01-19', '2024-01-15', 0),
(1, 3, '2024-01-10', '2024-01-24', '2024-01-20', 0),
(2, 4, '2024-01-01', '2024-01-15', '2024-01-13', 0),
(2, 5, '2024-01-05', '2024-01-19', '2024-01-18', 0),
(2, 6, '2024-01-10', '2024-01-24', '2024-01-22', 0),
(3, 7, '2024-01-01', '2024-01-15', '2024-01-13', 0),
(3, 8, '2024-01-05', '2024-01-19', '2024-01-17', 0),
(3, 9, '2024-01-10', '2024-01-24', '2024-01-30', 6000);

-- MANIPULASI DATA
-- Tampilkan daftar buku yang tidak pernah dipinjam di oleh siapapun.
SELECT b.id, b.judul, b.pengarang, b.penerbit, b.isbn, b.tahun_terbit, b.jumlah_tersedia, k.nama AS kategori
FROM Buku b
LEFT JOIN Peminjaman p ON b.id = p.buku_id
LEFT JOIN Kategori k ON b.kategori_id = k.id
WHERE p.id IS NULL;

-- Tampilkan user yang pernah mengembalikan buku terlambat beserta dendanya
SELECT u.nama, b.judul, p.tanggal_pinjam, p.tanggal_batas_kembali, p.tanggal_kembali, p.denda
FROM User u
JOIN Peminjaman p ON u.id = p.anggota_id
JOIN Buku b on b.id = p.buku_id
WHERE p.tanggal_kembali > p.tanggal_batas_kembali AND p.denda > 0;

-- Tampilkan user dengan daftar buku yang dipinjamnya
SET @row_number = 0;
SELECT @row_number := @row_number + 1 AS No, User, Buku
FROM (SELECT u.nama AS User, GROUP_CONCAT(b.judul ORDER BY b.judul DESC SEPARATOR ', ') AS Buku FROM User u
JOIN Peminjaman p ON u.id = p.anggota_id
JOIN Buku b ON p.buku_id = b.id
GROUP BY u.id, u.nama
ORDER BY u.id ) AS subquery;


