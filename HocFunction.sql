use QLDA;
-- viet ham tinh tuoi theo Nam Sinh
go 
create or alter function tinh_Tuoi(@namsinh int = 2000)
returns int
as begin
   return year(getdate()) - @namsinh
end
go
print N'Tuoi ban = ' + cast(dbo.tinh_tuoi(2003) as varchar)
-- print dbo.tinh_tuoi();

--ví dụ 2
-- viet ham tính trung bình lương nv theo @phong
go
create or alter function tinh_TB (@phong int =5)
returns float
as begin
   declare @LTB float;
   select @LTB = AVG(LUONG)
   from NHANVIEN
   where PHG = @phong;
   return @LTB;
end
go
print dbo.tinh_TB()

-- dum ham tren tinh tb luong phong 5

/* Ham tra ve Table don gian 
create function <Ten ham> (Tham so)
returns table
as -- ko co begin
       return cau sql
*/


-- Ham tra ve Table danh sach nhan vien voi
-- manv, tennv, phg, luong
go
create or alter function fn_Dsnv()
returns table
as
    return (select manv, tennv, phg, luong from NHANVIEN)
go
-- voi table ma Ham tra ve
-- co the select, insert, update, delete
select * from fn_Dsnv() where phg =5

update fn_Dsnv()
set LUONG = 200000
where manv = '004'


-- viet ham tra ve table don gian
-- voi manv, tennv, phai cua cac nv Nam
go
create or alter function fn_DSNVNam(@phai nvarchar(3))
returns table
as
   return (select manv, tennv, phai from NHANVIEN where PHAI = @phai);
go
select * from fn_DSNVNam(N'Nữ');


-- Ham trả về Table phức tạp
/*
create function <ten ham> (tham so)
returns @<ten bien> table (field1,field2,,...)
as begin
     return  -- phai co return
end
*/

-- ví dụ viet ham tra ve ds nhan vien voi các field 
-- manv, tennv, luonng, namsinh
go
create or alter function fn_DSNVVoiNamsinh()
returns @tableDS table (manv varchar(9), tennv nvarchar(30), luong float, namsinh int)
as begin
     insert into @tableDS
	 select manv, tennv, luong, year(NGSINH) from NHANVIEN
   return 
end
go
select * from fn_DSNVVoiNamsinh();
-- co the select, insert, ... tren table ham tra ve