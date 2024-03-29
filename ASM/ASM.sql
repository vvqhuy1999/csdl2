create database QLNhaTro;

use QlNhaTro;

create table LoaiNha(
	MaLN varchar(7) primary key,
	ThongTin nvarchar(255)
);

create table NhaTro(
	MaNT varchar(7) primary key not null,
	DienTich float not null, 
	GiaiPhong money not null,
	DiaChi nvarchar(100),
	Quan nvarchar(50),
	MoTaPR nvarchar(255),
	NgayDangTin date not null,
	LienHe varchar(7) not null,
);

create table CoLoaiNhaTro(
	MaNT varchar(7) not null,
	MaLN varchar(7) not null,
	MotNhieu int
	PRIMARY KEY (MaNT, MaLN)
);

create table NguoiDung(
	MaND varchar(7) primary key not null,
	tenNGDung nvarchar(100) not null,
	GioiTinh nvarchar(3) check ((GioiTinh = 'Nam') or (GioiTinh = N'Nữ')),
	DienThoai varchar(10),
	DiaChi nvarchar(100),
	Quan nvarchar(50),
	email nvarchar(50),
	MaNT varchar(7) not null
);

create table DanhGia(
	ID int primary key not null,
	NgDanhGia nvarchar(255),
	NhaTroDanhGia nvarchar(255),
	LikeDisLike nvarchar(7),
	MaND varchar(7) not null,
	MaNT varchar(7) not null
);

INSERT INTO LoaiNha (MaLN, ThongTin)
VALUES 
  ('LN1', N'Căn hộ chung cư'),
  ('LN2', N'Nhà riêng'),
  ('LN3', N'Phòng trọ khép kín');

  
  INSERT INTO NhaTro (MaNT, DienTich, GiaiPhong, DiaChi, Quan, MoTaPR, NgayDangTin, LienHe)
VALUES 
  ('NT1', 30, 5000000, N'123 Đường A', N'Quận 1', N'Căn hộ sổ hồng chính chủ', '2024-03-01', 'ND1'),
  ('NT2', 25, 4000000, N'456 Đường B', N'Quận 2', N'Nhà mới xây, thoáng mát', '2023-12-15', 'ND2'),
  ('NT3', 35, 6000000, N'789 Đường C', N'Quận 3', N'Nhà gần trường học, an ninh tốt', '2024-02-28', 'ND3'),
  ('NT4', 45, 8000000, N'101 Đường D', N'Quận 4', N'Căn hộ mini, tiện nghi', '2024-03-10', 'ND1'),
  ('NT5', 40, 7000000, N'234 Đường E', N'Quận 5', N'Căn hộ 2 phòng ngủ, yên tĩnh', '2024-02-15', 'ND5'),
  ('NT6', 50, 9000000, N'567 Đường F', N'Quận 6', N'Nhà 2 tầng, rộng rãi', '2024-01-30', 'ND3'),
  ('NT7', 55, 11000000, N'890 Đường G', N'Quận 7', N'Nhà có sân thượng đẹp', '2023-12-20', 'ND7'),
  ('NT8', 65, 13000000, N'133 Đường H', N'Quận 8', N'Tòa nhà tầng 3, có thang máy', '2024-01-15', 'ND2'),
  ('NT9', 60, 12000000, N'246 Đường I', N'Quận 9', N'Nhà mặt đường, kinh doanh được', '2024-02-10', 'ND9'),
  ('NT10', 70, 14000000, N'579 Đường J', N'Quận 10', N'Tòa nhà năm phòng, nhà bếp riêng', '2024-03-05', 'ND10');  


  INSERT INTO NguoiDung (MaND, tenNGDung, GioiTinh, DienThoai, DiaChi, Quan, email, MaNT)
VALUES 
  ('ND1', N'Nguyen Van A', 'Nam', '0987654321', N'123 đường 4', N'Quận 1', 'vanA@gmail.com', 'NT1'),
  ('ND2', N'Tran Thi B', N'Nữ', '0987654322', N'456 đường 5', N'Quận 2', 'thiB@gmail.com', 'NT2'),
  ('ND3', N'Le Van C', 'Nam', '0987654323', N'789 đường 6', N'Quận 3', 'vanC@gmail.com', 'NT3'),
  ('ND4', N'Pham Thi D', N'Nữ', '0987654324', N'321 đường 7', N'Quận 4', 'thiD@gmail.com', 'NT4'),
  ('ND5', N'Nguyen Van E', 'Nam', '0987654325', N'654 đường 8', N'Quận 5', 'vanE@gmail.com', 'NT5'),
  ('ND6', N'Tran Thi F', N'Nữ', '0987654326', N'987 đường 9', N'Quận 6', 'thiF@gmail.com', 'NT6'),
  ('ND7', N'Le Van G', 'Nam', '0987654327', N'111 đường 10', N'Quận 7', 'vanG@gmail.com', 'NT7'),
  ('ND8', N'Pham Thi H', N'Nữ', '0987654328', N'278 đường 11', N'Quận 8', 'thiH@gmail.com', 'NT8'),
  ('ND9', N'Nguyen Van I', 'Nam', '0987654329', N'555 đường 12', N'Quận 9', 'vanI@gmail.com', 'NT9'),
  ('ND10', N'Tran Thi J', N'Nữ', '0987654330', N'777 đường 13', N'Quận 10', 'thiJ@gmail.com', 'NT10');


  INSERT INTO DanhGia (ID, NgDanhGia, NhaTroDanhGia, LikeDisLike, MaND, MaNT)
VALUES 
  (1, N'Nguyen Van A', N'NhaTro 1', 'Like', 'ND1', 'NT1'),
  (2, N'Tran Thi B', N'NhaTro 2', 'Like', 'ND2', 'NT2'),
  (3, N'Le Van C', N'NhaTro 3', 'Dislike', 'ND3', 'NT3'),
  (4, N'Pham Thi D', N'NhaTro 4', 'Like', 'ND4', 'NT4'),
  (5, N'Nguyen Van E', N'NhaTro 5', 'Dislike', 'ND5', 'NT5'),
  (6, N'Tran Thi F', N'NhaTro 6', 'Like', 'ND6', 'NT6'),
  (7, N'Le Van G', N'NhaTro 7', 'Like', 'ND7', 'NT7'),
  (8, N'Pham Thi H', N'NhaTro 8', 'Dislike', 'ND8', 'NT8'),
  (9, N'Nguyen Van I', N'NhaTro 9', 'Like', 'ND9', 'NT9'),
  (10, N'Tran Thi J', N'NhaTro 10', 'Dislike', 'ND10', 'NT10');

  INSERT INTO CoLoaiNhaTro (MaNT, MaLN, MotNhieu)
VALUES
  ('NT1', 'LN1', 1),
  ('NT2', 'LN2', 2),
  ('NT3', 'LN3', 2),
  ('NT4', 'LN2', 3),
  ('NT5', 'LN1', 1),
  ('NT6', 'LN2', 2),
  ('NT7', 'LN3', 3),
  ('NT8', 'LN1', 1),
  ('NT9', 'LN1', 3),
  ('NT10', 'LN2', 2);


alter table CoLoaiNhaTro -- row 21
add constraint fk_CLNT_LN foreign key (MaLN) references LoaiNha(MaLN);

alter table CoLoaiNhaTro -- row 21
add constraint fk_CLNT_NT foreign key (MaNT) references NhaTro(MaNT);

alter table NguoiDung -- row 28
add constraint fk_ND_NT foreign key (MaNT) references NhaTro(MaNT);


ALTER TABLE NhaTro
ADD constraint fk_NT_ND_LienHe FOREIGN KEY (lienhe) REFERENCES NguoiDung(MaND);


alter table DanhGia --row 40
add constraint fk_DG_ND foreign key (MaND) references NguoiDung(MaND);
alter table DanhGia --row 40
add constraint fk_DG_NT foreign key (MaNT) references NhaTro(MaNT);