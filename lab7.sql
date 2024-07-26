use QLDA;
-- Cau1) a)Nhập vào MaNV cho biết tuổi của nhân viên này.
go
create or alter function fn_Tuoi (@manv nvarchar(5))
returns int 
as begin
	declare @tuoi int;
	select  @tuoi = (year(getdate()) - year(NGSINH)) from NHANVIEN where MANV = @manv;
	 return @tuoi;
end
go
print dbo.fn_Tuoi('001');

-- Cau1) b)Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia.
go 
create or alter function fn_SLDeAn (@manv nvarchar(5))
returns int
as begin
	declare @slDean int;
	select @slDean = count(@manv) from PHANCONG where MA_NVIEN = @manv;
	return @slDean;
end
go
print dbo.fn_SLDeAn('008');

-- Cau1) c)Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái
go
create or alter function fn_SLNVTheoPhai (@phai nvarchar(3))
returns int
as begin 
	declare @SLPhai int;
	select @SLPhai = count(*) from NHANVIEN  where PHAI = @phai
	return @SLPhai;
end
go
print dbo.fn_SLNVTheoPhai(N'Nam');

-- Cau1) d)Truyền tham số đầu vào là tên phòng, tính mức lương trung bình của phòng đó, Cho biết
-- họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình
-- của phòng đó.
go
create or alter function fn_InputTenPhong (@tenphg nvarchar(50))
returns @tableDSTenPHG table (honv nvarchar(10),tenlot nvarchar(10), tennv nvarchar(20))
as begin
	declare @maphg int;
	select  @maphg = MAPHG from PHONGBAN where TENPHG = @tenphg;
	insert into @tableDSTenPHG
	select HONV, TENLOT, TENNV
	from NHANVIEN
	where (phg = @maphg) and (luong > (select AVG(luong) from NHANVIEN where @maphg = PHG));
	return
end
go

select * from dbo.fn_InputTenPhong(N'Nghiên cứu');

-- Cau1) e)Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên người trưởng phòng
-- và số lượng đề án mà phòng ban đó chủ trì.
go
create or alter function fn_InputMaPhong(@maPhg int)
returns @tableTenDA_Ho_Ten_SlDA table (tenphg nvarchar(30),honv nvarchar(10),tenlot nvarchar(10), tennv nvarchar(20),sl int)
as begin
	insert into @tableTenDA_Ho_Ten_SlDA
	select pb.TENPHG, nv.HONV, nv.TENLOT, nv.TENNV, count(da.PHONG)
	from PHONGBAN pb
	join NHANVIEN nv on nv.PHG = pb.MAPHG
	join DEAN da on pb.MAPHG = da.PHONG
	where pb.TRPHG = nv.MANV and da.PHONG = @maPhg
	group by da.PHONG,pb.TENPHG,nv.HONV, nv.TENLOT, nv.TENNV
	return
end
go
select * from fn_InputMaPhong(5);

-- Cau2 a)Hiển thị thông tin HoNV,TenNV,TenPHG, DiaDiemPhg.
go
create or alter view v_TT
as
	select HoNV,TenNV,TenPHG, dd.DiaDiem
	from NHANVIEN nv join PHONGBAN pb on nv.PHG =pb.MAPHG
	join DIADIEM_PHG dd on pb.MAPHG = dd.MAPHG

go
select * from v_TT;

-- Cau2 b)Hiển thị thông tin TenNv, Lương, Tuổi.
go
create or alter view v_TT_Ten_Luong_Tuoi
as
	select TENNV,LUONG, year(GETDATE())  - year(NGSINH) as Tuoi
	from NHANVIEN
go 
select * from v_TT_Ten_Luong_Tuoi;
-- Cau2 c)Hiển thị tên phòng ban và họ tên trưởng phòng
-- của phòng ban có đông nhân viên nhất
go
create or alter function fn_MaPhg_SL()
returns @table table(maphg int,sl int)
as begin
	insert into @table
	select PHG, count(PHG)
	from NHANVIEN
	group by PHG
	return
end
go

create or alter view v_TT_TenPB_HoTenTRP
as
	select top(1) pb.TENPHG, nv.HONV,nv.TENLOT,nv.TENNV ,tb.sl
	from NHANVIEN nv join PHONGBAN pb 
	on nv.PHG = pb.MAPHG
	join fn_MaPhg_SL() tb on nv.PHG = tb.maphg
	where nv.MANV = pb.TRPHG
	order by tb.sl desc
go

select * from v_TT_TenPB_HoTenTRP;


