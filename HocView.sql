use QLDA;
--  Tao view cho user xem ds luong nhan vien
-- voi cac field manv, tennv, tenphg, luong
go
create or alter view v_XemDSLuongNV
as -- k co begin
   -- ben trong view la cau lenh select
   select manv, tennv, tenphg, luong
   from nhanvien nv join phongban pb
   on nv.phg = pb.maphg
go
select * from v_XemDSLuongNV

-- cap nhaht view 
Update v_XemDSLuongNV
set LUONG = 500000
where manv = '002'

select * from NHANVIEN where MANV = '002';


-- tao view thong ke so nv theo phong
go
create or alter view v_SoNVTheoPhongBan
as 
   select tenphg, count(*) as 'sonv'
   from nhanvien nv join phongban pb
   on nv.phg = pb.maphg
   group by TENPHG
go
select * from v_SoNVTheoPhongBan;

-- day la view read only
delete from v_SoNVTheoPhongBan;

-- tao view xem 3 nhan vien co luong cao nhat
go
create or alter view v_Top3LuongCaoNhat
as
  select top(3) luong, tennv
  from NHANVIEN
  order by LUONG desc;
go

select * from v_Top3LuongCaoNhat


-- Hien thi ds truong phong co thoi thieu 1 than nhan
/*go
create or alter view v_DSTRPCoTN
as
select distinct nv.HONV , nv.TENLOT, nv.TENNV
from NHANVIEN nv join PHONGBAN pb
on nv.phg = pb.MAPHG
join THANNHAN tn on tn.MA_NVIEN  = nv.MANV
where tn.MA_NVIEN = pb.TRPHG
go
*/
go
create or alter view v_DsTRPHGCoThanNhan
as
select HONV , TENLOT, TENNV
from NHANVIEN 
where (manv in (select TRPHG from PHONGBAN)) and (manv in (select MANV from THANNHAN))
go

select * from v_DsTRPHGCoThanNhan;

select * from v_DSTRPCoTN
