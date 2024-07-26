-- tao procedure
go
create procedure sp_HelloWord -- ko co tham so
as begin
 -- noi dung cua sp
 print 'Hello world'
 end
 -- thuc hien thu tuc
 exec sp_HelloWord
 go
 -- sua doi
 alter procedure  sp_HelloWord -- ko co tham so
as begin
 -- noi dung cua sp
 print N'Chao Ban'
 end

 go
create or alter procedure sp_tong @a int, @b int  -- 2 tham so vao
as begin 
  declare @c int
  set @c = @a+@b;
  print 'Tong =' + cast(@c as varchar)
end

declare @d int
set @d = 123
exec sp_tong @d,5;


go
create or alter procedure sp_tong @a int = 1, @b int =2  -- 2 tham so vao
-- neu k truyen @a gia tri = 1
-- neu k truyen @b gia tri = 2
as begin 
  declare @c int
  set @c = @a+@b;
  print 'Tong =' + cast(@c as varchar)
end
exec sp_tong;
go
-- Thu Tuc co tham so ra
create or alter procedure sp_tong @a int = 1, @b int =2, @c int out -- 2 tham so vao
as begin 
  set @c = @a+@b;
end

declare @tong int;
exec sp_tong 7,8,@tong out
print 'Tong = ' + cast(@tong as varchar)

go
-- viet ham voi tham so vao la dai va rong tham so ra dien tich chu vi hinh chu nhat
create or alter procedure sp_CN @dai int , @rong int, @dt int out, @cv int out -- 2 tham so vao
as begin 
  set @dt = @dai * @rong;
  set @cv = (@dai + @rong) *2;
end

declare @DienTich int;
declare @ChuVi int;
exec sp_CN 7,8,@DienTich out, @ChuVi out
print 'Dien Tich = ' + cast(@DienTich as varchar)
print 'Chu Vi = ' + cast(@ChuVi as varchar)

go
create or alter procedure tong2so @a int, @b int
-- 2 tham so vao va 1 tham so ra
as begin 
   return @a + @b
end
go
declare @x int;
exec @x = tong2so 45,67;
print 'Tong = ' +  cast(@x as varchar)


-- Xem thong tin nv theo ma nv
use QLDA;
go
create or alter procedure sp_xemthongTinTheoMaNV @manv char(3)
as begin
  if(@manv not in (select manv from NHANVIEN))
     print 'K co nv nay';
  else
     select manv, tennv , phg, luong
	 from NHANVIEN where MANV = @manv
end

exec sp_xemthongTinTheoMaNV '005';



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

-- them

exec sp_themPhongban N'Bao ve',11,'017','2024-03-21';
exec sp_themPhongban N'Bao ve',11,'000','2024-03-21';