create database QuanLyNhaTro;
USE QuanLyNhaTro;
GO
/****** Object:  Table [dbo].[DANHGIA]    Script Date: 4/3/2024 8:22:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DANHGIA](
	[MAND] [char](4) NOT NULL,
	[MANT] [char](4) NOT NULL,
	[NOIDUNG] [nvarchar](50) NOT NULL,
	[YEUTHICH] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MAND] ASC,
	[MANT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAINHA]    Script Date: 4/3/2024 8:22:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAINHA](
	[MALOAI] [char](4) NOT NULL,
	[TENLOAI] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MALOAI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NGUOIDUNG]    Script Date: 4/3/2024 8:22:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NGUOIDUNG](
	[MAND] [char](4) NOT NULL,
	[HOTEN] [nvarchar](50) NOT NULL,
	[GIOITINH] [bit] NOT NULL,
	[DIENTHOAI] [varchar](12) NOT NULL,
	[DIACHI] [nvarchar](50) NOT NULL,
	[EMAIL] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MAND] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHATRO]    Script Date: 4/3/2024 8:22:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHATRO](
	[MANT] [char](4) NOT NULL,
	[DIENTICH] [float] NOT NULL,
	[GIAPHONG] [float] NOT NULL,
	[DIACHI] [nvarchar](50) NOT NULL,
	[QUAN] [nvarchar](20) NOT NULL,
	[MOTA] [nvarchar](50) NOT NULL,
	[NGAYDANGTIN] [date] NOT NULL,
	[MALOAI] [char](4) NOT NULL,
	[MAND] [char](4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MANT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[DANHGIA] ([MAND], [MANT], [NOIDUNG], [YEUTHICH]) VALUES (N'u02 ', N'nt01', N'chất lượng tạm được, hơi chật', 1)
INSERT [dbo].[DANHGIA] ([MAND], [MANT], [NOIDUNG], [YEUTHICH]) VALUES (N'u02 ', N'nt09', N'chất lượng ổn hơn các nơi khác', 1)
INSERT [dbo].[DANHGIA] ([MAND], [MANT], [NOIDUNG], [YEUTHICH]) VALUES (N'u02 ', N'nt10', N'yên tĩnh, tiện nghi hơi tê', 0)
INSERT [dbo].[DANHGIA] ([MAND], [MANT], [NOIDUNG], [YEUTHICH]) VALUES (N'u04 ', N'nt02', N'rất thích nơi này, yên tĩnh, tiện nghi', 1)
INSERT [dbo].[DANHGIA] ([MAND], [MANT], [NOIDUNG], [YEUTHICH]) VALUES (N'u04 ', N'nt06', N'thích nhất nơi này, tiện nghi tốt', 1)
INSERT [dbo].[DANHGIA] ([MAND], [MANT], [NOIDUNG], [YEUTHICH]) VALUES (N'u05 ', N'nt01', N'chất lượng tốt, giá hơi đắt', 1)
INSERT [dbo].[DANHGIA] ([MAND], [MANT], [NOIDUNG], [YEUTHICH]) VALUES (N'u08 ', N'nt03', N'tiện nghi tốt nhưng hơi đắt', 1)
INSERT [dbo].[DANHGIA] ([MAND], [MANT], [NOIDUNG], [YEUTHICH]) VALUES (N'u09 ', N'nt07', N'chất lượng tốt, giá phải chăng', 1)
INSERT [dbo].[DANHGIA] ([MAND], [MANT], [NOIDUNG], [YEUTHICH]) VALUES (N'u10 ', N'nt09', N'tạm đươc', 1)
GO
INSERT [dbo].[LOAINHA] ([MALOAI], [TENLOAI]) VALUES (N'chcc', N'Căn hộ Chung cư')
INSERT [dbo].[LOAINHA] ([MALOAI], [TENLOAI]) VALUES (N'nr  ', N'Nhà riêng')
INSERT [dbo].[LOAINHA] ([MALOAI], [TENLOAI]) VALUES (N'ptro', N'Phòng trọ')
GO
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u01 ', N'Trần Thị Lan', 0, N'1111', N'q1', N'lan@gmail')
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u02 ', N'Trần Anh', 1, N'2222', N'q12', N'tuan@yahoo')
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u03 ', N'Lê Xuân Vinh', 1, N'3333', N'qtb', N'vinh@gmail')
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u04 ', N'Nguyên Tấn Dũn', 1, N'4444', N'q1', N'lan@gmail')
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u05 ', N'Võ Thị Hiền', 0, N'5555', N'qpn', N'hien@yahoo')
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u06 ', N'Lê Trung', 1, N'6666', N'q5', N'trung@gmail')
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u07 ', N'Trần Bình', 1, N'7777', N'q6', N'binh@yahoo')
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u08 ', N'Nguyễn Thi Hoa', 0, N'8888', N'q1', N'hoa@gmail')
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u09 ', N'Bùi Tuấn Vũ', 1, N'9999', N'q8', N'vu@gmail')
INSERT [dbo].[NGUOIDUNG] ([MAND], [HOTEN], [GIOITINH], [DIENTHOAI], [DIACHI], [EMAIL]) VALUES (N'u10 ', N'Võ Tuấn Anh', 0, N'1010', N'q1', N'tuananh@gmail')
GO
INSERT [dbo].[NHATRO] ([MANT], [DIENTICH], [GIAPHONG], [DIACHI], [QUAN], [MOTA], [NGAYDANGTIN], [MALOAI], [MAND]) VALUES (N'nt01', 16.5, 4000, N'32 Nguyễn Duy Dương, phường 8', N'Quận 3', N'Máy lạnh, toalet riêng', CAST(N'2023-01-13' AS Date), N'ptro', N'u03 ')
INSERT [dbo].[NHATRO] ([MANT], [DIENTICH], [GIAPHONG], [DIACHI], [QUAN], [MOTA], [NGAYDANGTIN], [MALOAI], [MAND]) VALUES (N'nt02', 50.8, 15200, N'12 Hà Huy Giáp, phường Thạnh Lộc', N'Quận 12', N'Đầy đủ tiện nghi', CAST(N'2023-05-13' AS Date), N'chcc', N'u03 ')
INSERT [dbo].[NHATRO] ([MANT], [DIENTICH], [GIAPHONG], [DIACHI], [QUAN], [MOTA], [NGAYDANGTIN], [MALOAI], [MAND]) VALUES (N'nt03', 45, 8700.6, N'10 An Dương Vương, phường 6', N'Quận 5', N'1 trệt 2 lầu', CAST(N'2023-04-13' AS Date), N'nr  ', N'u07 ')
INSERT [dbo].[NHATRO] ([MANT], [DIENTICH], [GIAPHONG], [DIACHI], [QUAN], [MOTA], [NGAYDANGTIN], [MALOAI], [MAND]) VALUES (N'nt05', 70, 40000, N'123 Trần Hưng Đạo, phường 8', N'Quận 1', N'1 trệt, 1 lầu, 4 phòng ngủ', CAST(N'2023-03-23' AS Date), N'nr  ', N'u07 ')
INSERT [dbo].[NHATRO] ([MANT], [DIENTICH], [GIAPHONG], [DIACHI], [QUAN], [MOTA], [NGAYDANGTIN], [MALOAI], [MAND]) VALUES (N'nt06', 12, 2400, N'32 Phạm Ngọc Thạch phường 6', N'Quận 5', N'Ở ghép, toalet chung', CAST(N'2023-04-10' AS Date), N'ptro', N'u03 ')
INSERT [dbo].[NHATRO] ([MANT], [DIENTICH], [GIAPHONG], [DIACHI], [QUAN], [MOTA], [NGAYDANGTIN], [MALOAI], [MAND]) VALUES (N'nt07', 65, 40200, N'30 Nguyễn Duy Dương, phường 8', N'Quận 3', N'1 trệt, 1 lầu, đầy đủ tiện nghi', CAST(N'2023-02-13' AS Date), N'nr  ', N'u01 ')
INSERT [dbo].[NHATRO] ([MANT], [DIENTICH], [GIAPHONG], [DIACHI], [QUAN], [MOTA], [NGAYDANGTIN], [MALOAI], [MAND]) VALUES (N'nt08', 54.2, 7800, N'312 Ngô Gia Tự, phường 3', N'Quận 10', N'Máy lạnh, toalet riêng', CAST(N'2023-11-12' AS Date), N'chcc', N'u07 ')
INSERT [dbo].[NHATRO] ([MANT], [DIENTICH], [GIAPHONG], [DIACHI], [QUAN], [MOTA], [NGAYDANGTIN], [MALOAI], [MAND]) VALUES (N'nt09', 23, 9800, N'09 Trần Huy Liệu, phường 1', N'Quận TB', N'Máy lạnh, toalet riêng', CAST(N'2023-09-08' AS Date), N'ptro', N'u03 ')
INSERT [dbo].[NHATRO] ([MANT], [DIENTICH], [GIAPHONG], [DIACHI], [QUAN], [MOTA], [NGAYDANGTIN], [MALOAI], [MAND]) VALUES (N'nt10', 26.7, 12000, N'12 Hồng Bàng, phường 4', N'Quận 5', N'tolet chung', CAST(N'2023-10-21' AS Date), N'ptro', N'u07 ')
GO
ALTER TABLE [dbo].[DANHGIA]  WITH CHECK ADD FOREIGN KEY([MAND])
REFERENCES [dbo].[NGUOIDUNG] ([MAND])
GO
ALTER TABLE [dbo].[DANHGIA]  WITH CHECK ADD FOREIGN KEY([MANT])
REFERENCES [dbo].[NHATRO] ([MANT])
GO
ALTER TABLE [dbo].[NHATRO]  WITH CHECK ADD FOREIGN KEY([MALOAI])
REFERENCES [dbo].[LOAINHA] ([MALOAI])
GO
ALTER TABLE [dbo].[NHATRO]  WITH CHECK ADD FOREIGN KEY([MAND])
REFERENCES [dbo].[NGUOIDUNG] ([MAND])
GO
ALTER TABLE [dbo].[NHATRO]  WITH CHECK ADD CHECK  (([DIENTICH]>(0)))
GO
ALTER TABLE [dbo].[NHATRO]  WITH CHECK ADD CHECK  (([GIAPHONG]>(0)))