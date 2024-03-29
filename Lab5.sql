use QLDA;
go
--Cau1 a) In ra dòng ‘Xin chào’ + @ten với @ten là 
-- tham số đầu vào là tên Tiếng Việt có dấu của bạn.
create or alter procedure sp_TiengViet @ten nvarchar(30)
as begin
	print N'Xin chào ' + @ten;
end
go
exec sp_TiengViet N'Võ Văn Quang Huy';

--Cau1 b) Nhập vào 2 số @s1,@s2. In ra câu ‘Tổng là : @tg’ với @tg=@s1+@s2.
go
create or alter procedure sp_Tg @s1 int, @s2 int
as begin
	declare @tg int;
	set @tg = @s1 + @s2;
	print N'Tong la: ' + cast(@tg as varchar(5));
end
go
exec sp_Tg 5,10;

--Cau1 c) Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n.
go
create or alter procedure toSoChan @n int , @tong int out
as begin
	set @tong =0;
	declare @i int =0;
	while (@i <= @n) 
	begin 
		if(@i % 2 = 0) set @tong = @tong + @i;
		set @i = @i +1;
	end
end
go

declare @sumChan int ;
exec toSoChan 10,@sumchan out
print 'tong = ' + cast (@sumChan as varchar)
go
-- exec sp_columns dean

--Cau1 d) Nhập vào 2 số. In ra ước chung lớn nhất của chúng theo gợi ý dưới đây:
CREATE OR ALTER PROCEDURE sp_UocChung @a int, @b int
AS BEGIN
    DECLARE @c int;

    IF (@a > @b) BEGIN
        SET @c = @a;
        SET @a = @b;
        SET @b = @c;
    END

    WHILE (@b % @a <> 0) BEGIN
        SET @c = @b % @a;
        SET @b = @a;
        SET @a = @c;
    END

    RETURN @a;
END
GO

DECLARE @uocchung int;
EXEC @uocchung = sp_UocChung 45, 27;

PRINT 'Uoc Chung lon nhat : '+ cast(@uocchung as varchar(5));
go
-- Cau2 a)Nhập vào @Manv, xuất thông tin các nhân viên theo @Manv.
create or alter procedure sp_XuatThongTinAll @manv varchar(5)
as begin 
	select * from NHANVIEN where MANV = @manv;
end
go
exec sp_XuatThongTinAll '006';
go
-- Cau2 b)Nhập vào @MaDa (mã đề án), cho biết số lượng nhân viên tham gia đề án đó.
create or alter procedure sp_SLNVThamGia @maDA int
as begin 
declare @sl int;
	if exists (select * from DEAN where MADA = @maDA)
	begin
		select @sl=count(nv.MANV)
		from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG
		join DEAN da on da.PHONG =pb.MAPHG
		where MADA = @maDA
		group by MADA
		
	end
	else 
		print 'K co de an nao ca';
	print 'So luong nhan vien tham gia de an ' + cast(@maDA as varchar(2)) + ' : '+ cast(@sl as varchar(2));
end
go
exec sp_SLNVThamGia 1;

-- Cau2 c) Nhập vào @MaDa và @Ddiem_DA (địa điểm đề án), cho biết số lượng nhân viên tham
-- gia đề án có mã đề án là @MaDa và địa điểm đề án là @Ddiem_DA
go
create or alter procedure sp_SLNVDADD @maDA int, @Ddiem_DA nvarchar(50)
as begin 
declare @slnv int = 0;
	if exists (select * from DEAN where MADA = @maDA and DDIEM_DA like @Ddiem_DA)
	begin
		select @slnv = count(nv.MANV)
		from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG
		join DEAN da on da.PHONG =pb.MAPHG
		group by da.MADA , da.DDIEM_DA
		having da.MADA = @maDA and da.DDIEM_DA = @Ddiem_DA
		
	end
	else 
		print 'K co de an hoac dia diem nao ca';
	print 'So luong nhan vien tham gia de an :' + cast(@slnv as varchar(2));
end
go
-- các ví dụ
exec sp_SLNVDADD 1, N'TP HCM';
exec sp_SLNVDADD 1, N'Vũng tàu';
exec sp_SLNVDADD 3, N'Vũng tàu';

-- Cau2 d) Nhập vào @Trphg (mã trưởng phòng), xuất thông tin các nhân viên có trưởng phòng là
-- @Trphg và các nhân viên này không có thân nhân.
go
create or alter procedure sp_TTNV @Trphg varchar(5)
as begin 
	if exists (select * from PHONGBAN where TRPHG = @Trphg )
	begin
		select nv.*
		from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG
		left join THANNHAN tn on nv.MANV = tn.MA_NVIEN
		where pb.TRPHG = @Trphg and tn.MA_NVIEN  is null;
	end
	else 
		print 'K co truong phong';
end
go
exec sp_TTNV '008';


-- Cau2 e)Nhập vào @Manv và @Mapb, kiểm tra nhân viên có mã @Manv có thuộc phòng ban có
-- mã @Mapb hay không
go
create or alter procedure sp_KTNVThuocPB @Manv varchar(5) , @Mapb int
as begin 
	if exists (select * from NHANVIEN where MANV = @Manv and PHG =  @Mapb)
	begin
		select * from NHANVIEN where MANV = @Manv and PHG =  @Mapb
	end
	else 
		print 'K co nhan vien ' + @Manv + ' thuoc Phong ban '+cast(@Mapb as varchar);
end
go
exec sp_KTNVThuocPB '001',4;

-- Cau3 a)Thêm phòng ban có tên CNTT vào csdl QLDA, các giá trị được thêm vào dưới dạng
-- tham số đầu vào, kiếm tra nếu trùng Maphg thì thông báo thêm thất bại.
go
create or alter procedure sp_themPhongban
      @tenphg nvarchar(30), @phg int,@trphg char(3) ,@ng_nhanchuc date
as begin
	
   Begin try
     insert into PHONGBAN
	 values (@tenphg,@phg,@trphg,@ng_nhanchuc)
	 print N'Thêm thành công';
   end try
   begin catch
      print N'Thêm thất bại';
	end catch
end
exec sp_themPhongban 'CNTT',11,'004','2024-03-21';

-- Cau3 b) Cập nhật phòng ban có tên CNTT thành phòng IT.
go
create or alter procedure sp_updateTenPB @tenphg nvarchar(30)
as begin
   Begin try
     update PHONGBAN
	 set TENPHG = N'IT'
	 where TENPHG = @tenphg;
	 print N'Cập nhật thành công';
   end try
   begin catch
      print N'Cập nhật thất bại';
	end catch
end
go
exec sp_updateTenPB 'CNTT';

-- Cau3 c) Thêm một nhân viên vào bảng NhanVien, tất cả giá trị đều truyền dưới dạng tham số đầu
-- vào với điều kiện:
go
create or alter procedure sp_insertNVIT 
@ho nvarchar(30),@lot nvarchar(50),@ten nvarchar(30),@manv varchar(5), 
@ngSinh datetime, @dchi nvarchar(255), @phai nvarchar(3), @luong float,@phg int = 15
as begin
	declare @ma_nql varchar(5);
	declare @tuoi int
	if(@luong<25000) set @ma_nql =  '009'
	else set @ma_nql =  '005'
	if(@phai = 'Nam')
	begin
		if(YEAR(GETDATE())- year(@ngSinh)>18  and YEAR(GETDATE())- year(@ngSinh) <65)
			set @tuoi = YEAR(GETDATE())- year(@ngSinh);
		else
		begin
			print N'Tuổi phải đúng quy định';
			rollback tran
			return;
		end
	end
	else 
	begin
		if(YEAR(GETDATE())- year(@ngSinh)>18  and YEAR(GETDATE())- year(@ngSinh) <60)
			set @tuoi = YEAR(GETDATE())- year(@ngSinh);
		else
		begin
			print N'Tuổi phải đúng quy định';
			rollback tran;
			return;
		end
	end

	 Begin try
     insert into NHANVIEN
	 values (@ho,@lot,@ten,@manv,@ngSinh, @dchi, @phai, @luong,@ma_nql,@phg)
	 print N'Thêm thành công';
   end try
   begin catch
      print N'Thêm thất bại';
	end catch
end
go
exec sp_insertNVIT N'Võ',N'Văn Quang',N'Huy','015','2001-01-10','hcm','Nam',15000
select * from NHANVIEN
delete from NHANVIEN
where MANV = '015'